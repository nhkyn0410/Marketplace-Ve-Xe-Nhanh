import type { Request, Response } from "express";
import { describe, expect, it, vi } from "vitest";
import { createBullBoardAccessGuard } from "./bull-board-access";

describe("createBullBoardAccessGuard", () => {
  it("allows local development when no token is configured", () => {
    const next = vi.fn();
    const { response, status } = createResponse();

    createBullBoardAccessGuard({ NODE_ENV: "development" })(createRequest({}), response, next);

    expect(next).toHaveBeenCalledTimes(1);
    expect(status).not.toHaveBeenCalled();
  });

  it("fails closed in production when no token is configured", () => {
    const next = vi.fn();
    const { json, response, status } = createResponse();

    createBullBoardAccessGuard({ NODE_ENV: "production" })(createRequest({}), response, next);

    expect(next).not.toHaveBeenCalled();
    expect(status).toHaveBeenCalledWith(503);
    expect(json).toHaveBeenCalledWith(
      expect.objectContaining({
        title: "Bull Board is not configured",
        code: "SERVICE_UNAVAILABLE",
        instance: "/admin/queues"
      })
    );
  });

  it("accepts the configured bearer token", () => {
    const next = vi.fn();
    const { response, status } = createResponse();

    createBullBoardAccessGuard({
      BULL_BOARD_TOKEN: "secret",
      NODE_ENV: "production"
    })(createRequest({ authorization: "Bearer secret" }), response, next);

    expect(next).toHaveBeenCalledTimes(1);
    expect(status).not.toHaveBeenCalled();
  });

  it("rejects an invalid token", () => {
    const next = vi.fn();
    const { response, setHeader, status } = createResponse();

    createBullBoardAccessGuard({
      BULL_BOARD_TOKEN: "secret",
      NODE_ENV: "production"
    })(createRequest({ authorization: "Bearer wrong" }), response, next);

    expect(next).not.toHaveBeenCalled();
    expect(setHeader).toHaveBeenCalledWith("WWW-Authenticate", "Bearer");
    expect(setHeader).toHaveBeenCalledWith("Content-Type", "application/problem+json");
    expect(status).toHaveBeenCalledWith(401);
  });
});

function createRequest(headers: Record<string, string | undefined>): Request {
  return {
    header: (name: string) => headers[name.toLowerCase()],
    originalUrl: "/admin/queues",
    url: "/admin/queues"
  } as unknown as Request;
}

function createResponse(): {
  json: ReturnType<typeof vi.fn>;
  response: Response;
  setHeader: ReturnType<typeof vi.fn>;
  status: ReturnType<typeof vi.fn>;
} {
  const response = {
    json: vi.fn().mockReturnThis(),
    setHeader: vi.fn().mockReturnThis(),
    status: vi.fn().mockReturnThis()
  } as unknown as Response;

  return {
    json: response.json as ReturnType<typeof vi.fn>,
    response,
    setHeader: response.setHeader as ReturnType<typeof vi.fn>,
    status: response.status as ReturnType<typeof vi.fn>
  };
}
