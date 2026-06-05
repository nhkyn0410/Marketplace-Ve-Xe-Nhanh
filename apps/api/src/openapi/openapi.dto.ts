import { createZodDto } from "nestjs-zod";
import {
  HealthResponseSchema,
  MongoHealthResponseSchema,
  PostgresHealthResponseSchema,
  ProblemDetailsSchema,
  QueueHealthResponseSchema,
  RedisHealthResponseSchema
} from "@vexenhanh/types";

export class HealthResponseDto extends createZodDto(HealthResponseSchema) {}

export class PostgresHealthResponseDto extends createZodDto(PostgresHealthResponseSchema) {}

export class MongoHealthResponseDto extends createZodDto(MongoHealthResponseSchema) {}

export class RedisHealthResponseDto extends createZodDto(RedisHealthResponseSchema) {}

export class QueueHealthResponseDto extends createZodDto(QueueHealthResponseSchema) {}

export class ProblemDetailsDto extends createZodDto(ProblemDetailsSchema) {}
