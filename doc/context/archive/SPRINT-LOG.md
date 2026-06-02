# SPRINT-LOG (archived) — Marketplace-Ve-Xe-Nhanh

Chi tiet Sprint 0-4 (workshop tables) + roadmap 15-layer (§6.5.1) + canh bao re-select (§6.5.2). Di tu `CLAUDE.md §6.5` ngay 02/06/2026 de giam context bloat. Tat ca da hoan tat (19/19 layer + rework xong); giu lam tham khao lich su.

**Sprint 5 — Rework batch DONE (01/06/2026)**: Khanh chọn **hướng (b) Rework SDLC docs** trước DevOps. Reset HLD/DB/LLD/API/Security theo 18 ADR, thứ tự dependency. Defer 09 Deploy + 08 Test + 11 Task sang Phase 4 (phụ thuộc deploy target / test framework / CI-CD chưa chốt). 06 UI độc lập tech-stack, không thuộc diện rework theo ADR.

| # | Doc | Trạng thái | Ghi chú |
| - | --- | ---------- | ------- |
| 1 | 02 HLD | ✅ v0.4 (01/06/2026) | Reset theo 18 ADR; đóng HLD-OQ-09/10; raise HLD-OQ-11 realtime; chờ Khanh review → Review |
| 2 | 04 DB | ✅ v0.4 (01/06/2026) | Hybrid-A Postgres+Prisma / Mongo audit; đóng DB-OQ-01/04/05; SeatHold=Redis |
| 3 | 03 LLD | ✅ v0.4 (01/06/2026) | Module NestJS; **ADR-017 re-confirmed** (Khanh chốt toàn bộ); thêm 6.5 auth + 6.6 payout |
| 4 | 05 API | ✅ v0.2 (01/06/2026) | REST + OpenAPI 3.1/Zod, RFC 7807, webhook HMAC; đóng API-OQ-01/02/03 |
| 5 | 07 Security | ✅ v0.4 (01/06/2026) | Better Auth+token+MFA+OAuth+RLS+PCI; **ADR-019/020 re-confirmed**; đóng SEC-OQ-01/02/04/06 |

✅ **Sprint 5 batch rework HOÀN TẤT (01/06/2026)**: 5/5 doc unblocked reset theo 18 ADR; cả 3 CRITICAL re-confirm (ADR-017/019/020) DONE qua AskUserQuestion. 5 doc Draft chờ Khanh review → promote Review/Approved. Còn 09 Deploy + 08 Test + 11 Task defer Phase 4 (phụ thuộc DevOps).

**Sprint 4 — Phase 4 DevOps CLOSED (01/06/2026)** — 4/4 layer chốt (chạy sau Sprint 5 rework, Khanh chọn hướng b). Workshop 4 layer × 1 ADR (Layer 16-19 = ADR-023..026):

| Layer | Quyết định | ADR | Trạng thái |
| ----- | ---------- | --- | ---------- |
| 16 — Deploy target | **Render managed PaaS (SG)** cho Node API + BullMQ worker; DB managed-separate Supabase/Neon + Atlas SG; Docker + GitHub auto-deploy | ADR-023 | ✅ chốt 01/06/2026 |
| 17 — Worker deployment | **Tách Render Background Worker** (cùng image, khác start command); payout cron BullMQ repeat concurrency 1; resolve ADR-016 defer | ADR-024 | ✅ chốt 01/06/2026 |
| 18 — Test framework | **Vitest** (unit+integration BE+FE monorepo) + **Supertest** (e2e API) + **Playwright** (e2e web) + **Maestro** (e2e mobile Expo); mandatory test money/idempotency/tenant-RLS | ADR-025 | ✅ chốt 01/06/2026 |
| 19 — Monitoring + CI/CD | **Sentry-centric** (error+perf+trace BE+FE+Mobile) + Pino logs + OTel + **GitHub Actions** + Render auto-deploy | ADR-026 | ✅ chốt 01/06/2026 |

→ ✅ **DoD Sprint 4 MET**: 4 ADR (ADR-023..026) + 09 Deploy v0.4 / 08 Test v0.2 / 11 Task v0.3 **reworked**. **19/19 layer roadmap (15 tech + 4 DevOps) CHỐT XONG.** **Toàn bộ 8/8 doc tech-dependent reworked** (02 HLD / 03 LLD / 04 DB / 05 API / 07 Security / 08 Test / 09 Deploy / 11 Task) — chờ Khanh review → Review. Còn 06 UI (tech-independent); 12 Release Notes skeleton DONE (v0.1, điền entry khi code production).

**Sprint 0 — CLOSED 25/05/2026** (3/3 layer foundation):

| Layer | Chốt | ADR |
| ----- | ---- | --- |
| Layer 1 — Architectural pattern | Modular monolith framework-agnostic | ADR-002 (refined) |
| Layer 2 — Backend language + runtime | TypeScript + Node.js LTS 22.x | ADR-009 |
| Layer 3 — Backend framework | NestJS 11 + nestjs-zod | ADR-010 |

**Sprint 1 — CLOSED 25/05/2026** (4/4 layer Phase 1 Foundation):

| Layer | Chốt | ADR |
| ----- | ---- | --- |
| Layer 4 — DB paradigm + vendor | Hybrid-A: Postgres 16 + Prisma 5 ops, Mongo 7 + Mongoose audit (cluster RIÊNG) | ADR-011 (supersedes ADR-003); re-closes OQ-14 |
| Layer 5 — API style | REST + OpenAPI 3.1 auto (Zod single source) | ADR-012 |
| Layer 6 — Frontend framework | Next.js 16 App Router + Turborepo monorepo (pnpm) | ADR-013 |
| Layer 7 — Mobile framework | Expo (managed) SDK 55+ + 2-app split (Passenger + Employee) | ADR-014 (supersedes ADR-007); re-closes OQ-10 |

**Sprint 2 — CLOSED 26/05/2026** (4/4 layer Phase 2 Infrastructure):

| Layer | Chốt | ADR |
| ----- | ---- | --- |
| Layer 8 — Cache + distributed lock | Redis 7 trên Upstash managed SG (cache + lock) | ADR-015 (supersedes ADR-004) |
| Layer 9 — Async job queue | BullMQ + @nestjs/bullmq trên cùng Redis Upstash | ADR-016 |
| Layer 10 — Auth library | Better Auth + custom NestJS adapter + Identity 3 namespace + Closed enrollment + Hybrid token + RBAC + TenantGuard+RLS | ADR-017 |
| Layer 11 — Object storage | Cloudflare R2 + storage adapter; KYC dev-local / production-defer (OQ-21) | ADR-018; closes SEC-OQ-04 |

**Sprint 3 — CLOSED 01/06/2026** (4/4 layer Phase 3 VN Vendor):

| Layer | Chốt | ADR |
| ----- | ---- | --- |
| Layer 12 — Payment gateway | VNPay primary + MoMo phương thức 2 (đa phương thức v1) sau `PaymentGateway` adapter | ADR-019; re-closes OQ-05 |
| Layer 13 — Notification + OAuth | Resend Email + SMS defer + Expo Push + OAuth Google/Facebook/Apple (Passenger-only) | ADR-020; re-closes OQ-09 |
| Layer 14 — Routing + Map | Mapbox Matrix API + GL (free tier) sau `RoutingProvider` adapter; OSRM escape-hatch | ADR-021 |
| Layer 15 — Bank payout | Manual admin-confirm + batch export sau `PayoutProvider` adapter; auto-disbursement defer v1.x | ADR-022; re-closes OQ-16 |

→ **Phase 3 VN Vendor hoàn tất. Toàn bộ 5 OQ vendor re-opened (OQ-05/09/10/14/16) re-closed — KHÔNG còn OQ vendor block MVP.** 2 production-blocker mới: OQ-21 (KYC storage), OQ-22 (TGTT license) — defer production prep. **15/15 layer tech-selection CHỐT XONG.** Sprint 4 mở khóa Phase 4 DevOps — chờ Khanh Sprint Planning.

**Sprint 4 Sprint Goal (đề xuất, chờ Khanh chốt)** — Phase 4 DevOps (theo §6.5.1 "có thể defer"): chốt deploy/ops stack + resolve worker deployment defer từ ADR-016:

16. **Deploy target** — container (Docker) + host (VPS / Railway / Render / Fly.io / VN cloud) cho API + worker + Postgres + Mongo (Upstash Redis đã managed)
17. **Worker deployment** — tách BullMQ worker khỏi API process (defer từ ADR-016) hay giữ in-process v1
18. **Test framework** — unit (Vitest/Jest) + e2e (Supertest) + mobile (Detox/Maestro)
19. **Monitoring + CI/CD** — observability (log/metric/trace) + GitHub Actions pipeline

→ **Lựa chọn chiến lược cho Khanh**: Phase 4 §6.5.1 đánh dấu "có thể defer". Hai hướng:
- **(a) Sprint 4 DevOps ngay** — chốt deploy/test/monitoring trước
- **(b) Skip sang Sprint 5-6 Rework SDLC docs** — reset HLD/LLD/DB/Security/Deploy/API/Test theo stack đã chốt (18 ADR). Rework KHÔNG bị Phase 4 chặn (chỉ 09 Deploy cần deploy target).

**Đề xuất của tôi: (b) rework trước** — value cao hơn (đồng bộ 18 ADR vào SDLC docs đang treo, gỡ blocker §5), DevOps quyết khi gần code thật hơn. ⚠️ Rework 07 Security + LLD phải **re-confirm CRITICAL các ADR-017/019/020** (token model, OAuth, payment primary, notification — Khanh chốt qua "[No preference]"/tiêu chí).

**Workflow mỗi layer (giữ nguyên từ Sprint 0-2)**:

1. AI prep options matrix (3-7 option × axes: AI assist, VN vendor fit, Khanh skill fit, ecosystem, learning curve, time-to-v1, license/cost, marketplace fit, NestJS integration, Strangler-ready) — 1-2 ngày
2. Khanh đọc + clarify
3. AI propose recommendation (nói rõ lý do)
4. Khanh chốt qua `AskUserQuestion`
5. AI ghi ADR tuần tự (Layer 12 = ADR-019, Layer 13 = ADR-020, ...)
6. AI update `CLAUDE.md §2` + `PROJECT-STATE §1/§7` + close OQ liên quan trong `§3` / `§4`

**DoD Sprint 4 (nếu chọn hướng a DevOps)**: 4 ADR (Layer 16-19) ghi vào file 10 + 09 Deploy unblocked + worker deployment (ADR-016 defer) resolved + 11 Task Breakdown unblocked.

**DoD Sprint 5-6 (nếu chọn hướng b Rework)**: HLD/LLD/DB/Security/Deploy/API/Test v0.x reset theo 18 ADR; re-confirm CRITICAL ADR-017/019/020; promote các doc đã đồng bộ lên Review (chờ Khanh duyệt Approved).

**Ước lượng**: hướng (a) ~2 tuần; hướng (b) ~3-4 tuần (rework 7 doc). Khanh chọn thứ tự ở Sprint Planning.

### 6.5.1. Roadmap tech selection — 15 layer, 4 phase

Phase trước phải xong mới mở khóa phase sau. Mỗi layer = 1 ADR.

**Phase 1 — Foundation** (Sprint 0-1, mở khóa rework HLD/LLD/DB/API):

1. Architectural pattern
2. Backend language + runtime
3. Backend framework
4. Database paradigm + vendor (Document NoSQL / Relational / NewSQL / hybrid)
5. API style (REST / GraphQL / tRPC / RPC)
6. Frontend framework
7. Mobile framework

**Phase 2 — Infrastructure** (Sprint 2, mở khóa rework Security/Deploy):

8. Cache + distributed lock layer
9. Async job queue
10. Auth library
11. Object storage provider (re-poses Sprint 0 cũ Item 1)

**Phase 3 — VN vendor** (Sprint 3, re-close OQ-05/09/14/16):

12. Payment gateway
13. Email + SMS + Push providers
14. Routing engine
15. Bank payout channel (re-poses Sprint 0 cũ Item 2)

**Phase 4 — DevOps** (Sprint 4, có thể defer): deploy target / test framework / monitoring / CI-CD.

**Sprint 5-6 — Rework SDLC docs**: HLD/LLD/DB/Security/Deploy/API/Test v0.x reset theo stack mới.

**Tổng ước lượng**: ~6 Sprint (~12 tuần) cho tech selection + SDLC rework.

### 6.5.2. Cảnh báo — chỗ phụ thuộc trong khi đang re-select

Trong giai đoạn Sprint 0-4, các doc sau **bị treo trạng thái**, không advance lên Review:

- 02 HLD §13 (tech stack), §8 (module map nếu đổi framework)
- 03 LLD §5 (module structure)
- 04 DB toàn file (depends DB paradigm)
- 05 API (depends API style)
- 07 Security §5/§6 (depends auth library, DB tenant filter mechanism)
- 09 Deploy toàn file (depends container/deploy target)
- 10 ADR (mở thêm ADR-003a..003n)
- 11 Task Breakdown (depends ngôn ngữ/framework)

→ Các doc khác (00 chuẩn, 01 SRS business logic, 06 UI flow, 08 Test logic) **vẫn có thể tiến** vì độc lập với tech stack.
