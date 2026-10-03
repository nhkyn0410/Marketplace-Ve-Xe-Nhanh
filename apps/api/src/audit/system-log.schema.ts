import { Schema, type HydratedDocument } from "mongoose";
import { applyAppendOnlyGuard } from "./append-only.schema";

export const SYSTEM_LOG_MODEL = "SystemLog";
export const SYSTEM_LOG_COLLECTION = "system_log";

export type SystemLogLevel = "debug" | "info" | "warn" | "error" | "fatal";

export type SystemLog = {
  schemaVersion: number;
  level: SystemLogLevel;
  source: string;
  event: string;
  message: string;
  context?: Record<string, unknown>;
  requestId?: string;
  traceId?: string;
  createdAt: Date;
};

export type SystemLogDocument = HydratedDocument<SystemLog>;

export const SystemLogSchema = new Schema<SystemLog>(
  {
    schemaVersion: { type: Number, required: true, default: 1, immutable: true },
    level: {
      type: String,
      required: true,
      enum: ["debug", "info", "warn", "error", "fatal"],
      immutable: true
    },
    source: { type: String, required: true, trim: true, immutable: true },
    event: { type: String, required: true, trim: true, immutable: true },
    message: { type: String, required: true, trim: true, immutable: true },
    context: { type: Schema.Types.Mixed, immutable: true },
    requestId: { type: String, trim: true, immutable: true },
    traceId: { type: String, trim: true, immutable: true },
    createdAt: { type: Date, required: true, default: Date.now, immutable: true }
  },
  {
    collection: SYSTEM_LOG_COLLECTION,
    strict: "throw",
    versionKey: false,
    timeseries: { timeField: "createdAt", granularity: "seconds" }
  }
);

SystemLogSchema.index({ source: 1, createdAt: -1 });
SystemLogSchema.index({ level: 1, createdAt: -1 });
applyAppendOnlyGuard(SystemLogSchema);
