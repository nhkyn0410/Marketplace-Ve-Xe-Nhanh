import { afterEach, describe, expect, it, vi } from "vitest";

import { isDemoMode } from "./demo-mode";

describe("isDemoMode", () => {
  afterEach(() => {
    vi.unstubAllEnvs();
  });

  it("chỉ bật khi NEXT_PUBLIC_DEMO_MODE đúng là `true`", () => {
    vi.stubEnv("NEXT_PUBLIC_DEMO_MODE", "true");
    expect(isDemoMode()).toBe(true);
    vi.stubEnv("NEXT_PUBLIC_DEMO_MODE", " true ");
    expect(isDemoMode()).toBe(true);
    for (const value of ["", "false", "1", "TRUE"]) {
      vi.stubEnv("NEXT_PUBLIC_DEMO_MODE", value);
      expect(isDemoMode()).toBe(false);
    }
  });
});
