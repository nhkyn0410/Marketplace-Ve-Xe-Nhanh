"use client";

import { Skeleton } from "@vexenhanh/ui/components/skeleton";
import { Button } from "@vexenhanh/ui/components/button";
import { CircleAlert, RefreshCw } from "lucide-react";
import { useRouter } from "next/navigation";
import { useCallback, useEffect, useState } from "react";

import { type Application, type DocumentType, isLinkInvalid } from "../../lib/register/application";
import { documentViewUrl, getApplication } from "../../lib/register/application-api";
import { forgetApplicationToken, takeApplicationToken } from "../../lib/register/application-token";
import { ApplicationEditor } from "./application-editor";
import { ApplicationStatus } from "./application-status";
import { RegisterShell } from "./register-shell";

type State =
  | { status: "loading" }
  | { status: "error" }
  | { status: "ready"; token: string; application: Application; editing: boolean };

/**
 * Trang mở từ link bảo mật trong email (UC-10 bước 3, 8): đọc token, tải hồ sơ. Nháp → form hoàn thiện hồ sơ
 * (Figma 03); chờ duyệt → trạng thái (05); cần bổ sung → trạng thái (06) rồi form. Link không còn hiệu lực → trang
 * gửi lại link (04).
 */
export function ApplicationPage() {
  const router = useRouter();
  const [state, setState] = useState<State>({ status: "loading" });

  const linkInvalid = useCallback(() => {
    forgetApplicationToken();
    router.replace("/register/resend?reason=invalid");
  }, [router]);

  const load = useCallback(async () => {
    const token = takeApplicationToken(window.location, window.history);
    if (!token) {
      linkInvalid();
      return;
    }
    setState({ status: "loading" });
    try {
      const application = await getApplication(token);
      setState({ status: "ready", token, application, editing: application.status === "DRAFT" });
    } catch (error) {
      if (isLinkInvalid(error)) {
        linkInvalid();
        return;
      }
      setState({ status: "error" });
    }
  }, [linkInvalid]);

  useEffect(() => {
    // Tải hồ sơ khi trang mở (token chỉ đọc được ở trình duyệt). Mở link mới khi trang đang mở sẵn chỉ đổi phần `#`,
    // trình duyệt không tải lại trang → nghe `hashchange` để đọc token mới.
    const reload = () => void load();
    reload();
    window.addEventListener("hashchange", reload);
    return () => window.removeEventListener("hashchange", reload);
  }, [load]);

  if (state.status === "loading") {
    return (
      <RegisterShell step={3}>
        <div role="status" aria-label="Đang tải hồ sơ" className="grid w-full gap-6 lg:grid-cols-[minmax(0,1fr)_300px]">
          <Skeleton className="h-[480px] rounded-xl" />
          <Skeleton className="h-[320px] rounded-xl" />
        </div>
      </RegisterShell>
    );
  }
  if (state.status === "error") {
    return (
      <RegisterShell step={3}>
        <div className="flex w-full max-w-[480px] flex-col items-center gap-3 rounded-2xl border bg-card p-6 text-center">
          <CircleAlert className="size-6 text-warning-700" aria-hidden />
          <p className="text-base leading-6 font-semibold text-vxn-ink">Không tải được hồ sơ</p>
          <p className="text-sm leading-5 text-muted-foreground">Không kết nối được máy chủ. Vui lòng kiểm tra kết nối và thử lại.</p>
          <Button type="button" variant="outline" className="h-10 rounded-lg bg-card px-4 text-sm font-semibold" onClick={() => void load()}>
            <RefreshCw className="size-[18px]" />
            Thử lại
          </Button>
        </div>
      </RegisterShell>
    );
  }

  const { token, application, editing } = state;
  const update = (next: Application) =>
    setState({ status: "ready", token, application: next, editing: next.status === "DRAFT" || (editing && next.status === "NEEDS_INFO") });

  async function viewDocument(type: DocumentType) {
    // Mở tab trước khi chờ API: trình duyệt chặn cửa sổ mở sau một lời gọi bất đồng bộ.
    const tab = window.open("about:blank", "_blank");
    try {
      const url = await documentViewUrl(token, type);
      if (tab) {
        tab.opener = null;
        tab.location.href = url;
      }
    } catch (error) {
      tab?.close();
      if (isLinkInvalid(error)) {
        linkInvalid();
      }
    }
  }

  if (application.status === "SUBMITTED" || (application.status === "NEEDS_INFO" && !editing)) {
    return (
      <RegisterShell step={application.status === "SUBMITTED" ? 4 : 3}>
        <ApplicationStatus
          application={application}
          onEdit={() => setState({ ...state, editing: true })}
          onViewDocument={(type) => void viewDocument(type)}
        />
      </RegisterShell>
    );
  }
  return (
    <RegisterShell step={3}>
      <ApplicationEditor
        // Hồ sơ đổi trạng thái thì dựng lại form từ dữ liệu mới.
        key={application.status}
        token={token}
        application={application}
        onChange={update}
        onLinkInvalid={linkInvalid}
        onViewDocument={(type) => void viewDocument(type)}
      />
    </RegisterShell>
  );
}
