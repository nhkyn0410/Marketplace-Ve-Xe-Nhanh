import "./instrument-api";
import "reflect-metadata";
import { NestFactory } from "@nestjs/core";
import { ProblemDetailsExceptionFilter } from "./common/errors/problem-details.filter";
import { createHttpLoggerMiddleware, createAppLogger, createNestLogger } from "./common/observability/logger";
import { createRequestContextMiddleware } from "./common/observability/request-context";
import { AppModule } from "./app.module";
import { loadAppConfig } from "./config/env.config";
import { createBullBoardAccessGuard } from "./queue/bull-board-access";
import { BullBoardService } from "./queue/bull-board.service";
import { BULL_BOARD_PATH } from "./queue/queue.constants";

async function bootstrap(): Promise<void> {
  const config = loadAppConfig(); // nạp .env + validate (fail-fast) trước khi bootstrap
  const logger = createAppLogger(config, "api");
  const app = await NestFactory.create(AppModule, { logger: createNestLogger(logger) });
  const bullBoard = app.get(BullBoardService);

  app.use(createRequestContextMiddleware());
  app.use(createHttpLoggerMiddleware(logger));
  app.useGlobalFilters(new ProblemDetailsExceptionFilter());
  app.use(BULL_BOARD_PATH, createBullBoardAccessGuard(), bullBoard.getRouter());
  app.setGlobalPrefix("v1");

  await app.listen(config.PORT);
}

void bootstrap();
