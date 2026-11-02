import { createHash, createHmac } from "node:crypto";
import { Logger } from "@nestjs/common";
import type { AppConfig } from "../config/env.config";

export const TICKET_QR = Symbol("TICKET_QR");

/** Khóa cố định CHỈ cho dev / test khi chưa đặt `TICKET_QR_SECRET` (env bắt buộc ở production). */
const DEV_SECRET = createHash("sha256").update("vexenhanh-dev-ticket-qr").digest();

/**
 * QR vé (TASK-BTP-004, BR-29, LLD §6.4 bước 2): token = HMAC-SHA256(khóa server, "ticket-qr:v1:{ticketId}") dạng
 * base64url — không đoán được, không chứa dữ liệu vé; soát vé xác thực server-side bằng hash. DB chỉ lưu SHA-256 của
 * token; khi khách mở vé thì tính lại token để hiển thị (không cần lưu nguyên văn).
 */
export class TicketQrSigner {
  constructor(private readonly secret: Buffer) {}

  token(ticketId: string): string {
    return createHmac("sha256", this.secret).update(`ticket-qr:v1:${ticketId}`).digest("base64url");
  }

  static hash(token: string): string {
    return createHash("sha256").update(token).digest("hex");
  }
}

export function createTicketQrSigner(config: AppConfig): TicketQrSigner {
  if (config.TICKET_QR_SECRET) {
    return new TicketQrSigner(Buffer.from(config.TICKET_QR_SECRET, "base64"));
  }
  new Logger("TicketQr").warn("TICKET_QR_SECRET chưa set — dùng khóa QR cố định chỉ cho dev / test.");
  return new TicketQrSigner(DEV_SECRET);
}
