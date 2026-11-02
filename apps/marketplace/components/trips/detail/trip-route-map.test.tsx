import type { ReactNode } from "react";
import { renderToStaticMarkup } from "react-dom/server";
import { beforeEach, describe, expect, it, vi } from "vitest";

import type { TripTimelineStop } from "../../../lib/data/types";
import { TripRouteMap } from "./trip-route-map";

const mocks = vi.hoisted(() => ({ mapKey: "test-maptiles-key" as string | null, map: vi.fn(), marker: vi.fn() }));

vi.mock("@vexenhanh/ui/lib/map-config", () => ({ get GOONG_MAPTILES_KEY() { return mocks.mapKey; } }));
vi.mock("@vexenhanh/ui/components/map", () => ({
  MapView: (props: { label: string; children: ReactNode }) => {
    mocks.map(props);
    return <div aria-label={props.label}>{props.children}</div>;
  },
  MapMarker: (props: { children: ReactNode }) => {
    mocks.marker(props);
    return props.children;
  }
}));

const stop: TripTimelineStop = {
  time: "08:00", stationName: "Bến xe Trung tâm Đà Nẵng", address: "Đà Nẵng",
  stationType: "bus_station", stationTypeLabel: "Bến xe", lat: 16.0622, lng: 108.1717
};

describe("bản đồ điểm dừng trên chi tiết chuyến", () => {
  beforeEach(() => {
    mocks.mapKey = "test-maptiles-key";
    mocks.map.mockClear();
    mocks.marker.mockClear();
  });

  it("dùng bản đồ Goong với Maptiles key và tọa độ thực của các điểm dừng", () => {
    const restStop: TripTimelineStop = { ...stop, stationName: "Trạm dừng nghỉ", lat: 18.9786, lng: 105.5982, isRestStop: true };
    const html = renderToStaticMarkup(<TripRouteMap timeline={[stop, restStop]} />);

    expect(mocks.map).toHaveBeenCalledWith(expect.objectContaining({
      mapKey: "test-maptiles-key",
      fitPoints: [{ latitude: 16.0622, longitude: 108.1717 }, { latitude: 18.9786, longitude: 105.5982 }]
    }));
    expect(mocks.marker).toHaveBeenCalledTimes(2);
    expect(mocks.marker).toHaveBeenNthCalledWith(1, expect.objectContaining({ point: { latitude: 16.0622, longitude: 108.1717 } }));
    expect(html).toContain("Điểm 1: Bến xe Trung tâm Đà Nẵng");
    expect(html).toContain("Điểm 2: Trạm dừng nghỉ");
    expect(html).not.toContain("<svg");
  });

  it("không có key thì không tải bản đồ, vẫn hiện danh sách điểm dừng", () => {
    mocks.mapKey = null;
    const html = renderToStaticMarkup(<TripRouteMap timeline={[stop]} />);

    expect(mocks.map).not.toHaveBeenCalled();
    expect(html).toContain(stop.stationName);
    expect(html).toContain("16.06220, 108.17170");
  });

  it("bỏ tọa độ thiếu, không hữu hạn hoặc ngoài khoảng hợp lệ trước khi đặt ghim", () => {
    renderToStaticMarkup(<TripRouteMap timeline={[
      { ...stop, lat: undefined }, { ...stop, lng: undefined }, { ...stop, lat: NaN },
      { ...stop, lng: Infinity }, { ...stop, lat: 91 }, { ...stop, lng: 181 }, stop
    ]} />);

    expect(mocks.map).toHaveBeenCalledWith(expect.objectContaining({ fitPoints: [{ latitude: 16.0622, longitude: 108.1717 }] }));
    expect(mocks.marker).toHaveBeenCalledTimes(1);
  });

  it("không tạo bản đồ khi không có điểm nào có tọa độ hợp lệ", () => {
    expect(renderToStaticMarkup(<TripRouteMap timeline={[]} />)).toBe("");
    expect(renderToStaticMarkup(<TripRouteMap timeline={[{ ...stop, lat: undefined }]} />)).toBe("");
    expect(mocks.map).not.toHaveBeenCalled();
  });
});
