"use client";

import { cn } from "../lib/utils";
import { applyTemplate, type PermissionGroup, type PermissionTemplate, togglePermission } from "../lib/permission-matrix";

/**
 * Ô tick quyền theo nhóm màn hình (TASK-IAM-007). Chỉ hiện quyền người thao tác được tick (`grantable`) hoặc tài khoản
 * đang có; quyền đang có mà người thao tác không có thì khóa (không cấp / gỡ được — API cũng chặn).
 */
export function PermissionChecklist<P extends string>({
  groups,
  templates = [],
  grantable,
  value,
  onChange,
  disabled = false
}: {
  groups: readonly PermissionGroup<P>[];
  templates?: readonly PermissionTemplate<P>[];
  grantable: readonly P[];
  value: readonly P[];
  onChange: (next: P[]) => void;
  disabled?: boolean;
}) {
  const visible = groups
    .map((group) => ({ ...group, items: group.items.filter((item) => grantable.includes(item.permission) || value.includes(item.permission)) }))
    .filter((group) => group.items.length > 0);

  if (visible.length === 0) {
    return <p className="rounded-lg bg-muted px-4 py-3 text-sm leading-5 text-muted-foreground">Bạn không có quyền nào để cấp cho vai trò này.</p>;
  }

  return (
    <div className="flex flex-col gap-3">
      {templates.length > 0 && (
        <div className="flex flex-wrap items-center gap-2">
          <span className="text-xs leading-[18px] text-muted-foreground">Mẫu:</span>
          {templates.map((template) => (
            <button
              key={template.id}
              type="button"
              disabled={disabled}
              onClick={() => onChange(applyTemplate(template, value, grantable))}
              className="rounded-full border bg-card px-3 py-1 text-xs leading-[18px] font-medium text-vxn-ink outline-none hover:bg-accent focus-visible:ring-2 focus-visible:ring-ring disabled:opacity-50"
            >
              {template.label}
            </button>
          ))}
        </div>
      )}
      <div className="flex max-h-[340px] flex-col gap-4 overflow-y-auto rounded-lg border p-4">
        {visible.map((group) => (
          <fieldset key={group.label} className="flex flex-col gap-2">
            <legend className="pb-1 text-xs leading-[18px] font-semibold tracking-wide text-muted-foreground uppercase">{group.label}</legend>
            {group.items.map((item) => {
              const locked = !grantable.includes(item.permission);
              return (
                <label
                  key={item.permission}
                  title={locked ? "Bạn không có quyền này nên không cấp / gỡ được." : undefined}
                  className={cn("flex items-start gap-3", locked || disabled ? "cursor-not-allowed opacity-60" : "cursor-pointer")}
                >
                  <input
                    type="checkbox"
                    aria-label={item.label}
                    checked={value.includes(item.permission)}
                    disabled={disabled || locked}
                    onChange={() => onChange(togglePermission(value, item.permission))}
                    className="mt-0.5 size-4 shrink-0 accent-[var(--primary)]"
                  />
                  <span className="flex min-w-0 flex-col">
                    <span className="text-sm leading-5 font-medium text-vxn-ink">{item.label}</span>
                    <span className="text-xs leading-[18px] text-muted-foreground">{item.description}</span>
                  </span>
                </label>
              );
            })}
          </fieldset>
        ))}
      </div>
    </div>
  );
}
