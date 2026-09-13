import type { Logger } from "pino";
import { describe, expect, it, vi } from "vitest";
import { createNestLogger } from "./logger";

describe("auth monitoring log shape", () => {
  it("puts Nest auth event fields under data for Render log queries", () => {
    const warn = vi.fn();
    const logger = createNestLogger({ warn } as unknown as Logger);

    logger.warn({
      event: "auth.proxy_ip_untrusted",
      cfRay: "test-ray-SIN"
    });

    expect(warn).toHaveBeenCalledWith(
      expect.objectContaining({
        data: { event: "auth.proxy_ip_untrusted", cfRay: "test-ray-SIN" }
      }),
      "Nest application log"
    );
  });
});
