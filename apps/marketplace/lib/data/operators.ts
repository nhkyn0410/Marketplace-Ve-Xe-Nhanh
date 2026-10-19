import { DataResult, unavailable } from "./result";
import { OperatorProfileData } from "./types";

/**
 * Lấy hồ sơ thông tin chi tiết nhà xe.
 * Endpoint: GET /operators/{operatorId} (chưa có trong hợp đồng API).
 */
export async function getOperatorProfile(
  operatorId: string
): Promise<DataResult<OperatorProfileData>> {
  return Promise.resolve(unavailable(`GET /operators/${operatorId}`));
}
