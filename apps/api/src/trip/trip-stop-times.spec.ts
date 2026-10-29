import { describe, expect, it } from "vitest";
import { keepsLegacyTimes, planStopTimes, roundDeparture, routeArrival } from "./trip.service";

const MINUTE = 60_000;
const HOUR = 60 * MINUTE;
const departureAt = new Date("2031-01-01T00:00:00Z");
const at = (minutes: number) => new Date(departureAt.getTime() + minutes * MINUTE);
/** Điểm đầu không có chặng; `pickup` = điểm giữa cho đón (mặc định có). */
const legs = (...seconds: number[]) => [null, ...seconds].map((durationSecondsFromPrevious) => ({ durationSecondsFromPrevious, allowPickup: true }));

describe("roundDeparture — giờ khởi hành theo bước 5 phút", () => {
  it("làm tròn về mốc gần nhất", () => {
    expect(roundDeparture(at(32))).toEqual(at(30));
    expect(roundDeparture(at(33))).toEqual(at(35));
    expect(roundDeparture(new Date(at(32).getTime() + 31_000))).toEqual(at(35));
    expect(roundDeparture(at(30))).toEqual(at(30));
  });
});

describe("routeArrival — giờ đến theo thời gian chạy của tuyến", () => {
  it("cộng các chặng rồi làm tròn LÊN mốc 5 phút (06:30 + 1 giờ 36 phút → 08:10, như ảnh 08:06)", () => {
    expect(routeArrival(departureAt, legs(3600, 7200))).toEqual(at(180));
    expect(routeArrival(departureAt, legs(3600, 1830))).toEqual(at(95));
    expect(routeArrival(departureAt, legs(96 * 60))).toEqual(at(100));
  });

  it("tuyến chưa tới 1 phút vẫn đến sau giờ đi (CHECK giờ đến sau giờ đi) — thành mốc 5 phút kế tiếp", () => {
    expect(routeArrival(departureAt, legs(0))).toEqual(at(5));
    expect(routeArrival(departureAt, legs(20))).toEqual(at(5));
  });

  it("chuyến cũ giữ cách tính theo phút khi không làm tròn", () => {
    expect(routeArrival(departureAt, legs(3600, 1830), false)).toEqual(at(91));
  });
});

describe("planStopTimes — giờ từng điểm", () => {
  it("không gửi giờ từng điểm: theo thời gian từng chặng, điểm cuối đúng giờ đến", () => {
    const stops = legs(3600, 7200);
    expect(planStopTimes({ departureAt, stopTimes: null }, stops, routeArrival(departureAt, stops))).toEqual([at(0), at(60), at(180)]);
  });

  it("điểm cho đón làm tròn XUỐNG, điểm chỉ trả làm tròn LÊN; không giảm dần, không vượt giờ đến", () => {
    // Chặng 32 phút + 32 phút + 32 phút, giờ đến 96 phút → 100.
    const stops = [
      { durationSecondsFromPrevious: null, allowPickup: true },
      { durationSecondsFromPrevious: 32 * 60, allowPickup: true },
      { durationSecondsFromPrevious: 32 * 60, allowPickup: false },
      { durationSecondsFromPrevious: 32 * 60, allowPickup: false },
    ];
    const arrival = routeArrival(departureAt, stops);
    expect(arrival).toEqual(at(100));
    // Thô: 33,3 → đón: 30; 66,7 → chỉ trả: 70.
    expect(planStopTimes({ departureAt, stopTimes: null }, stops, arrival)).toEqual([at(0), at(30), at(70), at(100)]);
  });

  it("không làm tròn (chuyến cũ): như trước, theo phút tính từ giờ đi", () => {
    const stops = legs(3600, 1830);
    expect(planStopTimes({ departureAt, stopTimes: null }, stops, at(91), false)).toEqual([at(0), at(60), at(91)]);
  });

  it("giờ từng điểm nhà xe gửi được giữ nguyên khi đủ điểm, đầu = giờ đi, cuối = giờ đến theo tuyến", () => {
    const stopTimes = [at(0), at(45), at(180)];
    expect(planStopTimes({ departureAt, stopTimes }, legs(3600, 7200), at(180))).toEqual(stopTimes);
  });

  it.each([
    ["thiếu điểm", [at(0), at(180)]],
    ["điểm đầu lệch giờ đi", [at(5), at(60), at(180)]],
    ["điểm cuối sớm hơn giờ đến theo tuyến", [at(0), at(60), at(150)]],
    ["điểm cuối muộn hơn giờ đến theo tuyến", [at(0), at(60), at(4 * 60)]],
  ])("từ chối %s → TRIP_STOP_TIMES_INVALID", (_case, stopTimes) => {
    expect(() => planStopTimes({ departureAt, stopTimes }, legs(3600, 7200), new Date(departureAt.getTime() + 3 * HOUR))).toThrow(
      expect.objectContaining({ response: expect.objectContaining({ code: "TRIP_STOP_TIMES_INVALID" }) }),
    );
  });
});

describe("keepsLegacyTimes — đổi lịch chuyến tạo trước bước 5 phút", () => {
  it("chuyến lẻ phút không dời giờ đi → giữ cách cũ; dời giờ hoặc chuyến đã theo bước 5 phút → làm tròn", () => {
    const legacy = { departureAt: at(32), arrivalAt: at(128) };
    expect(keepsLegacyTimes(legacy, at(32))).toBe(true);
    expect(keepsLegacyTimes(legacy, at(40))).toBe(false);
    expect(keepsLegacyTimes({ departureAt: at(30), arrivalAt: at(130) }, at(30))).toBe(false);
  });
});
