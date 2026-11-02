"use client";

/**
 * Thuộc tính của component ghi chú cho nhà xe.
 */
export interface OperatorNoteBoxProps {
  readonly note?: string;
  readonly onChange?: (note: string) => void;
}

/**
 * Khối ghi chú cho nhà xe theo Figma 1444:12531.
 */
export function OperatorNoteBox({ note = "", onChange }: OperatorNoteBoxProps) {
  return (
    <section className="rounded-2xl border border-vxn-border bg-white p-5 sm:p-6 shadow-2xs">
      <h3 className="text-base font-bold text-vxn-ink sm:text-lg">
        Ghi chú cho nhà xe (không bắt buộc)
      </h3>

      <div className="mt-4">
        <textarea
          rows={3}
          maxLength={300}
          value={note}
          onChange={(e) => onChange?.(e.target.value)}
          placeholder="Ví dụ: có trẻ nhỏ đi cùng, cần hỗ trợ hành lý..."
          className="w-full resize-none rounded-xl border border-neutral-300 bg-white p-3.5 text-xs sm:text-sm text-vxn-ink shadow-2xs focus:border-vxn-teal-700 focus:outline-hidden"
        />
        <div className="mt-1.5 text-right text-[11px] text-neutral-400">
          Tối đa 300 ký tự
        </div>
      </div>
    </section>
  );
}
