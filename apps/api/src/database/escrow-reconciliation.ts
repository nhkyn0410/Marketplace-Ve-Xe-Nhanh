import type { ReconciliationIssue } from "@vexenhanh/types";
import type { PrismaService } from "./prisma.service";

export type EscrowReconciliation = { ledgerEntriesChecked: number; payoutsChecked: number; issueCount: number; issues: ReconciliationIssue[] };

/** Đối chiếu sổ giữ hộ với thanh toán, hoàn tiền và kỳ chi trả trên cùng snapshot SQL; chỉ báo sai lệch, không sửa tiền. */
export async function reconcileEscrow(prisma: Pick<PrismaService, "withSystem">): Promise<EscrowReconciliation> {
  return prisma.withSystem(async (tx) => {
    const rows = await tx.$queryRaw<{ ledgerEntriesChecked: bigint; payoutsChecked: bigint; issueCount: bigint; issues: ReconciliationIssue[] }[]>`
      WITH captured AS (
        SELECT payment_id, operator_id, SUM(amount) AS amount, COUNT(*) AS entries
        FROM escrow_ledgers WHERE entry_type = 'PAYMENT_CAPTURED' GROUP BY payment_id, operator_id
      ), refunded AS (
        SELECT refund_id, operator_id, -SUM(amount) AS amount, COUNT(*) AS entries
        FROM escrow_ledgers WHERE entry_type = 'REFUND' GROUP BY refund_id, operator_id
      ), paid_out AS (
        SELECT payout_id, operator_id, -SUM(amount) AS amount, COUNT(*) AS entries
        FROM escrow_ledgers WHERE entry_type = 'PAYOUT' GROUP BY payout_id, operator_id
      ), booking_sums AS (
        SELECT booking_id, operator_id,
          COALESCE(SUM(amount) FILTER (WHERE entry_type = 'PAYMENT_CAPTURED'), 0) AS captured,
          COALESCE(SUM(amount) FILTER (WHERE entry_type = 'PLATFORM_FUNDED_DISCOUNT'), 0) AS subsidy,
          -COALESCE(SUM(amount) FILTER (WHERE entry_type = 'PLATFORM_FUNDED_DISCOUNT_REVERSAL'), 0) AS subsidy_reversed,
          -COALESCE(SUM(amount) FILTER (WHERE entry_type = 'REFUND'), 0) AS refunded,
          -COALESCE(SUM(amount) FILTER (WHERE entry_type = 'COMMISSION'), 0) AS commission,
          COALESCE(SUM(amount) FILTER (WHERE entry_type = 'COMMISSION_REVERSAL'), 0) AS commission_reversed,
          MAX(commission_rate_bps) FILTER (WHERE entry_type = 'COMMISSION') AS rate
        FROM escrow_ledgers GROUP BY booking_id, operator_id
      ), item_sums AS (
        SELECT payout_id, operator_id, SUM(amount) AS amount,
          COALESCE(SUM(amount) FILTER (WHERE entry_type IN ('PAYMENT_CAPTURED', 'PLATFORM_FUNDED_DISCOUNT')), 0) AS gross,
          -COALESCE(SUM(amount) FILTER (WHERE entry_type IN ('COMMISSION', 'COMMISSION_REVERSAL')), 0) AS commission,
          -COALESCE(SUM(amount) FILTER (WHERE entry_type IN ('REFUND', 'PLATFORM_FUNDED_DISCOUNT_REVERSAL')), 0) AS refund,
          COALESCE(SUM(amount) FILTER (WHERE entry_type = 'ADJUSTMENT'), 0) AS adjustment
        FROM payout_items GROUP BY payout_id, operator_id
      ), issues AS (
        SELECT 'PAYMENT_CAPTURE' AS checkpoint, p.id AS "entityId", p.operator_id AS "operatorId",
          p.amount::text AS expected, COALESCE(c.amount, 0)::text AS actual
        FROM payments p LEFT JOIN captured c ON c.payment_id = p.id AND c.operator_id = p.operator_id
        WHERE p.status = 'SUCCESS' AND (COALESCE(c.amount, 0) <> p.amount OR COALESCE(c.entries, 0) <> 1)
        UNION ALL
        SELECT 'CAPTURE_STATUS', p.id, p.operator_id, 'SUCCESS', p.status::text
        FROM payments p JOIN captured c ON c.payment_id = p.id AND c.operator_id = p.operator_id WHERE p.status <> 'SUCCESS'
        UNION ALL
        SELECT 'REFUND_LEDGER', r.id, r.operator_id, r.amount::text, COALESCE(e.amount, 0)::text
        FROM refunds r JOIN payments p ON p.id = r.payment_id AND p.operator_id = r.operator_id
        LEFT JOIN refunded e ON e.refund_id = r.id AND e.operator_id = r.operator_id
        WHERE r.status = 'SUCCESS' AND p.status <> 'RECONCILING' AND (COALESCE(e.amount, 0) <> r.amount OR COALESCE(e.entries, 0) <> 1)
        UNION ALL
        SELECT 'REFUND_STATUS', r.id, r.operator_id, 'SUCCESS', r.status::text
        FROM refunds r JOIN refunded e ON e.refund_id = r.id AND e.operator_id = r.operator_id WHERE r.status <> 'SUCCESS'
        UNION ALL
        SELECT 'PLATFORM_SUBSIDY', b.id, b.operator_id, COALESCE(r.discount, 0)::text, s.subsidy::text
        FROM bookings b JOIN booking_sums s ON s.booking_id = b.id AND s.operator_id = b.operator_id
        LEFT JOIN promotion_redemptions r ON r.booking_id = b.id AND r.operator_id = b.operator_id AND r.funded_by = 'PLATFORM' AND r.status = 'USED'
        WHERE s.captured > 0 AND s.subsidy <> COALESCE(r.discount, 0)
        UNION ALL
        SELECT 'SUBSIDY_REVERSAL', s.booking_id, s.operator_id,
          LEAST(s.subsidy, FLOOR(s.subsidy::numeric * s.refunded / s.captured))::text, s.subsidy_reversed::text
        FROM booking_sums s WHERE s.captured > 0
          AND s.subsidy_reversed <> LEAST(s.subsidy, FLOOR(s.subsidy::numeric * s.refunded / s.captured))
        UNION ALL
        SELECT 'COMMISSION', b.id, b.operator_id, FLOOR((b.subtotal - b.discount + s.subsidy)::numeric * s.rate / 10000)::text, s.commission::text
        FROM bookings b JOIN booking_sums s ON s.booking_id = b.id AND s.operator_id = b.operator_id
        WHERE s.rate IS NOT NULL AND s.commission <> FLOOR((b.subtotal - b.discount + s.subsidy)::numeric * s.rate / 10000)
        UNION ALL
        SELECT 'COMMISSION_REVERSAL', s.booking_id, s.operator_id,
          LEAST(s.commission, FLOOR((s.refunded + s.subsidy_reversed)::numeric * s.rate / 10000))::text, s.commission_reversed::text
        FROM booking_sums s WHERE s.rate IS NOT NULL
          AND s.commission_reversed <> LEAST(s.commission, FLOOR((s.refunded + s.subsidy_reversed)::numeric * s.rate / 10000))
        UNION ALL
        SELECT 'PAYOUT_TOTAL', p.id, p.operator_id, p.amount::text, COALESCE(i.amount, 0)::text
        FROM payouts p LEFT JOIN item_sums i ON i.payout_id = p.id AND i.operator_id = p.operator_id
        WHERE p.status <> 'CANCELLED' AND (p.amount <> COALESCE(i.amount, 0) OR p.gross_amount <> COALESCE(i.gross, 0)
          OR p.commission_amount <> COALESCE(i.commission, 0) OR p.refund_amount <> COALESCE(i.refund, 0) OR p.adjustment_amount <> COALESCE(i.adjustment, 0))
        UNION ALL
        SELECT 'PAYOUT_ITEM', i.id, i.operator_id, e.amount::text, i.amount::text
        FROM payout_items i JOIN escrow_ledgers e ON e.id = i.ledger_entry_id AND e.operator_id = i.operator_id
        WHERE i.amount <> e.amount OR i.entry_type <> e.entry_type OR i.booking_id IS DISTINCT FROM e.booking_id OR i.trip_id IS DISTINCT FROM e.trip_id
        UNION ALL
        SELECT 'PAID_PAYOUT', p.id, p.operator_id, p.amount::text, COALESCE(e.amount, 0)::text
        FROM payouts p LEFT JOIN paid_out e ON e.payout_id = p.id AND e.operator_id = p.operator_id
        WHERE p.status = 'PAID' AND (p.amount <> COALESCE(e.amount, 0) OR COALESCE(e.entries, 0) <> 1)
        UNION ALL
        SELECT 'PAYOUT_STATUS', p.id, p.operator_id, 'PAID', p.status::text
        FROM payouts p JOIN paid_out e ON e.payout_id = p.id AND e.operator_id = p.operator_id WHERE p.status <> 'PAID'
      )
      SELECT (SELECT COUNT(*) FROM escrow_ledgers) AS "ledgerEntriesChecked", (SELECT COUNT(*) FROM payouts) AS "payoutsChecked",
        (SELECT COUNT(*) FROM issues) AS "issueCount",
        COALESCE((SELECT jsonb_agg(to_jsonb(i)) FROM (SELECT * FROM issues ORDER BY checkpoint, "entityId" LIMIT 100) i), '[]'::jsonb) AS issues`;
    const row = rows[0]!;
    return { ledgerEntriesChecked: Number(row.ledgerEntriesChecked), payoutsChecked: Number(row.payoutsChecked), issueCount: Number(row.issueCount), issues: row.issues };
  });
}
