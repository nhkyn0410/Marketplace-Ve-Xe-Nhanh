"use client";

import QRCode from "qrcode";
import { useEffect, useMemo, useState, type FormEvent } from "react";

import { ApiError, apiRequest } from "../../lib/auth/api-client";
import { type AuthNotice, type AuthPortal, useAuthPortal } from "./auth-context";
import {
  AUTH_MONO,
  AuthButton,
  AuthLoading,
  AuthMain,
  AuthPage,
  BackLink,
  FieldError,
  LoginButton,
  LoginCard,
  LoginField,
  NoticeDialog,
  type NoticeTone,
  StepCard,
  StepField,
  StepHero,
  useAuthLinkClass
} from "./auth-ui";

// Luồng đăng nhập web (06 UI §7, TASK-IAM-006) dùng chung cho Operator OS và Admin: định danh → [đổi mật khẩu tạm →
// đăng nhập lại] → TOTP (enrollment lần đầu) → backup code một lần → vào app. Challenge chỉ nằm trong state React
// (memory); reload giữa chừng thì bắt đầu lại từ bước đăng nhập. Endpoint, chữ và bảng màu theo cổng (`AuthPortal`).

type LoginResponse =
  | { passwordChangeRequired: true; passwordChangeToken: string }
  | { mfaRequired: true; challengeToken: string; challengeExpiresIn: number; otpAuthUri?: string }
  | { authenticated: true };

type MfaVerifyResponse = { authenticated: true; backupCodes?: string[] };

type Step =
  | { kind: "credentials" }
  | { kind: "password-change"; token: string }
  | { kind: "mfa"; challengeToken: string; expiresInSeconds: number; otpAuthUri?: string }
  | { kind: "backup-codes"; codes: string[] }
  /** Phiên đã được cấp, đang đọc `/auth/me` để vào app. */
  | { kind: "entering" };

type Notice = { tone: NoticeTone; title: string; description: string[]; actionLabel: string };

// Nội dung hộp thoại. Lỗi luôn chung chung, không lộ tài khoản có tồn tại hay không (06 UI §7).
function buildNotices(portal: AuthPortal) {
  return {
    sessionExpired: {
      tone: "warning",
      title: "Phiên đăng nhập đã hết hạn",
      description: ["Vui lòng đăng nhập lại."],
      actionLabel: "Đăng nhập lại"
    },
    // Lớp phòng thủ thứ hai (sai scope/role): thông báo chung về phiên, không nhắc app Nhân viên.
    sessionInvalid: {
      tone: "warning",
      title: "Phiên đăng nhập không hợp lệ",
      description: ["Vui lòng đăng nhập lại."],
      actionLabel: "Đăng nhập lại"
    },
    accountLocked: {
      tone: "danger",
      title: "Tài khoản bị hạn chế",
      description: ["Tài khoản đã bị khóa hoặc vô hiệu hóa.", `Vui lòng liên hệ ${portal.texts.contact} để được hỗ trợ.`],
      actionLabel: "Đã hiểu"
    },
    loginRateLimited: {
      tone: "warning",
      title: "Bạn đã thử quá nhiều lần",
      description: ["Vui lòng chờ rồi thử đăng nhập lại."],
      actionLabel: "Đã hiểu"
    },
    mfaRateLimited: {
      tone: "warning",
      title: "Bạn đã thử quá nhiều lần",
      description: ["Vui lòng chờ rồi nhập lại mã xác thực."],
      actionLabel: "Đã hiểu"
    },
    network: {
      tone: "danger",
      title: "Không thể kết nối",
      description: ["Chưa thể kết nối đến máy chủ.", "Kiểm tra kết nối mạng rồi thử lại."],
      actionLabel: "Đã hiểu"
    },
    rejected: {
      tone: "danger",
      title: "Yêu cầu bị từ chối",
      description: ["Vui lòng tải lại trang rồi thử lại."],
      actionLabel: "Đã hiểu"
    },
    // Không tự đặt lại mật khẩu (closed enrollment, ADR-017): chỉ hướng dẫn liên hệ.
    passwordHelp: {
      tone: "warning",
      title: portal.passwordHelp?.title ?? "Cấp lại mật khẩu",
      description: portal.passwordHelp?.description ?? ["Mật khẩu do quản trị viên cấp.", "Vui lòng liên hệ quản trị viên."],
      actionLabel: "Đã hiểu"
    },
    passwordChanged: {
      tone: "success",
      title: "Đổi mật khẩu thành công",
      description: ["Vui lòng đăng nhập lại bằng mật khẩu mới", `để tiếp tục vào ${portal.texts.destination}.`],
      actionLabel: "Quay lại đăng nhập"
    },
    passwordChangeExpired: {
      tone: "warning",
      title: "Yêu cầu đã hết hạn",
      description: ["Yêu cầu đổi mật khẩu không còn hiệu lực.", "Vui lòng đăng nhập lại để tiếp tục."],
      actionLabel: "Quay lại đăng nhập"
    },
    mfaExpired: {
      tone: "warning",
      title: "Yêu cầu xác thực đã hết hạn",
      description: ["Yêu cầu đã quá thời hạn 5 phút.", "Vui lòng đăng nhập lại để tiếp tục."],
      actionLabel: "Quay lại đăng nhập"
    }
  } satisfies Record<string, Notice>;
}

type NoticeKey = keyof ReturnType<typeof buildNotices>;

/** Hộp thoại mà sau khi đóng phải quay về bước đăng nhập (challenge đã hết giá trị). */
const RESTART_AFTER: ReadonlySet<NoticeKey> = new Set(["passwordChanged", "passwordChangeExpired", "mfaExpired"]);

const SESSION_NOTICE: Record<AuthNotice, NoticeKey> = { expired: "sessionExpired", invalid: "sessionInvalid" };

/** Các bước đăng nhập web; gọi `onAuthenticated` khi cookie phiên đã được cấp. */
export function LoginFlow({ notice, onAuthenticated }: { notice?: AuthNotice; onAuthenticated: () => Promise<void> }) {
  const portal = useAuthPortal();
  const notices = useMemo(() => buildNotices(portal), [portal]);
  const [step, setStep] = useState<Step>({ kind: "credentials" });
  const [dialog, setDialog] = useState<NoticeKey | undefined>(notice ? SESSION_NOTICE[notice] : undefined);

  const restart = () => setStep({ kind: "credentials" });
  const enter = () => {
    setStep({ kind: "entering" });
    // Vào được app thì cổng gỡ component này; còn ở lại (phiên không dùng được) thì về bước đăng nhập.
    void onAuthenticated().finally(() => setStep((current) => (current.kind === "entering" ? { kind: "credentials" } : current)));
  };
  const closeDialog = () => {
    if (dialog && RESTART_AFTER.has(dialog)) {
      restart();
    }
    setDialog(undefined);
  };

  if (step.kind === "entering") {
    return <AuthLoading label="Đang chuyển tiếp…" />;
  }
  return (
    <AuthPage>
      <AuthMain>
        {step.kind === "credentials" && (
          <CredentialsStep
            onNotice={setDialog}
            onResult={(result) => {
              if ("passwordChangeRequired" in result) {
                setStep({ kind: "password-change", token: result.passwordChangeToken });
              } else if ("mfaRequired" in result) {
                setStep({
                  kind: "mfa",
                  challengeToken: result.challengeToken,
                  expiresInSeconds: result.challengeExpiresIn,
                  otpAuthUri: result.otpAuthUri
                });
              } else {
                enter();
              }
            }}
          />
        )}
        {step.kind === "password-change" && <PasswordChangeStep token={step.token} onNotice={setDialog} onRestart={restart} />}
        {step.kind === "mfa" && (
          <MfaStep
            challengeToken={step.challengeToken}
            expiresInSeconds={step.expiresInSeconds}
            otpAuthUri={step.otpAuthUri}
            onNotice={setDialog}
            onRestart={restart}
            onVerified={(codes) => (codes ? setStep({ kind: "backup-codes", codes }) : enter())}
          />
        )}
        {step.kind === "backup-codes" && <BackupCodesStep codes={step.codes} onContinue={enter} />}
      </AuthMain>
      {dialog && <NoticeDialog {...notices[dialog]} onAction={closeDialog} />}
    </AuthPage>
  );
}

type StepNotice = (notice: NoticeKey) => void;

function CredentialsStep({ onResult, onNotice }: { onResult: (result: LoginResponse) => void; onNotice: StepNotice }) {
  const portal = useAuthPortal();
  const linkClass = useAuthLinkClass();
  const [identifier, setIdentifier] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState<string>();
  const [pending, setPending] = useState(false);

  async function submit(event: FormEvent) {
    event.preventDefault();
    if (!identifier.trim() || !password) {
      setError("Vui lòng nhập tên đăng nhập và mật khẩu.");
      return;
    }
    setPending(true);
    setError(undefined);
    try {
      onResult(
        await apiRequest<LoginResponse>(portal.loginPath, {
          method: "POST",
          body: { identifier: identifier.trim(), password },
          retryOnUnauthorized: false
        })
      );
    } catch (caught) {
      const failure = failureOf(caught);
      if (failure === "invalid") {
        // Một thông báo chung cho cả hai ô: API không cho biết ô nào sai (không lộ tài khoản).
        setError(
          caught instanceof ApiError && caught.code === "AUTH_PASSWORD_CHANGE_REQUIRED"
            ? caught.message
            : "Tên đăng nhập hoặc mật khẩu không đúng"
        );
        setPassword("");
      } else {
        onNotice(
          failure === "locked" ? "accountLocked" : failure === "rateLimited" ? "loginRateLimited" : failure
        );
      }
    } finally {
      setPending(false);
    }
  }

  if (portal.id === "admin") {
    // Figma ADM-00a: thẻ trắng 420px, ô nhập kiểu "VXN / Auth field", nút "VXN / Auth button".
    return (
      <>
        {portal.loginHero}
        <div className="flex w-[420px] shrink-0 flex-col gap-[18px] rounded-2xl border bg-white p-8 shadow-[0_12px_16px_-4px_rgba(16,24,40,0.08),0_4px_6px_-2px_rgba(16,24,40,0.03)]">
          <div className="flex flex-col gap-1">
            <h1 className="text-[22px] leading-7 font-semibold text-[#181c22]">{portal.texts.loginTitle}</h1>
            <p className="text-sm leading-5 text-[#64748b]">{portal.texts.loginSubtitle}</p>
          </div>
          <form onSubmit={submit} className="flex flex-col gap-[18px]" noValidate>
            <StepField
              label="Tên đăng nhập *"
              name="identifier"
              autoComplete="username"
              placeholder={portal.texts.identifierPlaceholder}
              value={identifier}
              onChange={(event) => setIdentifier(event.target.value)}
            />
            <StepField
              label="Mật khẩu *"
              password
              name="password"
              autoComplete="current-password"
              placeholder="Nhập mật khẩu"
              value={password}
              onChange={(event) => setPassword(event.target.value)}
              error={error}
            />
            <AuthButton type="submit" loading={pending} loadingLabel="Đang đăng nhập…">
              Đăng nhập
            </AuthButton>
            <p className="text-center text-xs leading-[18px] text-[#64748b]">Bước tiếp theo: xác thực hai lớp (bắt buộc).</p>
          </form>
          {portal.loginFooter}
        </div>
      </>
    );
  }

  return (
    <>
      {portal.loginHero}
      <LoginCard>
        <h1 className="text-[26px] font-bold tracking-[-0.26px] text-[#1c1e22]">{portal.texts.loginTitle}</h1>
        <p className="text-sm text-[#94a3b8]">{portal.texts.loginSubtitle}</p>
        <form onSubmit={submit} className="flex flex-col gap-2" noValidate>
          <LoginField
            label="Tên đăng nhập"
            icon="user"
            name="identifier"
            autoComplete="username"
            placeholder={portal.texts.identifierPlaceholder}
            value={identifier}
            onChange={(event) => setIdentifier(event.target.value)}
            invalid={Boolean(error)}
          />
          <LoginField
            label="Mật khẩu"
            icon="lock"
            password
            name="password"
            autoComplete="current-password"
            placeholder="Nhập mật khẩu"
            value={password}
            onChange={(event) => setPassword(event.target.value)}
            invalid={Boolean(error)}
          />
          <FieldError>{error}</FieldError>
          {portal.passwordHelp && (
            <div className="flex justify-end">
              <button
                type="button"
                onClick={() => onNotice("passwordHelp")}
                className={`rounded text-sm leading-5 font-medium outline-none hover:underline focus-visible:ring-2 focus-visible:ring-ring ${linkClass}`}
              >
                Cần cấp lại mật khẩu?
              </button>
            </div>
          )}
          <LoginButton type="submit" loading={pending} loadingLabel="Đang đăng nhập…">
            Đăng nhập
          </LoginButton>
          <p className="text-center text-sm leading-5 text-vxn-fg-4">Xác thực bảo mật ở bước tiếp theo.</p>
          <img src="/auth/divider.svg" alt="" width={300} height={1} className="self-center" />
        </form>
        {portal.loginFooter}
      </LoginCard>
    </>
  );
}

function PasswordChangeStep({ token, onNotice, onRestart }: { token: string; onNotice: StepNotice; onRestart: () => void }) {
  const portal = useAuthPortal();
  const [password, setPassword] = useState("");
  const [confirm, setConfirm] = useState("");
  const [errors, setErrors] = useState<{ password?: string; confirm?: string }>({});
  const [pending, setPending] = useState(false);

  async function submit(event: FormEvent) {
    event.preventDefault();
    const invalid = {
      password: password.length < 12 || password.length > 128 ? "Mật khẩu chưa hợp lệ vui lòng thử lại" : undefined,
      confirm: confirm !== password ? "Mật khẩu nhập lại không khớp." : undefined
    };
    setErrors(invalid);
    if (invalid.password || invalid.confirm) {
      return;
    }
    setPending(true);
    try {
      await apiRequest("/auth/password/change-required", {
        method: "POST",
        body: { passwordChangeToken: token, newPassword: password },
        retryOnUnauthorized: false
      });
      onNotice("passwordChanged");
    } catch (caught) {
      const failure = failureOf(caught);
      if (caught instanceof ApiError && caught.status === 401) {
        onNotice("passwordChangeExpired");
      } else if (caught instanceof ApiError && caught.status === 400) {
        // Vd trùng mật khẩu tạm (`AUTH_PASSWORD_REUSE_FORBIDDEN`) hoặc sai định dạng.
        setErrors({ password: "Mật khẩu chưa hợp lệ vui lòng thử lại" });
      } else {
        onNotice(failure === "rateLimited" ? "loginRateLimited" : failure === "rejected" ? "rejected" : "network");
      }
    } finally {
      setPending(false);
    }
  }

  return (
    <>
      <StepHero
        accent="Mật khẩu mới."
        title="Khởi đầu an toàn."
        description={[`Tạo mật khẩu riêng để bảo vệ ${portal.texts.accountNoun}.`, "Bạn sẽ đăng nhập lại sau khi hoàn tất."]}
      />
      <StepCard title="Đổi mật khẩu tạm" description="Thiết lập mật khẩu mới cho lần đăng nhập đầu.">
        <form onSubmit={submit} className="flex flex-col gap-4" noValidate>
          <div className="flex flex-col gap-2">
            <StepField
              label="Mật khẩu mới"
              password
              name="newPassword"
              autoComplete="new-password"
              placeholder="Nhập mật khẩu mới"
              maxLength={128}
              value={password}
              onChange={(event) => setPassword(event.target.value)}
              helper="Từ 12 đến 128 ký tự - Phải khác mật khẩu tạm."
              error={errors.password}
            />
            <StepField
              label="Nhập lại mật khẩu mới"
              password
              name="confirmPassword"
              autoComplete="new-password"
              placeholder="Nhập lại mật khẩu mới"
              value={confirm}
              onChange={(event) => setConfirm(event.target.value)}
              error={errors.confirm}
            />
          </div>
          <div className="flex flex-col gap-2">
            <LoginButton type="submit" loading={pending} loadingLabel="Đang lưu…">
              Đổi mật khẩu
            </LoginButton>
            <BackLink onClick={onRestart} />
          </div>
        </form>
      </StepCard>
    </>
  );
}

function MfaStep({
  challengeToken,
  expiresInSeconds,
  otpAuthUri,
  onVerified,
  onNotice,
  onRestart
}: {
  challengeToken: string;
  expiresInSeconds: number;
  otpAuthUri?: string;
  onVerified: (backupCodes?: string[]) => void;
  onNotice: StepNotice;
  onRestart: () => void;
}) {
  const portal = useAuthPortal();
  const [code, setCode] = useState("");
  const [error, setError] = useState<string>();
  const [pending, setPending] = useState(false);
  const enrollment = Boolean(otpAuthUri);

  // API trả cùng một lỗi 401 cho mã sai và challenge hết hạn → tự đếm thời hạn challenge để báo đúng.
  useEffect(() => {
    const timer = setTimeout(() => onNotice("mfaExpired"), expiresInSeconds * 1000);
    return () => clearTimeout(timer);
  }, [expiresInSeconds, onNotice]);

  async function submit(event: FormEvent) {
    event.preventDefault();
    setPending(true);
    setError(undefined);
    try {
      const result = await apiRequest<MfaVerifyResponse>("/auth/mfa/verify", {
        method: "POST",
        body: { challengeToken, code: code.trim() },
        retryOnUnauthorized: false
      });
      onVerified(result.backupCodes);
    } catch (caught) {
      setCode("");
      const failure = failureOf(caught);
      if (failure === "invalid") {
        setError("Mã xác thực không hợp lệ");
      } else {
        onNotice(failure === "rateLimited" ? "mfaRateLimited" : failure === "locked" ? "accountLocked" : failure);
      }
    } finally {
      setPending(false);
    }
  }

  const codeField = (
    <StepField
      label="Mã xác thực"
      mono
      name="code"
      inputMode="text"
      autoComplete="one-time-code"
      placeholder={enrollment ? "Nhập mã xác thực" : "123456"}
      monoPlaceholder={!enrollment}
      value={code}
      onChange={(event) => setCode(event.target.value)}
      helper={
        enrollment ? (
          "Nhập mã 6 số do ứng dụng xác thực tạo."
        ) : (
          <>
            Mã 6 số từ ứng dụng xác thực hoặc mã dự phòng.
            <br />
            Mã dự phòng gồm 20 ký tự hex, có thể có gạch nối.
          </>
        )
      }
      error={error}
    />
  );
  const actions = (
    <div className="flex flex-col gap-2">
      <AuthButton type="submit" disabled={code.trim().length < 6} loading={pending} loadingLabel="Đang xác thực…">
        Xác nhận
      </AuthButton>
      <BackLink onClick={onRestart} />
    </div>
  );

  return otpAuthUri ? (
    <>
      <StepHero
        accent="Thêm một lớp bảo vệ"
        title={`cho ${portal.texts.accountNoun}.`}
        description={["Không quét được QR? Nhập khóa thiết lập vào ứng dụng.", "Sau đó, ứng dụng sẽ tạo mã 6 số để bạn xác nhận."]}
      />
      <StepCard
        title="Bật xác thực hai lớp"
        description="Quét QR để thêm tài khoản vào Google Authenticator."
        className="w-[464px] gap-3"
      >
        <form onSubmit={submit} className="flex flex-col gap-3" noValidate>
          <TotpEnrollment otpAuthUri={otpAuthUri} />
          {codeField}
          {actions}
        </form>
      </StepCard>
    </>
  ) : (
    <>
      <StepHero {...portal.texts.mfaHero} />
      <StepCard title="Xác thực hai lớp" description={`Nhập mã xác thực để vào ${portal.texts.destination}.`} className="gap-3">
        <form onSubmit={submit} className="flex flex-col gap-3" noValidate>
          {codeField}
          {actions}
        </form>
      </StepCard>
    </>
  );
}

/** QR vẽ ngay trong trình duyệt từ `otpAuthUri` (secret không gửi đi đâu) + khóa thiết lập để nhập tay. */
function TotpEnrollment({ otpAuthUri }: { otpAuthUri: string }) {
  const [qr, setQr] = useState<string>();
  const secret = secretOf(otpAuthUri);

  useEffect(() => {
    let active = true;
    // Vẽ gấp đôi kích thước hiển thị để QR vẫn sắc trên màn mật độ cao và khi thu nhỏ ở khung nhìn thấp.
    QRCode.toDataURL(otpAuthUri, { margin: 0, width: 328 })
      .then((url) => active && setQr(url))
      .catch(() => active && setQr(undefined));
    return () => {
      active = false;
    };
  }, [otpAuthUri]);

  return (
    <div className="flex flex-col gap-4">
      <div className="flex h-[164px] items-center justify-center [@media(max-height:889px)]:h-32">
        {qr ? (
          // Data URL sinh tại chỗ → <img> thường, không qua next/image.
          <img
            src={qr}
            alt="Mã QR thiết lập xác thực hai lớp"
            width={164}
            height={164}
            className="[@media(max-height:889px)]:size-32"
          />
        ) : (
          <div className="size-[164px] animate-pulse rounded bg-muted [@media(max-height:889px)]:size-32" aria-hidden />
        )}
      </div>
      {secret && (
        <div className="flex flex-col gap-2">
          <p className="text-xs leading-[18px] font-semibold text-vxn-fg-4">Khóa thiết lập do hệ thống cung cấp</p>
          <div className="flex h-9 items-center justify-between gap-3 py-1">
            <code className={`${AUTH_MONO} break-all`}>{secret.match(/.{1,4}/g)?.join(" ")}</code>
            <span className="shrink-0 text-xs leading-[18px] font-semibold text-vxn-fg-4">Chỉ đọc</span>
          </div>
        </div>
      )}
    </div>
  );
}

function BackupCodesStep({ codes, onContinue }: { codes: string[]; onContinue: () => void }) {
  const portal = useAuthPortal();
  const [copied, setCopied] = useState(false);

  async function copy() {
    try {
      await navigator.clipboard.writeText(codes.join("\n"));
      setCopied(true);
    } catch {
      setCopied(false);
    }
  }

  return (
    <>
      <StepHero
        accent="Lưu mã dự phòng."
        title="Chủ động khôi phục."
        description={["Giữ mã ở nơi an toàn để dùng khi không thể", "mở ứng dụng xác thực trên điện thoại."]}
      />
      <StepCard
        title="Mã dự phòng"
        description={
          <>
            Xác thực hai lớp đã được bật.
            <br />
            Lưu mã để dùng khi không có ứng dụng xác thực.
          </>
        }
        className="w-[580px] gap-3"
      >
        <ul className="grid grid-cols-2 gap-x-4 gap-y-2">
          {codes.map((code) => (
            <li
              key={code}
              className={`${AUTH_MONO} flex h-11 items-center justify-center rounded-lg border border-[#e4e5e7] bg-white px-3 text-center [@media(max-height:889px)]:h-9`}
            >
              {code}
            </li>
          ))}
        </ul>
        <p className="rounded-lg bg-[#fef8ec] p-3 text-sm leading-5 text-[#0a2840]">
          Danh sách này chỉ hiển thị một lần.
          <br />
          Mỗi mã dùng được một lần. Hãy lưu ở nơi an toàn.
        </p>
        <div className="flex flex-col gap-2">
          <AuthButton type="button" secondary onClick={() => void copy()}>
            {copied ? "Đã sao chép" : "Sao chép mã"}
          </AuthButton>
          <AuthButton type="button" onClick={onContinue}>
            Tôi đã lưu mã, vào {portal.texts.destination}
          </AuthButton>
        </div>
      </StepCard>
    </>
  );
}

function secretOf(otpAuthUri: string): string | undefined {
  try {
    return new URL(otpAuthUri).searchParams.get("secret") ?? undefined;
  } catch {
    return undefined;
  }
}

type Failure = "invalid" | "locked" | "rateLimited" | "rejected" | "network";

/** Phân loại lỗi gửi form: sai thông tin (hiện tại ô nhập) hay cần hộp thoại. */
function failureOf(error: unknown): Failure {
  if (error instanceof ApiError) {
    if (error.code === "AUTH_ACCOUNT_LOCKED") {
      return "locked";
    }
    if (error.status === 400 || error.status === 401) {
      return "invalid";
    }
    if (error.status === 429) {
      return "rateLimited";
    }
    if (error.status === 403) {
      return "rejected";
    }
  }
  return "network";
}
