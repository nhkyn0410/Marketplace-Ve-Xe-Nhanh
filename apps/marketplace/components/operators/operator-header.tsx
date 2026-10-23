"use client";

import Link from "next/link";
import { ChevronRight, Phone, Mail, MapPin, CheckCircle2 } from "lucide-react";
import { OperatorProfileData } from "../../lib/data/types";

interface OperatorHeaderProps {
  readonly operator: OperatorProfileData;
}

/**
 * Khối Header thông tin nhà xe (SCR-PSG-17).
 */
export function OperatorHeader({ operator }: OperatorHeaderProps) {
  return (
    <div className="space-y-4">
      {/* Breadcrumb và hotline hỗ trợ */}
      <div className="flex flex-wrap items-center justify-between gap-2 text-xs text-neutral-500">
        <nav aria-label="Breadcrumb" className="flex items-center space-x-1.5 flex-wrap">
          <Link href="/" className="hover:text-neutral-900 transition-colors">
            Trang chủ
          </Link>
          <ChevronRight className="w-3.5 h-3.5 text-neutral-400" />
          <span className="text-neutral-500">Nhà xe</span>
          <ChevronRight className="w-3.5 h-3.5 text-neutral-400" />
          <span className="text-neutral-900 font-medium">{operator.name}</span>
        </nav>

        <div className="flex items-center gap-4">
          <div className="flex items-center gap-1.5 text-xs text-neutral-600 bg-neutral-100 px-2.5 py-1 rounded-full border border-neutral-200">
            <Link href="/support" className="hover:underline">Trung tâm hỗ trợ</Link>
          </div>
          <div className="flex items-center gap-1 text-xs text-neutral-700 bg-neutral-100 px-2 py-1 rounded border border-neutral-200">
            <span>VI 🇻🇳</span>
          </div>
        </div>
      </div>

      {/* Card thông tin nhà xe */}
      <div className="bg-white rounded-2xl border border-neutral-200 p-6 shadow-xs flex flex-col md:flex-row items-start md:items-center justify-between gap-6">
        <div className="flex flex-col sm:flex-row items-start gap-4">
          {/* Avatar nhà xe */}
          <div className="w-16 h-16 rounded-2xl bg-[#00506a] text-white flex items-center justify-center font-bold text-xl shrink-0 shadow-xs">
            {operator.code}
          </div>

          <div className="space-y-2">
            <div className="flex flex-wrap items-center gap-2.5">
              <h1 className="text-2xl font-bold text-neutral-900">
                {operator.name}
              </h1>
              {operator.isVerified && (
                <span className="inline-flex items-center gap-1 px-2.5 py-0.5 rounded-full text-xs font-semibold bg-emerald-50 text-emerald-700 border border-emerald-200">
                  <CheckCircle2 className="w-3.5 h-3.5 text-emerald-600" />
                  <span>Đối tác đã xác minh</span>
                </span>
              )}
            </div>

            <p className="text-xs text-neutral-600 max-w-2xl leading-relaxed">
              {operator.description}
            </p>

            {/* Thông tin liên hệ */}
            <div className="flex flex-wrap items-center gap-4 text-xs text-neutral-600 pt-1">
              {operator.hotline && <div className="flex items-center gap-1.5">
                <Phone className="w-3.5 h-3.5 text-neutral-400" />
                <span>{operator.hotline}</span>
              </div>}
              {operator.email && <div className="flex items-center gap-1.5">
                <Mail className="w-3.5 h-3.5 text-neutral-400" />
                <span>{operator.email}</span>
              </div>}
              {operator.headquarters && <div className="flex items-center gap-1.5">
                <MapPin className="w-3.5 h-3.5 text-neutral-400" />
                <span>{operator.headquarters}</span>
              </div>}
            </div>
          </div>
        </div>

        {/* Nút tìm chuyến */}
        <Link
          href={`/trips?operatorId=${encodeURIComponent(operator.id)}`}
          className="w-full md:w-auto px-5 py-3 rounded-xl bg-[#00506a] hover:bg-[#003d52] active:bg-[#002e3e] text-white font-bold text-sm shadow-xs transition-colors text-center shrink-0"
        >
          Tìm chuyến của nhà xe
        </Link>
      </div>
    </div>
  );
}
