import { describe, expect, it } from "vitest";

import {
  barTimeLabel,
  buildSchedule,
  choiceNote,
  dayWindow,
  freeFromLabel,
  previousLocalDate,
  slotAt,
  vehicleChoices,
  type ScheduleTrip
} from "./vehicle-schedule";

// Ví dụ theo Figma "07 · Chuyến xe / Lịch xe" ngày 10/10/2026 (giờ VN = UTC+7).
const at = (date: string, time: string) => new Date(`${date}T${time}:00+07:00`).toISOString();
const trip = (id: string, vehicleId: string | null, routeId: string, from: string, to: string, status: ScheduleTrip["status"] = "OPEN_FOR_SALE", toDate = "2026-10-10", fromDate = "2026-10-10"): ScheduleTrip => ({
  id,
  routeId,
  routeName: routeId === "sg-dl" ? "Sài Gòn – Đà Lạt" : routeId === "dl-sg" ? "Đà Lạt – Sài Gòn" : "Sài Gòn – Nha Trang",
  vehicleId,
  departureAt: at(fromDate, from),
  arrivalAt: at(toDate, to),
  status
});
const PLACES: Record<string, string> = { "sg-dl": "Đà Lạt", "dl-sg": "Sài Gòn", "sg-nt": "Nha Trang", "nt-sg": "Sài Gòn" };
const destinationOf = (routeId: string) => PLACES[routeId];
const vehicles = [{ id: "v1" }, { id: "v2" }, { id: "v3" }, { id: "v4" }, { id: "v5" }];
const trips = [
  trip("a", "v1", "sg-dl", "06:00", "11:30", "IN_PROGRESS"),
  trip("b", "v1", "dl-sg", "13:00", "18:30"),
  trip("c", "v2", "sg-dl", "08:30", "14:00", "IN_PROGRESS"),
  trip("d", "v2", "dl-sg", "14:00", "19:30", "DRAFT"),
  trip("e", "v3", "sg-dl", "06:00", "11:30", "CANCELLED"),
  trip("f", "v3", "sg-nt", "13:00", "21:15", "LOCKED"),
  trip("g", "v4", "nt-sg", "20:00", "04:30", "COMPLETED", "2026-10-10", "2026-10-09"),
  trip("h", "v4", "sg-nt", "20:00", "03:30", "OPEN_FOR_SALE", "2026-10-11"),
  trip("i", null, "sg-nt", "15:00", "23:15", "DRAFT")
];

describe("lịch xe — dòng thời gian", () => {
  it("mỗi xe một hàng; chuyến qua đêm cắt theo ngày; hàng chưa gắn xe; số liệu tóm tắt như Figma", () => {
    const schedule = buildSchedule(vehicles, trips, "2026-10-10", destinationOf);
    expect(schedule.summary).toEqual({ vehicleCount: 5, departures: 8, unassigned: 1, idleVehicles: 1 });
    const v4 = schedule.rows[3]!;
    expect(v4.bars.map((bar) => [bar.trip.id, bar.startsBefore, bar.endsAfter])).toEqual([
      ["g", true, false],
      ["h", false, true]
    ]);
    expect(v4.bars[0]!.leftPct).toBe(0);
    expect(v4.bars[0]!.widthPct).toBeCloseTo((4.5 / 24) * 100);
    expect(v4.bars[1]!.leftPct).toBeCloseTo((20 / 24) * 100);
    expect(v4.bars[1]!.leftPct + v4.bars[1]!.widthPct).toBeCloseTo(100);
    expect(schedule.unassigned.map((bar) => bar.trip.id)).toEqual(["i"]);
    expect(schedule.rows[4]!.bars).toEqual([]);
    expect(schedule.rows[4]!.freeFrom).toBeNull();
  });

  it("rảnh từ: giờ đến chuyến chưa hủy cuối cùng + nơi đến; chuyến hủy không giữ xe; nối chuyến sát giờ", () => {
    const schedule = buildSchedule(vehicles, trips, "2026-10-10", destinationOf);
    expect(schedule.rows[0]!.freeFrom).toEqual({ at: at("2026-10-10", "18:30"), place: "Sài Gòn" });
    expect(schedule.rows[2]!.freeFrom).toEqual({ at: at("2026-10-10", "21:15"), place: "Nha Trang" });
    expect(freeFromLabel(schedule.rows[3]!.freeFrom!.at, "2026-10-10")).toBe("03:30 · 11/10");
    expect(freeFromLabel(at("2026-10-10", "18:30"), "2026-10-10")).toBe("18:30");
    expect(schedule.rows[1]!.bars.map((bar) => bar.tight)).toEqual([false, true]);
    // Chuyến 13:00 của xe 3 không "sát giờ" vì chuyến 06:00 đã hủy.
    expect(schedule.rows[2]!.bars.map((bar) => bar.tight)).toEqual([false, false]);
  });

  it("nhãn giờ của dải chuyến; ngày trước; ô trống → giờ tròn 30 phút", () => {
    const schedule = buildSchedule(vehicles, trips, "2026-10-10", destinationOf);
    expect(schedule.rows[3]!.bars.map(barTimeLabel)).toEqual(["đến 04:30", "20:00 – 03:30 +1"]);
    expect(barTimeLabel(schedule.rows[0]!.bars[0]!)).toBe("06:00 – 11:30");
    expect(previousLocalDate("2026-10-01")).toBe("2026-09-30");
    expect(dayWindow("2026-10-10").endMs - dayWindow("2026-10-10").startMs).toBe(86_400_000);
    expect(slotAt("2026-10-10", 0.5)).toEqual({ date: "2026-10-10", time: "12:00" });
    expect(slotAt("2026-10-10", 0.999)).toEqual({ date: "2026-10-10", time: "23:30" });
  });
});

describe("lịch xe — chọn xe cho chuyến (Figma 08)", () => {
  const dep = new Date(at("2026-10-10", "20:00")).getTime();
  const arr = new Date(at("2026-10-11", "01:30")).getTime();

  it("chia Rảnh / Trùng giờ trong khoảng chuyến; bỏ qua chuyến hủy và chính chuyến đang sửa", () => {
    const { free, busy } = vehicleChoices(vehicles, trips, dep, arr);
    expect(free.map((choice) => choice.vehicle.id)).toEqual(["v1", "v2", "v5"]);
    expect(busy.map((choice) => [choice.vehicle.id, choice.conflict?.id])).toEqual([
      ["v3", "f"],
      ["v4", "h"]
    ]);
    expect(vehicleChoices(vehicles, trips, dep, arr, "h").free.map((choice) => choice.vehicle.id)).toContain("v4");
  });

  it("dòng phụ: rảnh từ + nơi chuyến trước đến; rảnh cả ngày; bận tới giờ nào, chuyến nào", () => {
    const { free, busy } = vehicleChoices(vehicles, trips, dep, arr);
    expect(free.map((choice) => choiceNote(choice, "2026-10-10", destinationOf))).toEqual([
      "Rảnh từ 18:30 · chuyến trước đến Sài Gòn",
      "Rảnh từ 19:30 · chuyến trước đến Sài Gòn",
      "Rảnh cả ngày · chưa có chuyến trong ngày"
    ]);
    expect(choiceNote(busy[0]!, "2026-10-10", destinationOf)).toBe("Bận tới 21:15 · Sài Gòn – Nha Trang (13:00 – 21:15)");
    expect(choiceNote(busy[1]!, "2026-10-10", destinationOf)).toBe("Bận tới 03:30 · Sài Gòn – Nha Trang (20:00 – 03:30 hôm sau)");
  });
});
