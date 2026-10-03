import { Global, Module } from "@nestjs/common";
import { APP_CONFIG, loadAppConfig } from "./env.config";

/** Module global cấp `APP_CONFIG` (env đã validate) cho dependency injection. */
@Global()
@Module({
  providers: [{ provide: APP_CONFIG, useFactory: loadAppConfig }],
  exports: [APP_CONFIG]
})
export class AppConfigModule {}
