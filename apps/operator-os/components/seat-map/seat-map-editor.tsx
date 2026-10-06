"use client";

import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle
} from "@vexenhanh/ui/components/alert-dialog";
import { Badge } from "@vexenhanh/ui/components/badge";
import { Button } from "@vexenhanh/ui/components/button";
import { Input } from "@vexenhanh/ui/components/input";
import { Label } from "@vexenhanh/ui/components/label";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue
} from "@vexenhanh/ui/components/select";
import { Skeleton } from "@vexenhanh/ui/components/skeleton";
import { cn } from "@vexenhanh/ui/lib/utils";
import { Armchair, CircleAlert, CircleCheck, FileX2, LoaderCircle, RefreshCw } from "lucide-react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { useId, useMemo, useState, type ReactNode } from "react";

import { ApiError } from "../../lib/auth/api-client";
import {
  cellAt,
  cellKey,
  changeCellCode,
  changeCellType,
  decksFromSeatMap,
  describeSeatMapSaveError,
  generateDecks,
  hasIssues,
  isValidDeckSize,
  MAX_COLUMNS,
  MAX_ROWS,
  MAX_SEATS,
  NAME_MAX_LENGTH,
  SEAT_TYPES,
  seatTypeInfo,
  summarizeDecks,
  toSeatMapInput,
  validateSeatMap,
  type CellPosition,
  type EditorDeck
} from "../../lib/seat-map/seat-map-editor";
import {
  createSeatMap,
  getSeatMap,
  updateSeatMap,
  type SeatMap,
  type SeatType
} from "../../lib/vehicle/vehicle-api";
import { BUTTON } from "../list-parts";
import { PageHeader } from "../page-header";
import { SeatMapDeck } from "./seat-map-deck";

type Mode = "create" | "edit" | "copy" | "view";

const CARD = "flex flex-col gap-4 rounded-xl border bg-card p-5";
const CARD_TITLE = "text-base leading-6 font-semibold text-vxn-ink";
const HELPER = "text-xs leading-[18px] text-muted-foreground";
const ERROR = "text-xs leading-[18px] text-error-600";
const EMPTY = "EMPTY";

const TITLES: Record<Mode, string> = {
  create: "Tạo sơ đồ ghế",
  edit: "Chỉnh sửa sơ đồ ghế",
  copy: "Tạo bản sao",
  view: "Xem sơ đồ ghế"
};
const NOTICES: Record<Mode, string> = {
  create: "Đặt tên, chọn số tầng và kích thước từng tầng để bắt đầu.",
  edit: "Bạn đang chỉnh sửa sơ đồ hiện có. Thay đổi được ghi nhận khi lưu.",
  copy: "Đặt tên mới và chỉnh bố trí nếu cần. Bản sao được lưu riêng; sơ đồ gốc giữ nguyên.",
  view: "Sơ đồ đang dùng cho chuyến nên chỉ có thể xem. Tạo bản sao khi cần thay đổi bố trí."
};

/**
 * Trình soạn sơ đồ ghế dùng chung cho bốn chế độ (Figma `1197:6838`; FR-OPS-03, UC-12): tạo mới, chỉnh sửa,
 * tạo bản sao (`copyFromId`) và xem chỉ đọc khi sơ đồ đang được chuyến dùng. `vehicle` có giá trị khi đi từ
 * form phương tiện — lưu xong quay lại đúng form đó.
 */
export function SeatMapEditor({
  seatMapId,
  copyFromId,
  vehicle
}: {
  seatMapId?: string;
  copyFromId?: string;
  vehicle?: string;
}) {
  const sourceId = seatMapId ?? copyFromId;
  const source = useQuery({
    queryKey: ["seat-map", sourceId],
    queryFn: () => getSeatMap(sourceId!),
    enabled: sourceId !== undefined
  });
  const backHref = vehicle ? `/vehicles/${vehicle}` : "/seat-maps";
  const title = seatMapId ? "Sơ đồ ghế" : copyFromId ? TITLES.copy : TITLES.create;

  if (sourceId && source.isError) {
    const notFound = source.error instanceof ApiError && source.error.status === 404;
    return (
      <div className="flex flex-col gap-6">
        <PageHeader title={title} description={notFound ? "Không tìm thấy sơ đồ." : "Chưa tải được dữ liệu."} />
        <div className="flex min-h-[440px] flex-col items-center justify-center gap-3 rounded-xl border bg-card px-4 text-center">
          {notFound ? (
            <FileX2 className="size-6 text-vxn-fg-3" />
          ) : (
            <CircleAlert className="size-6 text-warning-700" />
          )}
          <p className="text-base leading-6 font-semibold text-vxn-ink">
            {notFound ? "Không tìm thấy sơ đồ ghế" : "Không tải được sơ đồ ghế"}
          </p>
          <p className="max-w-md text-sm leading-5 text-muted-foreground">
            {notFound
              ? "Sơ đồ không tồn tại hoặc không thuộc nhà xe của bạn."
              : "Kiểm tra kết nối mạng rồi thử lại."}
          </p>
          {notFound ? (
            <Button asChild variant="outline" className={`${BUTTON} bg-card`}>
              <Link href="/seat-maps">Về danh sách sơ đồ</Link>
            </Button>
          ) : (
            <Button className={`${BUTTON} w-36`} onClick={() => void source.refetch()}>
              <RefreshCw className="size-[18px]" />
              Thử lại
            </Button>
          )}
        </div>
      </div>
    );
  }
  if (sourceId && source.isPending) {
    return (
      <div className="flex flex-col gap-6">
        <PageHeader title={title} description="Đang tải sơ đồ…" />
        <div
          role="status"
          aria-label="Đang tải sơ đồ ghế"
          className="grid gap-5 xl:grid-cols-[276px_minmax(0,1fr)_300px]"
        >
          <Skeleton className="h-[520px] rounded-xl" />
          <Skeleton className="h-[720px] rounded-xl" />
          <Skeleton className="h-[420px] rounded-xl" />
        </div>
      </div>
    );
  }

  const mode: Mode = seatMapId ? (source.data!.inUse ? "view" : "edit") : copyFromId ? "copy" : "create";
  return (
    <EditorBody
      // Mở sơ đồ khác (hoặc đổi luồng) thì dựng lại trình soạn với dữ liệu của sơ đồ đó.
      key={`${mode}:${sourceId ?? "new"}`}
      initialMode={mode}
      source={source.data}
      backHref={backHref}
      vehicle={vehicle}
    />
  );
}

function mostCommonType(seatMap: SeatMap): SeatType {
  const counts = new Map<SeatType, number>();
  for (const seat of seatMap.seats) {
    counts.set(seat.type, (counts.get(seat.type) ?? 0) + 1);
  }
  return [...counts].sort((a, b) => b[1] - a[1])[0]?.[0] ?? "SEAT";
}

function EditorBody({
  initialMode,
  source,
  backHref,
  vehicle
}: {
  initialMode: Mode;
  source?: SeatMap;
  backHref: string;
  vehicle?: string;
}) {
  const router = useRouter();
  const queryClient = useQueryClient();
  // Chỉnh sửa → bản sao: khi lưu mà sơ đồ vừa bị khóa, giữ bản nháp và chuyển sang lưu thành sơ đồ mới.
  const [mode, setMode] = useState<Mode>(initialMode);
  const readOnly = mode === "view";

  const [name, setName] = useState(() =>
    !source ? "" : initialMode === "copy" ? `${source.name} · Bản sao`.slice(0, NAME_MAX_LENGTH) : source.name
  );
  const [deckCount, setDeckCount] = useState<number | null>(source?.layout.decks.length ?? null);
  const [sizes, setSizes] = useState(() =>
    [0, 1].map((index) => {
      const deck = source?.layout.decks[index];
      return { rows: deck ? String(deck.rows) : "", columns: deck ? String(deck.columns) : "" };
    })
  );
  const [initialType, setInitialType] = useState<SeatType | "">(source ? mostCommonType(source) : "");
  const [decks, setDecks] = useState<EditorDeck[] | null>(source ? decksFromSeatMap(source) : null);
  const [selected, setSelected] = useState<CellPosition | null>(null);
  const [dirty, setDirty] = useState(initialMode === "copy");
  const [submitted, setSubmitted] = useState(false);
  const [nameConflict, setNameConflict] = useState<string | null>(null);
  const [saveError, setSaveError] = useState<{ kind: string; message: string } | null>(null);
  const [confirmRegenerate, setConfirmRegenerate] = useState(false);
  const [leaveTo, setLeaveTo] = useState<string | null>(null);

  const summary = useMemo(() => (decks ? summarizeDecks(decks) : null), [decks]);
  const issues = useMemo(() => (decks ? validateSeatMap(name, decks) : null), [name, decks]);
  const selectedCell = decks && selected ? cellAt(decks, selected) : undefined;

  const pendingSizes = sizes
    .slice(0, deckCount ?? 0)
    .map((size) => ({ rows: Number(size.rows), columns: Number(size.columns) }));
  const configReady =
    deckCount !== null && initialType !== "" && pendingSizes.every((size) => isValidDeckSize(size));
  // Số tầng / kích thước vừa nhập chỉ có hiệu lực khi bấm tạo lưới; lưu thì gửi đúng lưới đang hiển thị.
  const configApplied =
    decks !== null &&
    deckCount === decks.length &&
    pendingSizes.every((size, index) => size.rows === decks[index]!.rows && size.columns === decks[index]!.columns);

  function updateDecks(next: EditorDeck[]) {
    setDecks(next);
    setDirty(true);
    setSaveError(null);
  }

  function generate() {
    if (!configReady) {
      return;
    }
    updateDecks(generateDecks(pendingSizes, initialType));
    setSelected(null);
  }

  function applyType(type: SeatType | null) {
    if (decks && selected && !readOnly) {
      updateDecks(changeCellType(decks, selected, type));
    }
  }

  const save = useMutation({
    mutationFn: () => {
      const input = toSeatMapInput(name, decks!);
      return mode === "edit" ? updateSeatMap(source!.id, input) : createSeatMap(input);
    },
    onSuccess: (result) => {
      void queryClient.invalidateQueries({ queryKey: ["seat-maps"] });
      // Danh sách xe hiện tóm tắt sơ đồ đang gắn nên cũng phải tải lại.
      void queryClient.invalidateQueries({ queryKey: ["vehicles"] });
      void queryClient.invalidateQueries({ queryKey: ["vehicle"] });
      queryClient.setQueryData(["seat-map", result.id], result);
      router.push(vehicle ? `${backHref}?seatMap=${result.id}` : "/seat-maps");
    },
    onError: (error) => {
      const described = describeSeatMapSaveError(error);
      if (described.kind === "name") {
        setNameConflict(described.message);
      } else {
        setSaveError(described);
      }
    }
  });

  function submit() {
    setSubmitted(true);
    setSaveError(null);
    setNameConflict(null);
    if (!decks || !issues || hasIssues(issues)) {
      return;
    }
    save.mutate();
  }

  function leave(href: string) {
    if (dirty && !readOnly) {
      setLeaveTo(href);
    } else {
      router.push(href);
    }
  }

  const copyHref = source ? `/seat-maps/new?copyFrom=${source.id}${vehicle ? `&vehicle=${vehicle}` : ""}` : "";
  const nameError = nameConflict ?? (submitted ? issues?.name : undefined);
  const actions = (
    <>
      <Button
        type="button"
        variant="outline"
        className={`${BUTTON} w-36 bg-card`}
        disabled={save.isPending}
        onClick={() => leave(backHref)}
      >
        {vehicle ? "Về phương tiện" : "Về danh sách"}
      </Button>
      {readOnly ? (
        <Button asChild className={`${BUTTON} w-40`}>
          <Link href={copyHref}>Tạo bản sao</Link>
        </Button>
      ) : (
        <Button type="button" className={`${BUTTON} w-40`} disabled={!decks || save.isPending} onClick={submit}>
          {save.isPending && <LoaderCircle className="size-[18px] animate-spin" />}
          {save.isPending ? "Đang lưu sơ đồ…" : "Lưu sơ đồ"}
        </Button>
      )}
    </>
  );

  return (
    <div className="flex flex-col gap-6">
      <PageHeader
        title={TITLES[mode]}
        description={
          !source
            ? "Tạo bố cục mới để dùng cho phương tiện."
            : mode === "copy"
              ? `Nguồn: ${source.name} · ${source.seatCount} chỗ · Tối đa ${source.passengerCapacity} người`
              : `${source.name} · ${source.deckCount} tầng · ${source.seatCount} chỗ · Tối đa ${source.passengerCapacity} người`
        }
        actions={actions}
      />

      <p
        className={cn(
          "rounded-lg p-5 text-sm leading-5",
          readOnly ? "bg-warning-50 text-warning-700" : "bg-accent text-vxn-teal-700"
        )}
      >
        {NOTICES[mode]}
      </p>
      {saveError && (
        <div role="alert" className="flex flex-wrap items-center gap-3 rounded-lg bg-error-50 px-5 py-3.5">
          <CircleAlert className="size-5 shrink-0 text-error-600" />
          <p className="min-w-0 flex-1 text-sm leading-5 text-error-600">{saveError.message}</p>
          {saveError.kind === "inUse" && (
            <Button
              type="button"
              variant="outline"
              className={`${BUTTON} bg-card`}
              onClick={() => {
                // Giữ nguyên bản nháp, chỉ đổi đích lưu: thành một sơ đồ mới với tên khác.
                setMode("copy");
                setName((current) => `${current} · Bản sao`.slice(0, NAME_MAX_LENGTH));
                setSaveError(null);
              }}
            >
              Lưu thành bản sao
            </Button>
          )}
        </div>
      )}

      <div className="grid items-start gap-5 xl:grid-cols-[276px_minmax(0,1fr)_300px]">
        {/* ── Cấu hình bố cục ── */}
        <section aria-labelledby="seat-map-config-heading" className={CARD}>
          <h2 id="seat-map-config-heading" className={CARD_TITLE}>
            {readOnly ? "Thông tin sơ đồ" : "Cấu hình bố cục"}
          </h2>
          <Field
            label="Tên sơ đồ *"
            helper={
              readOnly
                ? "Chỉ xem"
                : mode === "copy"
                  ? "Tên mới, không trùng trong nhà xe"
                  : `Tối đa ${NAME_MAX_LENGTH} ký tự · Không trùng tên`
            }
            error={nameError}
          >
            {(control) => (
              <Input
                {...control}
                value={name}
                maxLength={NAME_MAX_LENGTH}
                placeholder="Nhập tên sơ đồ"
                disabled={readOnly}
                autoComplete="off"
                onChange={(event) => {
                  setName(event.target.value);
                  setNameConflict(null);
                  setDirty(true);
                }}
              />
            )}
          </Field>
          <Field label="Số tầng" helper="Từ 1 đến 2 tầng">
            {(control) => (
              <Select
                value={deckCount === null ? "" : String(deckCount)}
                onValueChange={(value) => setDeckCount(Number(value))}
                disabled={readOnly}
              >
                <SelectTrigger {...control}>
                  <SelectValue placeholder="Chọn số tầng" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="1">1 tầng</SelectItem>
                  <SelectItem value="2">2 tầng</SelectItem>
                </SelectContent>
              </Select>
            )}
          </Field>
          {/* Chưa chọn số tầng vẫn hiện khối tầng 1 (như thiết kế) để người dùng thấy cần nhập gì. */}
          {sizes.slice(0, deckCount ?? 1).map((size, index) => (
            <fieldset key={index} className="flex flex-col gap-2" disabled={readOnly}>
              <legend className="mb-2 text-sm leading-5 font-semibold text-vxn-fg-1">Kích thước tầng {index + 1}</legend>
              <div className="grid grid-cols-2 gap-3">
                {(
                  [
                    ["rows", "Số hàng", MAX_ROWS],
                    ["columns", "Số cột", MAX_COLUMNS]
                  ] as const
                ).map(([key, label, max]) => (
                  <Field key={key} label={label} helper={`1–${max}`}>
                    {(control) => (
                      <Input
                        {...control}
                        type="number"
                        inputMode="numeric"
                        min={1}
                        max={max}
                        placeholder="—"
                        value={size[key]}
                        onChange={(event) =>
                          setSizes((current) =>
                            current.map((item, itemIndex) =>
                              itemIndex === index ? { ...item, [key]: event.target.value } : item
                            )
                          )
                        }
                      />
                    )}
                  </Field>
                ))}
              </div>
            </fieldset>
          ))}
          {!readOnly && (
            <>
              <Field label="Loại chỗ ban đầu" helper="Dùng để khởi tạo các ô">
                {(control) => (
                  <Select value={initialType} onValueChange={(value) => setInitialType(value as SeatType)}>
                    <SelectTrigger {...control}>
                      <SelectValue placeholder="Chọn loại chỗ" />
                    </SelectTrigger>
                    <SelectContent>
                      {SEAT_TYPES.map((item) => (
                        <SelectItem key={item.type} value={item.type}>
                          {item.label}
                        </SelectItem>
                      ))}
                    </SelectContent>
                  </Select>
                )}
              </Field>
              <Button
                type="button"
                variant="outline"
                className={`${BUTTON} w-full bg-card`}
                disabled={!configReady}
                onClick={() => (decks ? setConfirmRegenerate(true) : generate())}
              >
                {decks ? "Tạo lại lưới" : "Tạo lưới"}
              </Button>
              <p className={HELPER}>
                {!configReady
                  ? "Chọn số tầng, hàng, cột và loại chỗ để tạo lưới."
                  : !decks
                    ? `Có thể trộn nhiều loại chỗ sau khi tạo lưới. Tối đa ${MAX_SEATS} chỗ trong một sơ đồ.`
                    : configApplied
                      ? "Tạo lại lưới sẽ thay thế bố cục đang sửa. Bạn sẽ được yêu cầu xác nhận."
                      : "Số tầng hoặc kích thước vừa đổi chưa áp dụng. Bấm “Tạo lại lưới” để dùng; lưu lúc này vẫn giữ lưới đang hiển thị."}
              </p>
            </>
          )}
          {decks && (
            <CellTypeList
              current={selectedCell === undefined ? undefined : (selectedCell?.type ?? null)}
              disabled={readOnly || !selected}
              onPick={applyType}
            />
          )}
          {decks && (
            <p className="text-sm leading-5 text-muted-foreground">
              {readOnly
                ? "Các thông tin và bố cục đang ở chế độ chỉ xem."
                : "Chọn từng ô để đổi mã hoặc loại chỗ. Có thể trộn 5 loại chỗ trong cùng sơ đồ."}
            </p>
          )}
        </section>

        {/* ── Bố cục sơ đồ ── */}
        <section aria-labelledby="seat-map-canvas-heading" className="flex flex-col gap-5 rounded-xl border bg-card p-6">
          <div className="flex items-center gap-2">
            <h2 id="seat-map-canvas-heading" className={`${CARD_TITLE} flex-1`}>
              Bố cục sơ đồ
            </h2>
            {summary && (
              <>
                <Badge>{summary.seatCount} chỗ</Badge>
                <Badge>{summary.passengerCapacity} người</Badge>
              </>
            )}
          </div>
          {!decks || !summary || !issues ? (
            <div className="flex min-h-[560px] flex-col items-center justify-center gap-3 text-center">
              <Armchair className="size-6 text-vxn-fg-3" />
              <p className="text-base leading-6 font-semibold text-vxn-ink">Chưa tạo lưới</p>
              <p className="max-w-sm text-sm leading-5 text-muted-foreground">
                Thiết lập cấu hình bên trái, sau đó chọn “Tạo lưới” để bố trí chỗ.
              </p>
            </div>
          ) : (
            <>
              <p className="text-sm leading-5 text-muted-foreground">
                Toàn bộ sơ đồ · {decks.length === 1 ? "Một tầng" : "Tầng 1 và tầng 2"}
                <br />
                {readOnly ? "Chế độ chỉ xem · Các vị trí được khóa." : "Chọn một ô để chỉnh mã, loại chỗ hoặc vị trí trống."}
              </p>
              {decks.map((deck, index) => (
                <SeatMapDeck
                  key={index}
                  deckIndex={index}
                  deck={deck}
                  summary={summary.decks[index]!}
                  selected={selected}
                  errors={issues.cells}
                  readOnly={readOnly}
                  onSelect={setSelected}
                />
              ))}
              <ValidationSummary summary={summary} issues={issues} showAll={submitted} />
            </>
          )}
          <p className={HELPER}>Tối đa {MAX_SEATS} chỗ · Mỗi chỗ có một mã riêng · Mỗi chỗ đôi tính thêm 1 người.</p>
        </section>

        {/* ── Chi tiết chỗ ── */}
        <section aria-labelledby="seat-map-cell-heading" className={`${CARD} xl:sticky xl:top-7`}>
          <h2 id="seat-map-cell-heading" className={CARD_TITLE}>
            {!decks ? "Chi tiết chỗ" : readOnly ? "Chỗ đang xem" : "Chỗ đang chọn"}
          </h2>
          {!decks ? (
            <p className="text-sm leading-5 text-muted-foreground">
              Sau khi tạo lưới, chọn một ô để xem và chỉnh mã, loại chỗ hoặc chuyển thành ô trống.
            </p>
          ) : !selected || selectedCell === undefined ? (
            <p className="text-sm leading-5 text-muted-foreground">
              Chọn một ô trong bố cục để {readOnly ? "xem mã và loại chỗ." : "xem và chỉnh mã, loại chỗ."}
            </p>
          ) : (
            <CellDetails
              position={selected}
              cell={selectedCell}
              error={issues?.cells.get(cellKey(selected))}
              readOnly={readOnly}
              mode={mode}
              onCodeChange={(code) => updateDecks(changeCellCode(decks, selected, code))}
              onTypeChange={applyType}
            />
          )}
        </section>
      </div>

      {decks && summary && issues && (
        <div className="sticky bottom-4 z-10 flex flex-wrap items-center gap-3 rounded-xl border bg-card px-5 py-4 shadow-sm">
          <div className="flex min-w-0 flex-1 flex-col gap-0.5">
            <p className="text-sm leading-5 font-semibold text-vxn-ink">
              {summary.seatCount} chỗ · Tối đa {summary.passengerCapacity} người ·{" "}
              {issues.layout.length === 0 && issues.cells.size === 0
                ? `Đủ ${decks.length} tầng`
                : "Còn điểm cần sửa"}
            </p>
            <p className={HELPER}>
              {readOnly
                ? "Chế độ chỉ xem · Bố cục đang được sử dụng."
                : "Kiểm tra mã chỗ và bố cục trước khi lưu."}
            </p>
          </div>
          {actions}
        </div>
      )}

      <AlertDialog open={confirmRegenerate} onOpenChange={setConfirmRegenerate}>
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>Tạo lại lưới?</AlertDialogTitle>
            <AlertDialogDescription>
              Lưới mới sẽ thay toàn bộ bố cục đang sửa: mọi ô về loại chỗ ban đầu và mã được đánh lại từ đầu.
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel>Giữ bố cục hiện tại</AlertDialogCancel>
            <AlertDialogAction onClick={generate}>Tạo lại lưới</AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>

      <AlertDialog open={leaveTo !== null} onOpenChange={(open) => !open && setLeaveTo(null)}>
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>Bỏ thay đổi chưa lưu?</AlertDialogTitle>
            <AlertDialogDescription>
              Sơ đồ đang soạn sẽ không được lưu nếu bạn rời trang này.
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel>Ở lại</AlertDialogCancel>
            <AlertDialogAction onClick={() => leaveTo && router.push(leaveTo)}>Rời trang</AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>
    </div>
  );
}

type ControlProps = { id: string; "aria-invalid": boolean; "aria-describedby": string | undefined };

function Field({
  label,
  helper,
  error,
  children
}: {
  label: string;
  helper?: string;
  error?: string;
  children: (control: ControlProps) => ReactNode;
}) {
  const id = useId();
  const noteId = `${id}-note`;
  const note = error ?? helper;
  return (
    <div className="flex min-w-0 flex-col gap-1.5">
      <Label htmlFor={id}>{label}</Label>
      {children({ id, "aria-invalid": Boolean(error), "aria-describedby": note ? noteId : undefined })}
      {note && (
        <p id={noteId} role={error ? "alert" : undefined} className={error ? ERROR : HELPER}>
          {note}
        </p>
      )}
    </div>
  );
}

/**
 * Danh sách "Loại ô": lối bấm nhanh để đổi loại cho ô đang chọn, luôn tô theo loại của ô đó (đồng bộ với ô
 * "Loại chỗ" bên phải). `current`: `undefined` = chưa chọn ô, `null` = ô trống.
 */
function CellTypeList({
  current,
  disabled,
  onPick
}: {
  current: SeatType | null | undefined;
  disabled: boolean;
  onPick: (type: SeatType | null) => void;
}) {
  return (
    <div role="group" aria-label="Loại ô" className="flex flex-col gap-1">
      <p className="text-sm leading-5 font-medium text-vxn-fg-1">Loại ô</p>
      {SEAT_TYPES.map((item) => {
        const active = current === item.type;
        return (
          <button
            key={item.type}
            type="button"
            disabled={disabled}
            aria-pressed={active}
            onClick={() => onPick(item.type)}
            className={cn(
              "flex h-9 items-center gap-2 rounded-lg p-2 text-left outline-none focus-visible:ring-[3px] focus-visible:ring-ring/50 enabled:hover:bg-muted",
              active && "bg-accent enabled:hover:bg-accent"
            )}
          >
            <span
              aria-hidden
              className={cn(
                "shrink-0 rounded-lg border",
                item.type === "SEAT" ? "size-4" : item.capacity === 2 ? "h-[22px] w-5" : "h-[22px] w-3",
                active ? "border-primary bg-primary" : "bg-muted"
              )}
            />
            <span className={cn("flex-1 text-sm leading-5 font-medium", active ? "text-accent-foreground" : "text-vxn-fg-1")}>
              {item.label}
            </span>
            <span className={HELPER}>{item.capacity} người</span>
          </button>
        );
      })}
      <button
        type="button"
        disabled={disabled}
        aria-pressed={current === null}
        onClick={() => onPick(null)}
        className={cn(
          "flex h-9 items-center gap-2 rounded-lg p-2 text-left text-sm leading-5 text-muted-foreground outline-none focus-visible:ring-[3px] focus-visible:ring-ring/50 enabled:hover:bg-muted",
          current === null && "bg-accent enabled:hover:bg-accent"
        )}
      >
        <span aria-hidden className="size-4 shrink-0 rounded-lg border" />
        Ô trống / Lối đi
      </button>
    </div>
  );
}

function CellDetails({
  position,
  cell,
  error,
  readOnly,
  mode,
  onCodeChange,
  onTypeChange
}: {
  position: CellPosition;
  cell: { code: string; type: SeatType } | null;
  error?: string;
  readOnly: boolean;
  mode: Mode;
  onCodeChange: (code: string) => void;
  onTypeChange: (type: SeatType | null) => void;
}) {
  const info = cell ? seatTypeInfo(cell.type) : null;
  return (
    <>
      <Badge>{cell ? cell.code || "Chưa có mã" : "Ô trống"}</Badge>
      {cell && (
        <Field label="Mã chỗ *" helper="1–8 ký tự A–Z, 0–9; không trùng" error={error}>
          {(control) => (
            <Input
              {...control}
              value={cell.code}
              maxLength={8}
              disabled={readOnly}
              autoComplete="off"
              onChange={(event) => onCodeChange(event.target.value)}
            />
          )}
        </Field>
      )}
      <Field label="Loại chỗ">
        {(control) => (
          <Select
            value={cell?.type ?? EMPTY}
            onValueChange={(value) => onTypeChange(value === EMPTY ? null : (value as SeatType))}
            disabled={readOnly}
          >
            <SelectTrigger {...control}>
              <SelectValue />
            </SelectTrigger>
            <SelectContent>
              {SEAT_TYPES.map((item) => (
                <SelectItem key={item.type} value={item.type}>
                  {item.label}
                </SelectItem>
              ))}
              <SelectItem value={EMPTY}>Ô trống / Lối đi</SelectItem>
            </SelectContent>
          </Select>
        )}
      </Field>
      {info && (
        <>
          <div className="flex flex-col gap-1.5 rounded-lg bg-muted p-4">
            <p className={HELPER}>Sức chứa tối đa</p>
            <p className="text-sm leading-5 font-semibold text-vxn-ink">{info.capacity} người / chỗ</p>
          </div>
          <div className="flex flex-col gap-1.5 rounded-lg bg-accent p-4 text-sm leading-5 text-vxn-teal-700">
            <p className="font-medium">
              {info.capacity === 1 ? "Giá theo chỗ" : cell!.type === "CABIN_DOUBLE" ? "Bán nguyên phòng" : "Bán nguyên chỗ"}
            </p>
            <p>
              {info.capacity === 1
                ? "Một hành khách sử dụng một chỗ."
                : "1–2 khách trong cùng booking. Giá không đổi khi chỉ có 1 khách."}
            </p>
          </div>
        </>
      )}
      <div className="flex flex-col gap-1.5 rounded-lg bg-muted p-4">
        <p className={HELPER}>Vị trí hiện tại</p>
        <p className="text-sm leading-5 font-medium text-vxn-fg-1">
          Tầng {position.deck + 1} · Hàng {position.row + 1} · Cột {position.column + 1}
        </p>
      </div>
      {cell && !readOnly && (
        <Button type="button" variant="outline" className={`${BUTTON} w-full bg-card`} onClick={() => onTypeChange(null)}>
          Chuyển thành ô trống
        </Button>
      )}
      <p className="text-sm leading-5 text-muted-foreground">
        {readOnly
          ? "Mã và loại chỗ chỉ để xem. Tạo bản sao nếu bạn cần chỉnh sửa."
          : !cell
            ? "Chọn một loại ở “Loại ô” hoặc “Loại chỗ” để đặt chỗ vào vị trí này."
            : mode === "edit"
              ? "Thay đổi sẽ cập nhật trực tiếp sơ đồ này khi bạn lưu."
              : mode === "copy"
                ? "Bản sao được lưu thành sơ đồ mới. Sơ đồ gốc giữ nguyên."
                : "Sơ đồ mới được lưu thành mẫu dùng chung của nhà xe."}
      </p>
    </>
  );
}

function ValidationSummary({
  summary,
  issues,
  showAll
}: {
  summary: NonNullable<ReturnType<typeof summarizeDecks>>;
  issues: NonNullable<ReturnType<typeof validateSeatMap>>;
  /** Lỗi bố cục (chưa có chỗ, tầng trống…) chỉ nêu sau khi người dùng bấm lưu; lỗi mã thì nêu ngay. */
  showAll: boolean;
}) {
  const problems = [
    ...(showAll || summary.seatCount > MAX_SEATS ? issues.layout : []),
    ...(issues.cells.size > 0 ? [`${issues.cells.size} ô có mã chưa hợp lệ hoặc bị trùng (viền đỏ).`] : [])
  ];
  if (problems.length > 0) {
    return (
      <div role="alert" className="flex gap-3 rounded-lg bg-error-50 p-4 text-sm leading-5 text-error-600">
        <CircleAlert className="mt-px size-5 shrink-0" />
        <ul className="flex flex-col gap-1">
          {problems.map((problem) => (
            <li key={problem}>{problem}</li>
          ))}
        </ul>
      </div>
    );
  }
  return (
    <div className="flex gap-3 rounded-lg bg-success-50 p-4 text-sm leading-5 text-success-600">
      <CircleCheck className="mt-px size-5 shrink-0" />
      <div>
        <p className="font-semibold">
          {summary.seatCount} chỗ · Sức chứa tối đa {summary.passengerCapacity} người
        </p>
        <p>
          {summary.singles} chỗ đơn + {summary.doubles} chỗ đôi
        </p>
        <p>Mã chỗ hợp lệ · Không trùng vị trí</p>
      </div>
    </div>
  );
}
