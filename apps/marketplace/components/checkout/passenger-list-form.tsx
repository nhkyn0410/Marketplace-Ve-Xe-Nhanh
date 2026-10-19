"use client";

import { ChevronDown } from "lucide-react";
import { formatVnd } from "../../lib/format";
import { CheckoutPassengerItem, SavedPassenger } from "../../lib/data/types";

/**
 * Thuộc tính của component danh sách hành khách.
 */
export interface PassengerListFormProps {
  readonly passengers: readonly CheckoutPassengerItem[];
  readonly savedPassengers: readonly SavedPassenger[];
  readonly currentSavedCount: number;
  readonly maxSavedCount: number;
  readonly onUpdatePassenger?: (
    index: number,
    field: keyof CheckoutPassengerItem,
    value: string | boolean
  ) => void;
  readonly onSelectSavedPassenger?: (index: number, saved: SavedPassenger) => void;
}

/**
 * Khối điền danh sách hành khách theo từng ghế theo Figma 1444:12531.
 */
export function PassengerListForm({
  passengers,
  savedPassengers,
  currentSavedCount,
  maxSavedCount,
  onUpdatePassenger,
  onSelectSavedPassenger
}: PassengerListFormProps) {
  return (
    <section className="rounded-2xl border border-vxn-border bg-white p-5 sm:p-6 shadow-2xs">
      <div className="border-b border-vxn-border/50 pb-4">
        <h3 className="text-base font-bold text-vxn-ink sm:text-lg">
          Hành khách ({passengers.length})
        </h3>
        <p className="mt-1 text-xs text-vxn-fg-4 leading-relaxed">
          Mỗi chỗ một hành khách. Họ tên cần khớp giấy tờ tùy thân khi lên xe.
        </p>
      </div>

      <div className="mt-5 space-y-4">
        {passengers.map((passenger, idx) => (
          <div
            key={passenger.seatCode}
            className="rounded-xl border border-vxn-border/80 bg-neutral-50/20 p-4 sm:p-5"
          >
            {/* Header thẻ hành khách */}
            <div className="flex flex-col gap-2.5 sm:flex-row sm:items-center sm:justify-between border-b border-vxn-border/40 pb-3">
              <div className="flex items-center gap-2.5">
                <span className="flex h-6 w-7 items-center justify-center rounded-md bg-vxn-teal-900 text-xs font-bold text-white">
                  {passenger.seatCode}
                </span>
                <div>
                  <h4 className="text-xs sm:text-sm font-bold text-vxn-ink">
                    Hành khách chỗ {passenger.seatCode}
                  </h4>
                  <p className="text-[11px] text-vxn-fg-4">
                    {passenger.seatTypeLabel} • {passenger.floorLabel} •{" "}
                    {formatVnd(passenger.priceVnd)}
                  </p>
                </div>
              </div>

              {/* Dropdown chọn hành khách đã lưu */}
              {savedPassengers.length > 0 && (
                <div className="relative">
                  <select
                    aria-label="Chọn từ hành khách đã lưu"
                    value={
                      savedPassengers.find((s) => s.fullName.includes(passenger.fullName))
                        ?.id ?? ""
                    }
                    onChange={(e) => {
                      const found = savedPassengers.find((s) => s.id === e.target.value);
                      if (found) {
                        onSelectSavedPassenger?.(idx, found);
                      }
                    }}
                    className="w-full sm:w-auto appearance-none rounded-xl border border-neutral-300 bg-white py-1.5 pl-3 pr-8 text-xs font-semibold text-vxn-fg-2 shadow-2xs focus:border-vxn-teal-700 focus:outline-hidden cursor-pointer"
                  >
                    <option value="">Chọn hành khách</option>
                    {savedPassengers.map((s) => (
                      <option key={s.id} value={s.id}>
                        {s.fullName}
                      </option>
                    ))}
                  </select>
                  <ChevronDown className="pointer-events-none absolute right-2.5 top-1/2 h-3.5 w-3.5 -translate-y-1/2 text-neutral-400" />
                </div>
              )}
            </div>

            {/* 3 ô nhập thông tin */}
            <div className="mt-4 grid grid-cols-1 gap-3.5 sm:grid-cols-3">
              <div>
                <label className="block text-[11px] font-semibold text-vxn-ink">
                  Họ và tên <span className="text-red-500">*</span>
                </label>
                <input
                  type="text"
                  required
                  value={passenger.fullName}
                  onChange={(e) =>
                    onUpdatePassenger?.(idx, "fullName", e.target.value)
                  }
                  placeholder="Nguyễn Văn A"
                  className="mt-1 w-full rounded-xl border border-neutral-300 bg-white px-3 py-2 text-xs sm:text-sm text-vxn-ink shadow-2xs focus:border-vxn-teal-700 focus:outline-hidden"
                />
              </div>

              <div>
                <label className="block text-[11px] font-semibold text-vxn-ink">
                  Số điện thoại
                </label>
                <input
                  type="tel"
                  value={passenger.phoneNumber}
                  onChange={(e) =>
                    onUpdatePassenger?.(idx, "phoneNumber", e.target.value)
                  }
                  placeholder="09xx xxx xxx"
                  className="mt-1 w-full rounded-xl border border-neutral-300 bg-white px-3 py-2 text-xs sm:text-sm text-vxn-ink shadow-2xs focus:border-vxn-teal-700 focus:outline-hidden"
                />
              </div>

              <div>
                <label className="block text-[11px] font-semibold text-vxn-ink">
                  CCCD / hộ chiếu
                </label>
                <input
                  type="text"
                  value={passenger.idNumber}
                  onChange={(e) =>
                    onUpdatePassenger?.(idx, "idNumber", e.target.value)
                  }
                  placeholder="Nhập số giấy tờ"
                  className="mt-1 w-full rounded-xl border border-neutral-300 bg-white px-3 py-2 text-xs sm:text-sm text-vxn-ink shadow-2xs focus:border-vxn-teal-700 focus:outline-hidden"
                />
              </div>
            </div>

            {/* Checkbox lưu hành khách */}
            <div className="mt-3.5 flex items-center justify-between pt-2">
              <label className="flex items-center gap-2 cursor-pointer text-xs text-vxn-ink font-medium select-none">
                <input
                  type="checkbox"
                  checked={passenger.shouldSaveForLater}
                  onChange={(e) =>
                    onUpdatePassenger?.(idx, "shouldSaveForLater", e.target.checked)
                  }
                  className="h-4 w-4 rounded border-neutral-300 text-vxn-teal-800 focus:ring-vxn-teal-700 cursor-pointer"
                />
                <span>Lưu hành khách này cho lần đặt sau</span>
              </label>

              <span className="text-[11px] text-neutral-400">
                Đã lưu {currentSavedCount} / {maxSavedCount}
              </span>
            </div>
          </div>
        ))}
      </div>
    </section>
  );
}
