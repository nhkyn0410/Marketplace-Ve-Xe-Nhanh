import { CheckoutContactInfo, CheckoutPassengerItem } from "../../lib/data/types";

/**
 * Thuộc tính của component tóm tắt thông tin đơn hàng.
 */
export interface PaymentOrderSummaryCardProps {
  readonly bookingId: string;
  readonly contactInfo: CheckoutContactInfo;
  readonly passengers: readonly CheckoutPassengerItem[];
}

/**
 * Khối tóm tắt thông tin đơn hàng trong bước thanh toán theo Figma 1444:13055.
 */
export function PaymentOrderSummaryCard({
  bookingId,
  contactInfo,
  passengers
}: PaymentOrderSummaryCardProps) {
  void bookingId;

  return (
    <section className="rounded-2xl border border-vxn-border bg-white p-5 sm:p-6 shadow-2xs">
      <div className="flex items-center justify-between border-b border-vxn-border/50 pb-4">
        <h3 className="text-base font-bold text-vxn-ink sm:text-lg">
          Thông tin đơn
        </h3>
      </div>

      <div className="mt-4 space-y-3 text-xs sm:text-sm">
        <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-1 text-neutral-600">
          <span className="text-vxn-fg-4">Liên hệ</span>
          <span className="font-semibold text-vxn-ink">
            {contactInfo.fullName} • {contactInfo.phoneNumber}
          </span>
        </div>

        <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-1 text-neutral-600">
          <span className="text-vxn-fg-4">Email nhận vé</span>
          <span className="font-semibold text-vxn-ink">{contactInfo.email}</span>
        </div>

        {passengers.map((p) => (
          <div
            key={p.seatCode}
            className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-1 text-neutral-600"
          >
            <span className="text-vxn-fg-4">Chỗ {p.seatCode}</span>
            <span className="font-semibold text-vxn-ink">
              {p.fullName || `Hành khách chỗ ${p.seatCode}`}
            </span>
          </div>
        ))}
      </div>
    </section>
  );
}
