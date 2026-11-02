"use client";

import { Badge } from "@vexenhanh/ui/components/badge";
import { Button } from "@vexenhanh/ui/components/button";
import { TABLE, TABLE_CELL, TABLE_HEAD_CELL, TABLE_HEAD_ROW } from "@vexenhanh/ui/components/list-controls";
import { ChevronRight } from "lucide-react";
import Link from "next/link";

import type { PolicyVersion } from "../../lib/policy/policy-api";
import { STATE } from "../../lib/policy/policy-format";
import { formatDate } from "../../lib/user/user-format";

const COLUMNS = ["w-[16%]", "w-[15%]", "w-[17%]", "", "w-[18%]", "w-[10%]"];
const HEADINGS = ["Phiên bản", "Hiệu lực từ", "Trạng thái", "Lý do thay đổi", "Người tạo", ""];

/** Bảng "Lịch sử phiên bản" (Figma ADM-06a): mới nhất trước; "Xem" mở phiên bản (nháp thì sửa tiếp). */
export function VersionTable({ versions }: { versions: PolicyVersion[] }) {
  return (
    <div className="relative overflow-x-auto">
      <table className={`${TABLE} min-w-[640px]`}>
        <colgroup>
          {COLUMNS.map((width, index) => (
            <col key={index} className={width} />
          ))}
        </colgroup>
        <thead>
          <tr className={TABLE_HEAD_ROW}>
            {HEADINGS.map((heading, index) => (
              <th key={index} scope="col" className={TABLE_HEAD_CELL}>
                {heading || <span className="sr-only">Thao tác</span>}
              </th>
            ))}
          </tr>
        </thead>
        <tbody>
          {versions.map((version) => {
            const state = STATE[version.state];
            return (
              <tr key={version.id} className="h-[68px] border-b">
                <td className={`${TABLE_CELL} font-semibold text-vxn-ink`}>Phiên bản {version.version}</td>
                <td className={TABLE_CELL}>{formatDate(version.effectiveFrom)}</td>
                <td className={TABLE_CELL}>
                  <Badge tone={state.tone}>{state.label}</Badge>
                </td>
                <td className={TABLE_CELL}>
                  <span className="line-clamp-2">{version.changeReason ?? version.description ?? "—"}</span>
                </td>
                <td className={TABLE_CELL}>
                  <span className="break-words">{version.createdBy ?? "Hệ thống"}</span>
                </td>
                <td className={TABLE_CELL}>
                  <Button asChild variant="ghost" className="h-8 px-2 font-semibold">
                    <Link href={`/policies/versions/${version.id}`} aria-label={`Xem phiên bản ${version.version}`}>
                      Xem
                      <ChevronRight className="size-4" />
                    </Link>
                  </Button>
                </td>
              </tr>
            );
          })}
        </tbody>
      </table>
    </div>
  );
}
