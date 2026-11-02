import { CheckoutContactInfo } from "../../lib/data/types";

/**
 * Thuộc tính của component form thông tin liên hệ.
 */
export interface ContactInfoFormProps {
  readonly contactInfo: CheckoutContactInfo;
  readonly onChange?: (field: keyof CheckoutContactInfo, value: string) => void;
}

/**
 * Khối thông tin liên hệ người đặt theo Figma 1444:12531.
 */
export function ContactInfoForm({ contactInfo, onChange }: ContactInfoFormProps) {
  return (
    <section className="rounded-2xl border border-vxn-border bg-white p-5 sm:p-6 shadow-2xs">
      <div className="border-b border-vxn-border/50 pb-4">
        <h3 className="text-base font-bold text-vxn-ink sm:text-lg">
          Thông tin liên hệ
        </h3>
        <p className="mt-1 text-xs text-vxn-fg-4 leading-relaxed">
          Vé điện tử và thông báo về chuyến sẽ gửi tới email này.
        </p>
      </div>

      <div className="mt-5 grid grid-cols-1 gap-4 sm:grid-cols-3">
        {/* Họ và tên */}
        <div>
          <label className="block text-xs font-semibold text-vxn-ink">
            Họ và tên <span className="text-red-500">*</span>
          </label>
          <input
            type="text"
            required
            value={contactInfo.fullName}
            onChange={(e) => onChange?.("fullName", e.target.value)}
            placeholder="Nhập họ và tên"
            className="mt-1.5 w-full rounded-xl border border-neutral-300 bg-white px-3.5 py-2.5 text-xs sm:text-sm text-vxn-ink shadow-2xs focus:border-vxn-teal-700 focus:outline-hidden"
          />
        </div>

        {/* Số điện thoại */}
        <div>
          <label className="block text-xs font-semibold text-vxn-ink">
            Số điện thoại <span className="text-red-500">*</span>
          </label>
          <input
            type="tel"
            required
            value={contactInfo.phoneNumber}
            onChange={(e) => onChange?.("phoneNumber", e.target.value)}
            placeholder="09xx xxx xxx"
            className="mt-1.5 w-full rounded-xl border border-neutral-300 bg-white px-3.5 py-2.5 text-xs sm:text-sm text-vxn-ink shadow-2xs focus:border-vxn-teal-700 focus:outline-hidden"
          />
        </div>

        {/* Email */}
        <div>
          <label className="block text-xs font-semibold text-vxn-ink">
            Email <span className="text-red-500">*</span>
          </label>
          <input
            type="email"
            required
            value={contactInfo.email}
            onChange={(e) => onChange?.("email", e.target.value)}
            placeholder="ten@vidu.com"
            className="mt-1.5 w-full rounded-xl border border-neutral-300 bg-white px-3.5 py-2.5 text-xs sm:text-sm text-vxn-ink shadow-2xs focus:border-vxn-teal-700 focus:outline-hidden"
          />
        </div>
      </div>
    </section>
  );
}
