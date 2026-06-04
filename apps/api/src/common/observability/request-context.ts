import { AsyncLocalStorage } from "node:async_hooks";
import { randomUUID } from "node:crypto";
import type { NextFunction, Request, RequestHandler, Response } from "express";

export const REQUEST_ID_HEADER = "x-request-id";

type RequestContext = {
  requestId: string;
};

const requestContext = new AsyncLocalStorage<RequestContext>();
const SAFE_REQUEST_ID = /^[A-Za-z0-9._:-]{8,128}$/;

export function createRequestContextMiddleware(): RequestHandler {
  return (request: Request, response: Response, next: NextFunction): void => {
    const requestId = resolveRequestId(request.header(REQUEST_ID_HEADER));

    response.setHeader(REQUEST_ID_HEADER, requestId);
    requestContext.run({ requestId }, next);
  };
}

export function getRequestId(): string | undefined {
  return requestContext.getStore()?.requestId;
}

export function resolveRequestId(candidate: unknown): string {
  const value = Array.isArray(candidate) ? candidate[0] : candidate;

  if (typeof value === "string") {
    const normalized = value.trim();

    if (SAFE_REQUEST_ID.test(normalized)) {
      return normalized;
    }
  }

  return randomUUID();
}
