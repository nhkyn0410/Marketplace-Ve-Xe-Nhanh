import { describe, expect, it } from "vitest";
import { planStopTimes, routeArrival } from "./trip.service";

const MINUTE = 60_000;
const HOUR = 60 * MINUTE;
const departureAt = new Date("2031-01-01T00:00:00Z");
const at = (minutes: number) => new Date(departureAt.getTime() + minutes * MINUTE);
const legs = (...seconds: number[]) => [null, ...seconds].map((durationSecondsFromPrevious) => ({ durationSecondsFromPrevious }));

describe("routeArrival — giờ đến theo thời gian chạy của tuyến", () => {
  it("cộng các chặng, làm tròn theo phút", () => {
    expect(routeArrival(departureAt, legs(3600, 7200))).toEqual(at(180));
    expect(routeArrival(departureAt, legs(3600, 1830))).toEqual(at(91));
    expect(routeArrival(departureAt, legs(3600, 1810))).toEqual(at(90));
  });

  it("tuyến chưa tới 1 phút vẫn đến sau giờ đi ít nhất 1 phút (CHECK giờ đến sau giờ đi)", () => {
    expect(routeArrival(departureAt, legs(0))).toEqual(at(1));
    expect(routeArrival(departureAt, legs(20))).toEqual(at(1));
  });
});

describe("planStopTimes — giờ từng điểm", () => {
  it("không gửi giờ từng điểm: theo thời gian từng chặng, điểm cuối đúng giờ đến", () => {
    const stops = legs(3600, 7200);
    expect(planStopTimes({ departureAt, stopTimes: null }, stops, routeArrival(departureAt, stops))).toEqual([at(0), at(60), at(180)]);
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
