import { BullMQAdapter } from "@bull-board/api/bullMQAdapter";
import { createBullBoard } from "@bull-board/api";
import { ExpressAdapter } from "@bull-board/express";
import { InjectQueue } from "@nestjs/bullmq";
import { Injectable } from "@nestjs/common";
import type { Queue } from "bullmq";
import type { RequestHandler } from "express";
import { BULL_BOARD_PATH, QUEUE_NAMES } from "./queue.constants";

@Injectable()
export class BullBoardService {
  private router?: RequestHandler;

  constructor(@InjectQueue(QUEUE_NAMES.foundation) private readonly foundationQueue: Queue) {}

  getRouter(): RequestHandler {
    if (this.router) {
      return this.router;
    }

    const serverAdapter = new ExpressAdapter();
    serverAdapter.setBasePath(BULL_BOARD_PATH);

    createBullBoard({
      queues: [
        new BullMQAdapter(this.foundationQueue, {
          description: "Foundation queue smoke checks and future infrastructure jobs.",
          readOnlyMode: true
        })
      ],
      serverAdapter
    });

    this.router = serverAdapter.getRouter() as RequestHandler;
    return this.router;
  }
}

