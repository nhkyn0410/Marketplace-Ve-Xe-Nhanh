import { initSentry } from "./common/observability/sentry";
import { loadAppConfig } from "./config/env.config";

initSentry(loadAppConfig(), "worker");
