import "reflect-metadata";
import { NestFactory } from "@nestjs/core";
import { AppModule } from "./app.module";
import { loadAppConfig } from "./config/env.config";
import { createBullBoardAccessGuard } from "./queue/bull-board-access";
import { BullBoardService } from "./queue/bull-board.service";
import { BULL_BOARD_PATH } from "./queue/queue.constants";

async function bootstrap(): Promise<void> {
  const config = loadAppConfig(); // nạp .env + validate (fail-fast) trước khi bootstrap
  const app = await NestFactory.create(AppModule);
  const bullBoard = app.get(BullBoardService);

  app.use(BULL_BOARD_PATH, createBullBoardAccessGuard(), bullBoard.getRouter());
  app.setGlobalPrefix("v1");

  await app.listen(config.PORT);
}

void bootstrap();
