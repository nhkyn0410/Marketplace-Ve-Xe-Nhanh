"use client";

import React from "react";
import { LookupFormStep } from "./lookup-form-step";
import { LookupInstructionsCard } from "./lookup-instructions-card";
import type { TicketLookupInitData } from "../../../lib/data/types";
import { PassengerTopBar } from "../../passenger-topbar";

/**
 * Thuộc tính của LookupView
 */
export interface LookupViewProps {
  readonly formData?: TicketLookupInitData;
}

/**
 * Giao diện chính Tra cứu vé không đăng nhập (SCR-PSG-27 & SCR-PSG-28)
 */
export const LookupView: React.FC<LookupViewProps> = ({
  formData
}) => {

  return (
    <>
      <PassengerTopBar breadcrumbs={[{ label: "Trang chủ", href: "/" }, { label: "Tra cứu vé" }]} />
      <div className="mx-auto w-full max-w-[1200px] space-y-6 px-4 py-6 sm:px-6 sm:py-8 lg:px-14">

      {/* Lưới 2 cột chính: Trái là Form B1/B2, Phải là Hướng dẫn */}
      <div className="grid grid-cols-1 lg:grid-cols-12 gap-6 items-start">
        {/* Cột trái: 7 cột */}
        <div className="lg:col-span-6">
          <LookupFormStep initialData={formData} />
        </div>

        {/* Cột phải: 5 cột */}
        <div className="lg:col-span-6">
          <LookupInstructionsCard />
        </div>
      </div>
    </div>
    </>
  );
};
