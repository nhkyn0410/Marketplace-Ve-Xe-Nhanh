export default function MarketplacePage() {
  return (
    <>
      <section className="bg-gradient-primary text-white">
        <div className="mx-auto max-w-8xl px-4 py-16 sm:px-6 lg:px-8 lg:py-24">
          <h1 className="max-w-2xl text-3xl leading-tight font-bold sm:text-5xl">Đặt vé xe khách trực tuyến</h1>
          <p className="mt-4 max-w-xl text-base text-white/85 sm:text-lg">
            Tìm chuyến, so sánh nhà xe, chọn ghế và nhận vé điện tử QR.
          </p>
        </div>
      </section>

      <section className="mx-auto max-w-8xl px-4 py-10 sm:px-6 lg:px-8">
        <div className="rounded-xl border border-dashed bg-card p-6 text-sm text-muted-foreground">
          Form tìm chuyến sẽ được dựng cùng tính năng tìm kiếm (TASK-TRN-004).
        </div>
      </section>
    </>
  );
}
