import { paidPrice } from "../refund/refund-policy";

/** Tiền khách được hoàn khi nhà xe hủy: phần thực trả của vé còn hiệu lực, không vượt khoản thanh toán còn lại. */
export function tripCancellationRefund(prices: readonly bigint[], subtotal: bigint, discount: bigint, paid: bigint, priorRefunds: bigint): bigint {
  const ticketPaid = prices.reduce((sum, price) => sum + paidPrice(price, subtotal, discount), 0n);
  const remaining = paid > priorRefunds ? paid - priorRefunds : 0n;
  return ticketPaid < remaining ? ticketPaid : remaining;
}
