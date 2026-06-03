import "reflect-metadata";
import { NestFactory } from "@nestjs/core";
import { AppModule } from "./app.module";
import { createBullBoardAccessGuard } from "./queue/bull-board-access";
import { BullBoardService } from "./queue/bull-board.service";
import { BULL_BOARD_PATH } from "./queue/queue.constants";

async function bootstrap(): Promise<void> {
  const app = await NestFactory.create(AppModule);
  const bullBoard = app.get(BullBoardService);

  app.use(BULL_BOARD_PATH, createBullBoardAccessGuard(), bullBoard.getRouter());
  app.setGlobalPrefix("v1");

  const port = process.env.PORT ? Number(process.env.PORT) : 3000;
  await app.listen(port);
}

void bootstrap();
