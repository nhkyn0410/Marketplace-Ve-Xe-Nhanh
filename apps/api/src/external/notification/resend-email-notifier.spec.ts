import { Logger } from "@nestjs/common";
import { afterEach, describe, expect, it, vi } from "vitest";
import { ResendEmailNotifier } from "./resend-email-notifier";

describe("ResendEmailNotifier temporary password", () => {
  afterEach(() => vi.unstubAllGlobals());

  it("sends the secret only in the provider body and never logs it", async () => {
    const fetchMock = vi.fn().mockResolvedValue({ ok: true, status: 200 });
    vi.stubGlobal("fetch", fetchMock);
    const error = vi.spyOn(Logger.prototype, "error").mockImplementation(() => undefined);
    const secret = "A<&secret'\"";

    try {
      await new ResendEmailNotifier("api-key", "noreply@example.com").sendTemporaryPassword({
        email: "employee@example.com",
        temporaryPassword: secret,
        loginIdentifier: "operator/user<1>",
        expiresAt: new Date("2026-09-23T00:00:00.000Z"),
      });

      const body = JSON.parse(fetchMock.mock.calls[0][1].body as string) as { html: string };
      expect(body.html).toContain("A&lt;&amp;secret&#39;&quot;");
      expect(body.html).not.toContain(secret);
      expect(JSON.stringify(error.mock.calls)).not.toContain(secret);
    } finally {
      error.mockRestore();
    }
  });

  it("masks the email and omits the secret when Resend rejects", async () => {
    vi.stubGlobal("fetch", vi.fn().mockResolvedValue({ ok: false, status: 503 }));
    const error = vi.spyOn(Logger.prototype, "error").mockImplementation(() => undefined);
    const secret = "do-not-log-this";

    try {
      await expect(
        new ResendEmailNotifier("api-key", "noreply@example.com").sendTemporaryPassword({
          email: "employee@example.com",
          temporaryPassword: secret,
          loginIdentifier: "operator/user",
          expiresAt: new Date("2026-09-23T00:00:00.000Z"),
        }),
      ).rejects.toThrow(/503/);
      const logged = JSON.stringify(error.mock.calls);
      expect(logged).toContain("e***@example.com");
      expect(logged).not.toContain("employee@example.com");
      expect(logged).not.toContain(secret);
    } finally {
      error.mockRestore();
    }
  });
});


describe("ResendEmailNotifier operator application decision (NTF-15)", () => {
  afterEach(() => vi.unstubAllGlobals());

  it("needs-info: escapes the Admin's reason and carries the new link; rejected: reason only, no link", async () => {
    const fetchMock = vi.fn().mockResolvedValue({ ok: true, status: 200 });
    vi.stubGlobal("fetch", fetchMock);
    const notifier = new ResendEmailNotifier("api-key", "noreply@example.com");
    const base = { email: "lienhe@example.com", applicationCode: "OA-2026-043152", operatorName: "Sao <Việt>" };

    await notifier.sendOperatorApplicationDecision({
      ...base,
      decision: "NEEDS_INFO",
      reason: "Bổ sung <b>giấy phép</b>",
      link: "https://operator.example/register/application#token=abc",
      expiresAt: new Date("2026-10-18T00:00:00.000Z"),
    });
    await notifier.sendOperatorApplicationDecision({ ...base, decision: "REJECTED", reason: "Giấy tờ giả" });

    const [needsInfo, rejected] = fetchMock.mock.calls.map(
      (call) => JSON.parse(call[1].body as string) as { subject: string; html: string },
    );
    expect(needsInfo!.subject).toContain("cần bổ sung");
    expect(needsInfo!.html).toContain("Bổ sung &lt;b&gt;giấy phép&lt;/b&gt;");
    expect(needsInfo!.html).toContain("Sao &lt;Việt&gt;");
    expect(needsInfo!.html).toContain('href="https://operator.example/register/application#token=abc"');
    expect(rejected!.subject).toContain("không được duyệt");
    expect(rejected!.html).toContain("Giấy tờ giả");
    expect(rejected!.html).not.toContain("href=");
  });
});

describe("ResendEmailNotifier stop point decision (TASK-ADM-004)", () => {
  afterEach(() => vi.unstubAllGlobals());

  it("bốn quyết định có tiêu đề riêng; lý do / tên điểm do người dùng nhập được escape", async () => {
    const fetchMock = vi.fn().mockResolvedValue({ ok: true, status: 200 });
    vi.stubGlobal("fetch", fetchMock);
    const notifier = new ResendEmailNotifier("api-key", "noreply@example.com");
    const base = { email: "owner@example.com", operatorName: "Sao <Việt>", stopPointName: "Điểm <A>" };

    await notifier.sendStopPointDecision({ ...base, decision: "PROPOSAL_APPROVED", sharedName: "Điểm đón <B>" });
    await notifier.sendStopPointDecision({ ...base, decision: "PROPOSAL_REJECTED", reason: "Thiếu <QĐ>" });
    await notifier.sendStopPointDecision({ ...base, decision: "SUSPENDED", reason: "Sai tọa độ" });
    await notifier.sendStopPointDecision({ ...base, decision: "UNSUSPENDED" });

    const [approved, rejected, suspended, unsuspended] = fetchMock.mock.calls.map(
      (call) => JSON.parse(call[1].body as string) as { subject: string; html: string },
    );
    expect(approved!.subject).toContain("đã được duyệt");
    expect(approved!.html).toContain("Điểm đón &lt;B&gt;");
    expect(rejected!.subject).toContain("chưa được duyệt");
    expect(rejected!.html).toContain("Thiếu &lt;QĐ&gt;");
    expect(suspended!.subject).toContain("bị khóa");
    expect(suspended!.html).toContain("Sai tọa độ");
    expect(unsuspended!.subject).toContain("mở khóa");
    // Tiêu đề là chữ thường (không phải HTML) nên giữ nguyên; phần HTML phải escape.
    for (const body of [approved, rejected, suspended, unsuspended]) {
      expect(body!.html).toContain("Điểm &lt;A&gt;");
      expect(body!.html).not.toContain("<A>");
    }
  });
});
