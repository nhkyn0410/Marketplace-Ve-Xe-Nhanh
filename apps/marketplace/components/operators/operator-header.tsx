"use client";

import Link from "next/link";
import { Phone, Mail, MapPin, CheckCircle2 } from "lucide-react";
import { OperatorProfileData } from "../../lib/data/types";

interface OperatorHeaderProps {
  readonly operator: OperatorProfileData;
}

/**
 * Khối Header thông tin nhà xe (SCR-PSG-17) chuẩn theo Figma 1443:12312.
 */
export function OperatorHeader({ operator }: OperatorHeaderProps) {
  return (
    <div className="bg-white rounded-2xl border border-slate-200 p-6 shadow-2xs flex flex-col md:flex-row items-start md:items-center justify-between gap-6">
      <div className="flex flex-col sm:flex-row items-start gap-4">
        {/* Avatar nhà xe */}
        <div className="w-14 h-14 rounded-2xl bg-[#00506a] text-white flex items-center justify-center font-bold text-xl shrink-0 shadow-xs">
          {operator.code}
        </div>

        <div className="space-y-2">
          <div className="flex flex-wrap items-center gap-2.5">
            <h1 className="text-2xl font-bold text-slate-900">
              {operator.name}
            </h1>
            {operator.isVerified && (
              <span className="inline-flex items-center gap-1 px-2.5 py-0.5 rounded-full text-xs font-semibold bg-emerald-50 text-emerald-700 border border-emerald-200">
                <CheckCircle2 className="w-3.5 h-3.5 text-emerald-600" />
                <span>Đối tác đã xác minh</span>
              </span>
            )}
          </div>

          <p className="text-xs text-slate-600 max-w-2xl leading-relaxed">
            {operator.description}
          </p>

          {/* Thông tin liên hệ */}
          <div className="flex flex-wrap items-center gap-4 text-xs text-slate-600 pt-1">
            {operator.hotline && <div className="flex items-center gap-1.5">
              <Phone className="w-3.5 h-3.5 text-slate-400" />
              <span>{operator.hotline}</span>
            </div>}
            {operator.email && <div className="flex items-center gap-1.5">
              <Mail className="w-3.5 h-3.5 text-slate-400" />
              <span>{operator.email}</span>
            </div>}
            {operator.headquarters && <div className="flex items-center gap-1.5">
              <MapPin className="w-3.5 h-3.5 text-slate-400" />
              <span>{operator.headquarters}</span>
            </div>}
          </div>
        </div>
      </div>

      {/* Nút tìm chuyến */}
      <Link
        href={`/trips?operatorId=${encodeURIComponent(operator.id)}`}
        className="w-full md:w-auto px-5 py-2.5 rounded-xl bg-[#00506a] hover:bg-[#00476b] text-white font-bold text-sm shadow-xs transition-colors text-center shrink-0 cursor-pointer"
      >
        Tìm chuyến của nhà xe
      </Link>
    </div>
  );
}
