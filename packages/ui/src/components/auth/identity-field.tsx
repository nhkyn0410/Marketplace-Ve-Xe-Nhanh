"use client";

import { useState } from "react";

import { hasRecentReauth } from "../../lib/auth/reauth";
import { FormField } from "../form-field";
import { Input } from "../input";

/** Lỗi khi để trống ô xác nhận danh tính. */
export const IDENTITY_REQUIRED = "Nhập mật khẩu của bạn hoặc mã xác thực 6 số.";

/**
 * Trạng thái ô "mật khẩu hoặc mã xác thực" của một hộp thoại nhạy cảm (TASK-IAM-005 Q8). Ô chỉ hiện khi chưa có
 * bằng chứng xác nhận lại danh tính trong 5 phút gần nhất; máy chủ đòi lại thì gọi `require` để hiện lại.
 */
export function useIdentityField() {
  const [needed, setNeeded] = useState(() => !hasRecentReauth());
  const [value, setValue] = useState("");
  const [error, setError] = useState<string | null>(null);
  return {
    needed,
    value,
    error,
    /** Mật khẩu / mã để gửi kèm thao tác; `null` khi còn bằng chứng nên không cần gửi. */
    secret: needed ? value : null,
    change(next: string) {
      setValue(next);
      setError(null);
    },
    /** Kiểm trước khi gửi: cần mà để trống thì báo lỗi và trả `false`. */
    check(): boolean {
      if (needed && value === "") {
        setError(IDENTITY_REQUIRED);
        return false;
      }
      return true;
    },
    /** Máy chủ từ chối mật khẩu / mã, hoặc đòi xác nhận lại: hiện ô, xóa giá trị cũ và báo lỗi tại ô. */
    require(message: string) {
      setNeeded(true);
      setValue("");
      setError(message);
    },
    /** Sau một lần gửi mà lỗi không thuộc bước xác nhận danh tính: bằng chứng vừa lấy còn dùng được thì ẩn ô. */
    sync() {
      setNeeded(!hasRecentReauth());
      setError(null);
    }
  };
}

/**
 * Ô nhập "mật khẩu hoặc mã xác thực" (Figma "03 · Nhân viên / Hộp thoại cấp lại mật khẩu tạm"). `totp`: chỉ mã của
 * ứng dụng xác thực — cổng Admin, nơi TOTP là bắt buộc (Figma ADM-02c / 02d).
 */
export function IdentityField({
  value,
  error,
  disabled,
  totp = false,
  onChange
}: {
  value: string;
  error: string | null;
  disabled?: boolean;
  totp?: boolean;
  onChange: (value: string) => void;
}) {
  return (
    <FormField
      label={totp ? "Mã xác thực (TOTP) *" : "Mật khẩu của bạn hoặc mã xác thực *"}
      helper="Thao tác nhạy cảm cần xác nhận lại danh tính. Sau khi xác nhận, 5 phút tới không phải nhập lại."
      error={error ?? undefined}
    >
      {(control) => (
        <Input
          {...control}
          type="password"
          {...(totp ? { inputMode: "numeric" as const, autoComplete: "one-time-code" } : { autoComplete: "current-password" })}
          maxLength={totp ? 7 : 200}
          value={value}
          disabled={disabled}
          onChange={(event) => onChange(event.target.value)}
        />
      )}
    </FormField>
  );
}
