package com.vexenhanh.journey_notification

import org.junit.Assert.assertEquals
import org.junit.Assert.assertThrows
import org.junit.Test

class JourneySnapshotTest {
    private fun payload() = mutableMapOf<String, Any>(
        "type" to "journey_demo", "schemaVersion" to 1,
        "sessionId" to "73308bbf-8c33-4dc8-888f-14280bb5d2ed",
        "bookingId" to "32fe34ae-4a89-477c-babe-b403a82a7215",
        "revision" to 2, "stage" to "travelling", "progress" to 680,
        "routeLabel" to "TP. HCM → Đà Lạt", "provinceName" to "Đồng Nai",
        "etaAt" to "2026-11-03T07:30:00.000Z",
        "updatedAt" to "2026-11-03T05:15:00.000Z",
        "expiresAt" to "2026-11-03T07:31:00.000Z", "ended" to false,
    )

    @Test fun contentShowsCurrentProvinceAndAbsoluteEtaProducesRemainingTime() {
        val snapshot = JourneySnapshot.from(payload())
        assertEquals("TP. HCM → Đà Lạt · Đang qua Đồng Nai", snapshot.content())
        assertEquals("Còn 2 giờ 15 phút", snapshot.title(snapshot.etaAt - 135 * 60_000))
        assertEquals("Sắp đến nơi", snapshot.title(snapshot.etaAt + 60_000))
    }

    @Test fun malformedSnapshotCannotReachRenderer() {
        for (keyValue in listOf("progress" to 1001, "progress" to 3.5, "sessionId" to "bad", "stage" to "unknown", "etaAt" to "2026-99-03T07:30:00.000Z")) {
            assertThrows(Exception::class.java) { JourneySnapshot.from(payload().apply { put(keyValue.first, keyValue.second) }) }
        }
    }

    @Test fun longRouteInServerContractIsAcceptedAndLineBreaksAreFlattened() {
        val route = "A".repeat(180) + "\nĐà Lạt"
        val snapshot = JourneySnapshot.from(payload().apply { put("routeLabel", route) })
        assertEquals(route.replace('\n', ' '), snapshot.routeLabel)
    }

    @Test fun endedFlagMustAgreeWithTerminalStage() {
        assertThrows(IllegalArgumentException::class.java) {
            JourneySnapshot.from(payload().apply { put("ended", true) })
        }
        val arrived = JourneySnapshot.from(payload().apply { put("stage", "arrived"); put("progress", 1000) })
        assertEquals("Đã đến nơi", arrived.title(arrived.etaAt))
        val stopped = JourneySnapshot.from(payload().apply { put("stage", "stopped"); put("ended", true) })
        assertEquals(JourneySnapshot.UpdateAction.CLEAR, stopped.action(true, false, stopped.sessionId, 1, stopped.etaAt))
    }

    @Test fun latePushesCannotReviveDismissedDisabledOrReplacedSession() {
        val snapshot = JourneySnapshot.from(payload())
        val now = snapshot.etaAt - 60_000
        fun action(enabled: Boolean = true, closed: Boolean = false, session: String? = snapshot.sessionId, revision: Int = 1) =
            snapshot.action(enabled, closed, session, revision, now)
        assertEquals(JourneySnapshot.UpdateAction.SHOW, action())
        assertEquals(JourneySnapshot.UpdateAction.IGNORE, action(enabled = false))
        assertEquals(JourneySnapshot.UpdateAction.IGNORE, action(closed = true))
        assertEquals(JourneySnapshot.UpdateAction.IGNORE, action(session = "other-session"))
        assertEquals(JourneySnapshot.UpdateAction.IGNORE, action(session = null))
        assertEquals(JourneySnapshot.UpdateAction.IGNORE, action(revision = 2))
        assertEquals(JourneySnapshot.UpdateAction.IGNORE, action(revision = 3))
        assertEquals(JourneySnapshot.UpdateAction.CLEAR, snapshot.action(true, false, snapshot.sessionId, 1, snapshot.expiresAt))
    }
}
