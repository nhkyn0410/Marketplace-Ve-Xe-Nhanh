import { Injectable, ServiceUnavailableException } from "@nestjs/common";
import { InjectConnection } from "@nestjs/mongoose";
import type { Connection } from "mongoose";

export type MongoHealthResponse = {
  status: "ok";
  service: "mongo";
  timestamp: string;
};

@Injectable()
export class MongoHealthService {
  constructor(@InjectConnection() private readonly connection: Connection) {}

  async check(): Promise<MongoHealthResponse> {
    try {
      if (this.connection.readyState !== 1 || !this.connection.db) {
        throw new Error("Mongo audit connection is not ready.");
      }

      await this.connection.db.admin().ping();

      return {
        status: "ok",
        service: "mongo",
        timestamp: new Date().toISOString()
      };
    } catch (error) {
      throw new ServiceUnavailableException("MongoDB audit cluster is unavailable.", {
        cause: error
      });
    }
  }
}
