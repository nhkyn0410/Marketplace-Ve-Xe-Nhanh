export type ApiClientConfig = {
  baseUrl: string;
};

export type { components, operations, paths, webhooks } from "./generated/schema";

export function createApiClientConfig(config: ApiClientConfig): ApiClientConfig {
  return config;
}
