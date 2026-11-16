import { renderToStaticMarkup } from "react-dom/server";
import { describe, expect, it, vi } from "vitest";

import type { TicketPassengerDetail } from "../../lib/data/types";
import { ticketDetailFixture } from "../../lib/preview/fixtures/tickets";
import { BoardingPassCard } from "./boarding-pass-card";

vi.mock("next/image", () => ({ default: (props: { alt: string }) => <span data-qr={props.alt} /> }));

const render = (status: TicketPassengerDetail["status"]) =>
  renderToStaticMarkup(
    <BoardingPassCard
      trip={ticketDetailFixture.trip}
      tickets={[{ ...ticketDetailFixture.tickets[0]!, status }]}
      activeTicketIndex={0}
      bookingCode={ticketDetailFixture.bookingCode}
      onSelectTicket={() => undefined}
    />
  );

describe("thẻ vé lên xe (SCR-PSG-25)", () => {
  it("chỉ nhắc 'Lên xe quét mã' với vé còn hiệu lực", () => {
    expect(render("valid")).toContain("Lên xe quét mã");
    for (const status of ["used", "checked_in", "no_show", "cancelled"] as const) {
      expect(render(status)).not.toContain("Lên xe quét mã");
    }
  });

  it("vé đã hủy không hiện mã QR", () => {
    expect(render("cancelled")).toContain("mã QR không còn hiệu lực");
  });
});
