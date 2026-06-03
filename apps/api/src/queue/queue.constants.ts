export const BULL_BOARD_PATH = "/admin/queues";

export const QUEUE_NAMES = {
  foundation: "foundation"
} as const;

export type QueueName = (typeof QUEUE_NAMES)[keyof typeof QUEUE_NAMES];

export const FOUNDATION_JOB_NAMES = {
  smoke: "foundation.smoke"
} as const;

export type FoundationJobName = (typeof FOUNDATION_JOB_NAMES)[keyof typeof FOUNDATION_JOB_NAMES];

export type FoundationSmokeJobData = {
  requestedAt: string;
  source: "test" | "manual";
};

export type FoundationJobData = FoundationSmokeJobData;

export type FoundationJobResult = {
  jobName: FoundationJobName;
  processedAt: string;
};

