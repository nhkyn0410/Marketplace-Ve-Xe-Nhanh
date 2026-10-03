import { Injectable } from "@nestjs/common";
import { InjectModel } from "@nestjs/mongoose";
import type { Model } from "mongoose";
import { getRequestId } from "../common/observability/request-context";
import { getCurrentTraceId } from "../common/observability/tracing";
import { AUDIT_EVENT_MODEL, type AuditEvent, type AuditEventDocument } from "./audit-event.schema";
import { SYSTEM_LOG_MODEL, type SystemLog, type SystemLogDocument } from "./system-log.schema";

export type AuditEventInput = Omit<AuditEvent, "schemaVersion" | "createdAt"> & {
  createdAt?: Date;
};

export type SystemLogInput = Omit<SystemLog, "schemaVersion" | "createdAt"> & {
  createdAt?: Date;
};

@Injectable()
export class AuditService {
  constructor(
    @InjectModel(AUDIT_EVENT_MODEL)
    private readonly auditEventModel: Model<AuditEventDocument>,
    @InjectModel(SYSTEM_LOG_MODEL)
    private readonly systemLogModel: Model<SystemLogDocument>
  ) {}

  async recordAuditEvent(input: AuditEventInput): Promise<void> {
    await this.auditEventModel.create({
      ...withCorrelation(input),
      schemaVersion: 1,
      createdAt: input.createdAt ?? new Date()
    });
  }

  async recordSystemLog(input: SystemLogInput): Promise<void> {
    await this.systemLogModel.create({
      ...withCorrelation(input),
      schemaVersion: 1,
      createdAt: input.createdAt ?? new Date()
    });
  }
}

function withCorrelation<T extends { requestId?: string; traceId?: string }>(input: T): T {
  return {
    ...input,
    requestId: input.requestId ?? getRequestId(),
    traceId: input.traceId ?? getCurrentTraceId()
  };
}
