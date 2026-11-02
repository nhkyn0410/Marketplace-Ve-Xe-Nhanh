"use client";

import { useParams } from "next/navigation";

import { AuditLogDetail } from "../../../components/audit/audit-log-detail";

export default function AuditLogDetailPage() {
  const { logId } = useParams<{ logId: string }>();
  return <AuditLogDetail key={logId} logId={logId} />;
}
