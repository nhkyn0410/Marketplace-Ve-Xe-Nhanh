import { Injectable, ServiceUnavailableException } from "@nestjs/common";
import { PrismaService } from "./prisma.service";

export type DatabaseHealthResponse = {
  status: "ok";
  service: "postgres";
  timestamp: string;
};

@Injectable()
export class DatabaseHealthService {
  constructor(private readonly prisma: PrismaService) {}

  async check(): Promise<DatabaseHealthResponse> {
    try {
      await this.prisma.$queryRaw`SELECT 1`;

      return {
        status: "ok",
        service: "postgres",
        timestamp: new Date().toISOString()
      };
    } catch (error) {
      throw new ServiceUnavailableException("PostgreSQL is unavailable.", {
        cause: error
      });
    }
  }
}
