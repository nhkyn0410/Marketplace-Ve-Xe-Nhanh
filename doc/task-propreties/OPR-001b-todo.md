# TASK-OPR-001b — Todo: Hồ sơ & KYC của nhà xe sau khi được duyệt

> **Nguồn task:** `doc/SDLC/11-project-task-breakdown.md` — `TASK-OPR-001` phần "profile sau khi duyệt" (001b; 001a = đăng ký công khai, xem `OPR-001-todo.md`). Nguồn chi tiết: SRS `FR-OPR-02..05`, `UC-11` bước 1–4 + A3, `UC-23` bước 5 (chép giấy tờ / tài khoản nhận tiền sang Operator), `BR-37`, `BR-57`, `NFR-SEC-05`; DB §5.2 (đã đặt tên `kyc_documents`, `bank_accounts`); Security §7 dòng "Đổi bank account Operator", §9 (mask số tài khoản), ADR-018 (kho private, URL 5 phút + audit); Figma section `Giao diện nhà xe · Màn bổ sung` (`1663:23891`): `01 · Hồ sơ & KYC / Tổng quan` (`1667:27240`), `02 · Hộp thoại đổi tài khoản nhận tiền` (`1667:27586`).
> **Khanh (16/10/2026):** chọn làm "Hồ sơ & KYC nhà xe (OPR-001b)"; phần dữ liệu chưa có thiết kế: "Tự thiết kế + code" (ghi tài liệu, chờ duyệt).
> **Nhánh:** làm tiếp trên `TASK-ADM-004`, chưa commit.

## Trạng thái (16/10/2026) — 🔨 **Code xong, chưa commit — chờ Khanh review + CI**

- Chưa qua `code-reviewer` / `security-auditor` (chỉ chạy khi Khanh yêu cầu — `CLAUDE.md` §4.8).
- Production chưa có kho private (OQ-21) → xem / tải giấy tờ trả 503 như phần 001a.

## Đã làm

### DB (tự thiết kế, chờ duyệt — G1)

- Migration `20261016030000_operator_profile_kyc`:
  - `operator_profiles` thêm `legal_name`, `tax_code`, `hotline`, `public_email`, `address`, `description` (≤ 1000), `approved_at`; chép từ hồ sơ đã duyệt (nhà xe cũ).
  - `kyc_documents` (`operator_id`, `type` dùng lại enum `OperatorApplicationDocumentType`, `object_key` unique, `file_name`, `content_type` PDF/JPEG/PNG, `size_bytes` ≤ 10 MB, `uploaded_at`, `uploaded_by`; unique `(operator_id, type)`; RLS tenant).
  - Enum `BankAccountStatus` (`PENDING`, `VERIFIED`, `REJECTED`, `REPLACED`) + `bank_accounts` (`bank_name`, `account_number` CHECK 6–20 chữ số, `account_holder`, `status`, `change_reason`, `review_note` bắt buộc khi `REJECTED`, `requested_by`, `reviewed_by`, `reviewed_at`); unique một phần: mỗi nhà xe tối đa **một** `VERIFIED` và **một** `PENDING`. RLS: tenant chỉ đọc + chèn `PENDING`; xác minh / từ chối chỉ platform / system.
- Migration `20261016040000_operator_profile_tenant_update`: policy `tenant_update_public` cho phép nhà xe sửa dòng `operator_profiles` của mình + trigger `operator_profiles_tenant_columns` chặn tenant đổi cột ngoài tên hiển thị / hotline / email / địa chỉ / mô tả (trạng thái, lý do khóa, slug, tên pháp lý, MST, ngày duyệt).
- Lúc Admin duyệt hồ sơ (`operator-application-review.service.ts`): trong cùng transaction chép thông tin pháp lý / công khai, giấy tờ (cùng khóa object) và tài khoản nhận tiền (`VERIFIED`, người duyệt = Admin) sang nhà xe (`approved-operator-copy.ts`).

### Backend

- Operator OS — `/operator/profile` (`operator/operator-profile.*`), quyền `kyc:submit` (chỉ chủ nhà xe):
  - `GET` hồ sơ: thông tin công khai + pháp lý, trạng thái, giấy tờ (metadata), tài khoản đang dùng (chỉ 4 số cuối), yêu cầu đổi gần nhất còn chờ / bị từ chối.
  - `PUT` sửa tên hiển thị, hotline, email, địa chỉ, mô tả — audit `operator.profile.update` ghi đúng trường đổi.
  - `POST /documents/upload-url` (khóa `operator-kyc/{operatorId}/{uuid}.{ext}`), `PUT /documents/{type}` (kiểm object: đúng tiền tố nhà xe, đủ mới, dung lượng, loại, chữ ký file) — audit `operator.kyc_document.replace`; bản cũ do nhà xe tự tải bị xóa sau commit, bản chép từ hồ sơ đăng ký giữ nguyên.
  - `POST /documents/{type}/download-url` — URL 5 phút, audit `operator.kyc_document.view`.
  - `POST /bank-account-change` — **xác nhận lại danh tính**; tạo `PENDING`, audit `operator.bank_account.request` (số tài khoản che); đã có yêu cầu chờ → 409 `BANK_ACCOUNT_CHANGE_PENDING`; trùng tài khoản đang dùng → 422 `BANK_ACCOUNT_UNCHANGED`. Tên chủ tài khoản tự viết hoa, bỏ dấu.
- Admin — `/admin/operators` (quyền `kyc:review`): danh sách có cờ `bankChangePending` + lọc `bankChange=PENDING`; `GET /{id}/bank-account-change` (số đầy đủ để đối chiếu, audit `operator.bank_account.view`); `POST …/approve` / `…/reject` (lý do) — xác nhận lại danh tính, khóa dòng `FOR UPDATE`, kèm `changeId` (yêu cầu đã đổi → 404); duyệt: tài khoản cũ → `REPLACED`, mới → `VERIFIED`; audit + email chủ nhà xe (`sendBankAccountChangeDecision`).
- Job dọn giấy tờ mồ côi (03:45 hằng ngày) dọn thêm tiền tố `operator-kyc/`.

### Giao diện

- Operator OS `/profile` theo Figma: Hồ sơ doanh nghiệp (+ hộp thoại Chỉnh sửa), Giấy tờ KYC (Xem / Tải bản mới), Trạng thái hoạt động, Tài khoản nhận tiền (+ hộp thoại Đổi tài khoản: ngân hàng, số tài khoản, chủ tài khoản, lý do, mật khẩu / mã xác thực; báo đang chờ / bị từ chối), Trang công khai (nút tắt).
- Admin `/operators` tab Nhà xe: lọc "Chờ xác minh đổi tài khoản", dòng có nút "Chờ xác minh TK nhận tiền" mở hộp thoại so sánh tài khoản đang dùng / mới (số đầy đủ), tên pháp lý, MST, lý do; Từ chối (bắt buộc lý do) / Xác minh + mã TOTP.

## Chờ Khanh (G1–G10)

| #   | Điểm | Đã làm theo | Cần Khanh |
| --- | ---- | ----------- | --------- |
| G1  | Schema | Như trên (DB §5.2 mới có tên bảng, chưa có cột) | Duyệt |
| G2  | Sửa thông tin công khai | Không cần Admin duyệt lại, không cần xác nhận lại danh tính; chỉ audit | Có cần duyệt / xác nhận lại không |
| G3  | Tên pháp lý / MST | Nhà xe không tự sửa (đổi pháp nhân = KYC lại) | Duyệt / luồng đổi pháp nhân |
| G4  | Logo (FR-OPR-02) | Chưa làm — Figma chỉ có ô chữ viết tắt ("SV") | Có cần tải logo không |
| G5  | Thay giấy tờ KYC | Nhà xe thay được bất kỳ lúc nào, không cần Admin duyệt lại; Admin xem qua nhật ký audit (chưa có màn Admin xem giấy tờ của nhà xe đã duyệt) | Có cần duyệt lại / màn Admin xem giấy tờ |
| G6  | Admin xem số tài khoản đầy đủ | Ở hộp thoại xác minh, mỗi lần mở ghi audit (Security §9 chỉ nói "mask khi hiển thị") | Duyệt |
| G7  | Rút yêu cầu đổi tài khoản | Không có — gửi nhầm thì chờ Admin từ chối | Có cần nút "Hủy yêu cầu" không |
| G8  | Cảnh báo "kỳ chi trả đang chờ rà soát" (Figma) | Chưa làm — chưa có chi trả (`TASK-BTP-*`). Kỳ chi trả sau khi duyệt dùng tài khoản `VERIFIED` hiện tại (SRS §17 "cảnh báo nếu thay đổi gần kỳ payout") | Làm cùng chi trả |
| G9  | "Trang công khai" | Nút "Mở trang nhà xe" tắt — Marketplace chưa dựng (`TASK-MKT-001`) | Mở khi có Marketplace |
| G10 | Email | Báo chủ nhà xe khi duyệt / từ chối; chưa báo lúc gửi yêu cầu (đã có audit) | Có cần email "đã nhận yêu cầu" (phát hiện tài khoản bị chiếm) |

## Kiểm tra (16/10/2026)

- `operator-profile.int.spec.ts` 6 ca trên Postgres (role app, RLS thật) + kho local thật: xem hồ sơ (số tài khoản chỉ 4 số cuối); sửa + audit đúng trường, gửi lại y nguyên không audit, trigger chặn tenant đổi tên pháp lý, tenant khác không sửa được; giấy tờ (thay + xóa bản cũ, xem + audit, khóa nhà xe khác / không phải PDF / chưa tải → 422); đổi tài khoản (trùng 422, chờ 409, tenant không tự xác minh / chèn `VERIFIED`); Admin lọc + xem số đầy đủ + từ chối + gửi lại + duyệt (`REPLACED` / `REJECTED` / `VERIFIED`), email; audit lỗi → 503 không đổi gì.
- `operator-application-review.int.spec.ts` ca duyệt: nhà xe mới có thông tin pháp lý, giấy tờ, tài khoản `VERIFIED`.
- `operator-profile.http.spec.ts` 8 ca (guard thật: chủ nhà xe được, nhân viên / Admin 403, đổi tài khoản cần xác nhận lại; chuẩn hoá + validate). `admin-operator.http.spec.ts` thêm 3 route.
- E2E Operator OS `profile.e2e.ts` 3 ca; E2E Admin `users.e2e.ts` ca 4 (xác minh đổi tài khoản).
- Đối chiếu Figma 1440 px; 390 px không tràn ngang.
- 17/10/2026: `tenant-rls.int.spec.ts` ca `operator_profiles` sửa theo thiết kế mới — tenant tự sửa cột công khai được (trước đây khẳng định không sửa được gì), đổi trạng thái bị trigger chặn. Toàn bộ API 1330 ca đạt.

## Việc tiếp theo

1. Khanh review, chốt G1–G10.
