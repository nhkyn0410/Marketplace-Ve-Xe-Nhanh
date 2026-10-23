import type { Incident, IncidentPage, JourneyLogPage } from "@vexenhanh/types";
import { apiRequest } from "../auth/api-client";

/** Xem sự cố mới nhất của nhà xe. */
export function listIncidents(cursor?: string): Promise<IncidentPage> { return apiRequest(`/operator/incidents${cursor ? `?cursor=${cursor}` : ""}`); }
/** Xem nhật trình mới nhất của nhà xe. */
export function listJourneyLogs(cursor?: string): Promise<JourneyLogPage> { return apiRequest(`/operator/journey-logs${cursor ? `?cursor=${cursor}` : ""}`); }
/** Ghi kết quả xử lý một sự cố. */
export function resolveIncident(id: string, resolution: string): Promise<Incident> { return apiRequest(`/operator/incidents/${id}/resolution`, { method: "PUT", body: { resolution } }); }
/** Xin URL xem minh chứng sự cố có thời hạn. */
export function incidentEvidenceUrl(id: string, index: number): Promise<{ url: string; expiresAt: string }> { return apiRequest(`/operator/incidents/${id}/evidence/${index}`); }
