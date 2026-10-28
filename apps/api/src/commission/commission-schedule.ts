import { HttpException, HttpStatus } from "@nestjs/common";

export type CommissionScheduleRule = {
  operatorId: string | null;
  channel: "ONLINE" | "COUNTER";
  rateBps: number;
  effectiveFrom: Date;
  effectiveTo: Date | null;
};

/** Kiểm mức quầy được cấu hình thấp hơn online tại mọi mốc đổi hiệu lực từ hiện tại trở đi. */
export function assertCounterBelowOnline(rules: readonly CommissionScheduleRule[], operatorId: string, now: Date): void {
  const boundaries = new Set([now.getTime()]);
  for (const rule of rules) {
    if (rule.effectiveFrom > now) boundaries.add(rule.effectiveFrom.getTime());
    if (rule.effectiveTo && rule.effectiveTo > now) boundaries.add(rule.effectiveTo.getTime());
  }
  for (const boundary of boundaries) {
    const active = rules.filter((rule) => rule.effectiveFrom.getTime() <= boundary && (!rule.effectiveTo || rule.effectiveTo.getTime() > boundary));
    const online = latest(active.filter((rule) => rule.channel === "ONLINE" && rule.operatorId === operatorId))
      ?? latest(active.filter((rule) => rule.channel === "ONLINE" && rule.operatorId === null));
    const counter = latest(active.filter((rule) => rule.channel === "COUNTER" && rule.operatorId === operatorId));
    // 0% khi KHÔNG cấu hình riêng là quyết định của Khanh, kể cả online cũng đang 0%.
    if (counter && counter.rateBps >= (online?.rateBps ?? 500)) {
      throw new HttpException({ code: "COUNTER_COMMISSION_NOT_LOWER", title: "Commission error", detail: "Hoa hồng quầy được cấu hình phải thấp hơn hoa hồng online của nhà xe trong toàn bộ khoảng hiệu lực." }, HttpStatus.UNPROCESSABLE_ENTITY);
    }
  }
}

function latest(rules: CommissionScheduleRule[]): CommissionScheduleRule | undefined {
  return rules.sort((left, right) => right.effectiveFrom.getTime() - left.effectiveFrom.getTime())[0];
}
