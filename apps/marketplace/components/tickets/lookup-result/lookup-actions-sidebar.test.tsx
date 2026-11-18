import { renderToStaticMarkup } from "react-dom/server";
import { describe, expect, it } from "vitest";

import { ticketLookupResultFixture } from "../../../lib/preview/fixtures/tickets";
import { LookupActionsSidebar } from "./lookup-actions-sidebar";

const render = (props: Partial<React.ComponentProps<typeof LookupActionsSidebar>> = {}) =>
  renderToStaticMarkup(<LookupActionsSidebar bookingCode="VXN123456" payment={ticketLookupResultFixture.payment} {...props} />);

describe("cột thao tác ở kết quả tra cứu vé (SCR-PSG-29)", () => {
  it("đơn có mã giảm hiện dòng Ưu đãi; đơn không giảm thì không hiện", () => {
    const discounted = render({ payment: { ...ticketLookupResultFixture.payment, ticketPriceTotalVnd: "290000", discountVnd: "43500", paidTotalVnd: "246500" } });
    expect(discounted).toContain("Ưu đãi");
    expect(discounted).toContain("-43.500");
    expect(render()).not.toContain("Ưu đãi");
  });

  it("email đã có tài khoản thì mời đăng nhập, chưa có thì mời tạo tài khoản (UC-35 A1b)", () => {
    const withAccount = render({ hasAccount: true });
    expect(withAccount).toContain("Đăng nhập tài khoản Vé Xe Nhanh");
    expect(withAccount).not.toContain("Tạo tài khoản");
    expect(withAccount).not.toContain('href="/register"');

    const guest = render();
    expect(guest).toContain("Tạo tài khoản Vé Xe Nhanh");
    expect(guest).toContain('href="/register"');
  });
});
