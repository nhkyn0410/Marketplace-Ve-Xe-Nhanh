import type { NextFunction, Request, RequestHandler, Response } from "express";

type Env = Record<string, string | undefined>;

type ProblemResponse = {
  type: string;
  title: string;
  status: number;
  detail: string;
};

export function createBullBoardAccessGuard(env: Env = process.env): RequestHandler {
  return (request: Request, response: Response, next: NextFunction): void => {
    const configuredToken = env.BULL_BOARD_TOKEN?.trim();

    if (!configuredToken && env.NODE_ENV !== "production") {
      next();
      return;
    }

    if (!configuredToken) {
      sendProblem(response, {
        type: "about:blank",
        title: "Bull Board is not configured",
        status: 503,
        detail: "BULL_BOARD_TOKEN must be configured before Bull Board is available."
      });
      return;
    }

    if (getPresentedToken(request) === configuredToken) {
      next();
      return;
    }

    response.setHeader("WWW-Authenticate", "Bearer");
    sendProblem(response, {
      type: "about:blank",
      title: "Unauthorized",
      status: 401,
      detail: "A valid Bull Board bearer token is required."
    });
  };
}

function getPresentedToken(request: Request): string | undefined {
  const authorization = request.header("authorization");

  if (authorization?.startsWith("Bearer ")) {
    return authorization.slice("Bearer ".length).trim();
  }

  return request.header("x-bull-board-token")?.trim();
}

function sendProblem(response: Response, problem: ProblemResponse): void {
  response.status(problem.status).json(problem);
}

