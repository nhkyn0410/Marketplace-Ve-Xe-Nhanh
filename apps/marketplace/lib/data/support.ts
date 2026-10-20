import { unavailable, type DataResult } from "./result";
import type {
  MyComplaintsData,
  ComplaintDetailData,
  NewComplaintPayload,
  GuestComplaintFormData
} from "./types";

/**
 * Lấy danh sách khiếu nại của hành khách đã đăng nhập (SCR-PSG-30).
 * Endpoint 06 API: GET /me/complaints
 */
export async function getMyComplaints(): Promise<DataResult<MyComplaintsData>> {
  return unavailable("GET /me/complaints");
}

/**
 * Lấy chi tiết một khiếu nại (SCR-PSG-30).
 * Endpoint 06 API: GET /me/complaints/{complaintId}
 */
export async function getComplaintDetail(
  complaintId: string
): Promise<DataResult<ComplaintDetailData>> {
  return unavailable(`GET /me/complaints/${complaintId}`);
}

/**
 * Gửi yêu cầu khiếu nại mới từ tài khoản đã đăng nhập (SCR-PSG-31).
 * Endpoint 06 API: POST /me/complaints
 */
export async function submitComplaint(
  _payload: NewComplaintPayload
): Promise<DataResult<{ readonly complaintId: string; readonly code: string }>> {
  return unavailable("POST /me/complaints");
}

/**
 * Gửi phản hồi / bổ sung thông tin cho khiếu nại (SCR-PSG-30).
 * Endpoint 06 API: POST /me/complaints/{complaintId}/messages
 */
export async function replyComplaint(
  complaintId: string,
  _content: string,
  _attachments?: readonly string[]
): Promise<DataResult<{ readonly messageId: string }>> {
  return unavailable(`POST /me/complaints/${complaintId}/messages`);
}

/**
 * Lấy danh sách khiếu nại của khách vãng lai đã xác thực (SCR-PSG-32).
 * Endpoint 06 API: GET /guest/complaints
 */
export async function getGuestComplaints(
  _token?: string
): Promise<DataResult<MyComplaintsData>> {
  return unavailable("GET /guest/complaints");
}

/**
 * Khách vãng lai gửi khiếu nại (SCR-PSG-32).
 * Endpoint 06 API: POST /guest/complaints
 */
export async function submitGuestComplaint(
  _payload: GuestComplaintFormData
): Promise<DataResult<{ readonly complaintId: string; readonly code: string }>> {
  return unavailable("POST /guest/complaints");
}

