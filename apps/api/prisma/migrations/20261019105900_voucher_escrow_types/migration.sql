-- BR-73: bút toán riêng phần giảm do nền tảng chịu và đảo khi hoàn tiền.
ALTER TYPE "EscrowEntryType" ADD VALUE IF NOT EXISTS 'PLATFORM_FUNDED_DISCOUNT';
ALTER TYPE "EscrowEntryType" ADD VALUE IF NOT EXISTS 'PLATFORM_FUNDED_DISCOUNT_REVERSAL';
