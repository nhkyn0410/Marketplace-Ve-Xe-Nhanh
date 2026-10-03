import type { Request, Response } from "express";
import { describe, expect, it, vi } from "vitest";
import {
  createRequestContextMiddleware,
  getRequestId,
  REQUEST_ID_HEADER,
  resolveRequestId
} from "./request-context";

describe("request context", () => {
  it("keeps a safe caller-provided request id", () => {
    expect(resolveRequestId("req-12345678")).toBe("req-12345678");
  });

  it("generates a request id when the caller value is unsafe", () => {
    const requestId = resolveRequestId("bad id with spaces");

    expect(requestId).toMatch(
      /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/
    );
  });

  it("stores request id for the rest of the middleware chain", () => {
    const next = vi.fn(() => {
      expect(getRequestId()).toBe("req-abcdef12");
    });
    const response = { setHeader: vi.fn() } as unknown as Response;
    const request = {
      header: (name: string) => (name === REQUEST_ID_HEADER ? "req-abcdef12" : undefined)
    } as unknown as Request;

    createRequestContextMiddleware()(request, response, next);

    expect(response.setHeader).toHaveBeenCalledWith(REQUEST_ID_HEADER, "req-abcdef12");
    expect(next).toHaveBeenCalledTimes(1);
  });
});
