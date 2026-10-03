import { InjectQueue } from "@nestjs/bullmq";
import { Injectable, ServiceUnavailableException } from "@nestjs/common";
import type { QueueHealthResponse as SharedQueueHealthResponse } from "@vexenhanh/types";
import type { Queue } from "bullmq";
import {
  FOUNDATION_JOB_NAMES,
  QUEUE_NAMES,
  type FoundationJobData,
  type FoundationJobName,
  type FoundationJobResult
} from "./queue.constants";

export type QueueHealthResponse = SharedQueueHealthResponse;

@Injectable()
export class QueueHealthService {
  constructor(
    @InjectQueue(QUEUE_NAMES.foundation)
    private readonly foundationQueue: Queue<FoundationJobData, FoundationJobResult, FoundationJobName>
  ) {}

  async check(): Promise<QueueHealthResponse> {
    try {
      const counts = await this.foundationQueue.getJobCounts(
        "waiting",
        "active",
        "completed",
        "failed",
        "delayed",
        "paused"
      );

      return {
        status: "ok",
        queues: [
          {
            name: QUEUE_NAMES.foundation,
            counts
          }
        ],
        timestamp: new Date().toISOString()
      };
    } catch (error) {
      throw new ServiceUnavailableException("BullMQ queues are unavailable.", {
        cause: error
      });
    }
  }

  async enqueueFoundationSmoke(source: "test" | "manual" = "test"): Promise<string | undefined> {
    const job = await this.foundationQueue.add(FOUNDATION_JOB_NAMES.smoke, {
      requestedAt: new Date().toISOString(),
      source
    });

    return job.id;
  }
}

