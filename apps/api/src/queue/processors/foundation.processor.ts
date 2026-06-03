import { Processor, WorkerHost } from "@nestjs/bullmq";
import type { Job } from "bullmq";
import {
  FOUNDATION_JOB_NAMES,
  QUEUE_NAMES,
  type FoundationJobData,
  type FoundationJobName,
  type FoundationJobResult
} from "../queue.constants";

@Processor(QUEUE_NAMES.foundation, {
  concurrency: 1
})
export class FoundationQueueProcessor extends WorkerHost {
  async process(
    job: Job<FoundationJobData, FoundationJobResult, FoundationJobName>
  ): Promise<FoundationJobResult> {
    if (job.name !== FOUNDATION_JOB_NAMES.smoke) {
      throw new Error(`Unsupported foundation queue job: ${job.name}`);
    }

    return {
      jobName: FOUNDATION_JOB_NAMES.smoke,
      processedAt: new Date().toISOString()
    };
  }
}

