import Decimal from "decimal.js";

export type VndAmount = bigint;

export function assertVndAmount(value: bigint): VndAmount {
  if (value < 0n) {
    throw new Error("VND amount must be non-negative");
  }

  return value;
}

export function vndToDecimal(value: VndAmount): Decimal {
  return new Decimal(value.toString());
}
