import type { JourneyDemoSnapshot } from "@vexenhanh/types";

export const JOURNEY_DEMO_JOB = "journey-demo-tick";
export const JOURNEY_DEMO_STEP_MS = 30_000;
export const JOURNEY_DEMO_TTL_SECONDS = 600;
export type JourneyDemoSession = {
  userId: string;
  deviceId: string;
  operatorId: string;
  startedAt: number;
  provinces: string[];
  deliveredRevision?: number;
  snapshot: JourneyDemoSnapshot;
};
export type JourneyDemoJob = { sessionId: string; deviceId: string; revision: number };

/** Mốc thời gian cố định: retry cùng revision luôn tạo cùng snapshot. */
export function journeyDemoSnapshot(session: JourneyDemoSession, revision: number): JourneyDemoSnapshot {
  const step = Math.max(0, Math.min(7, revision));
  const progress = [0, 120, 300, 500, 700, 900, 1000, 1000][step]!;
  const provinceIndex = Math.min(session.provinces.length - 1, Math.floor(progress * session.provinces.length / 1001));
  return {
    ...session.snapshot,
    revision: step,
    stage: step === 7 ? "stopped" : step === 6 ? "arrived" : step < 2 ? "approaching" : "travelling",
    provinceName: session.provinces[provinceIndex] ?? "Mô phỏng",
    progress,
    updatedAt: new Date(session.startedAt + step * JOURNEY_DEMO_STEP_MS).toISOString(),
    ended: step === 7,
  };
}
