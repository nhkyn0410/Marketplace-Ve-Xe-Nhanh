package com.vexenhanh.journey_notification

import java.text.ParsePosition
import java.text.SimpleDateFormat
import java.util.Locale
import java.util.TimeZone
import java.util.UUID

/** Presentation state only: never writes booking, ticket or trip state. */
internal data class JourneySnapshot(
    val sessionId: String,
    val bookingId: String,
    val revision: Int,
    val stage: String,
    val routeLabel: String,
    val provinceName: String,
    val etaAt: Long,
    val progress: Int,
    val expiresAt: Long,
    val ended: Boolean,
) {
    enum class UpdateAction { IGNORE, CLEAR, SHOW }

    /** Enrollment is explicit so late pushes cannot switch account or revive a dismissed session. */
    fun action(enabled: Boolean, closed: Boolean, enrolledSession: String?, lastRevision: Int, now: Long): UpdateAction {
        if (!enabled || closed || enrolledSession != sessionId || revision <= lastRevision) return UpdateAction.IGNORE
        return if (expiresAt <= now || stage == "stopped") UpdateAction.CLEAR else UpdateAction.SHOW
    }

    companion object {
        fun from(data: Map<*, *>): JourneySnapshot {
            require(data["type"] == "journey_demo" && data["schemaVersion"] == 1)
            fun id(key: String): String {
                val value = data[key] as? String ?: error("Missing $key")
                require(UUID.fromString(value).toString().equals(value, ignoreCase = true))
                return value
            }
            fun integer(key: String, range: IntRange): Int {
                val value = data[key] as? Number ?: error("Missing $key")
                require(value.toDouble() == value.toInt().toDouble())
                return value.toInt().also { require(it in range) }
            }
            fun label(key: String): String = (data[key] as? String ?: "")
                .also { require(it.isNotBlank() && it.length <= 300) }
                .replace(Regex("[\\r\\n]+"), " ")
            val stage = data["stage"] as? String ?: error("Missing stage")
            require(stage in setOf("approaching", "travelling", "arrived", "stopped"))
            val ended = data["ended"] as? Boolean ?: error("Missing ended")
            require(ended == (stage == "stopped"))
            parseTime(data["updatedAt"])
            return JourneySnapshot(
                id("sessionId"), id("bookingId"), integer("revision", 0..7),
                stage, label("routeLabel"), label("provinceName"), parseTime(data["etaAt"]),
                integer("progress", 0..1000), parseTime(data["expiresAt"]), ended,
            )
        }

        private fun parseTime(value: Any?): Long {
            val text = value as? String ?: error("Missing timestamp")
            for (pattern in listOf("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", "yyyy-MM-dd'T'HH:mm:ss'Z'")) {
                val formatter = SimpleDateFormat(pattern, Locale.US)
                formatter.timeZone = TimeZone.getTimeZone("UTC")
                formatter.isLenient = false
                val position = ParsePosition(0)
                val parsed = formatter.parse(text, position)
                if (parsed != null && position.index == text.length) return parsed.time
            }
            error("Invalid UTC timestamp")
        }
    }

    fun title(now: Long): String {
        if (stage == "arrived") return "Đã đến nơi"
        val minutes = ((etaAt - now).coerceAtLeast(0) + 59_999) / 60_000
        if (minutes == 0L) return if (stage == "approaching") "Xe sắp đến" else "Sắp đến nơi"
        val duration = if (minutes >= 60) "${minutes / 60} giờ ${minutes % 60} phút" else "$minutes phút"
        return if (stage == "approaching") "Xe đến sau $duration" else "Còn $duration"
    }

    fun content(): String = listOf(routeLabel, provinceName.takeIf { it.isNotBlank() }?.let { "Đang qua $it" })
        .filterNotNull().filter { it.isNotBlank() }.joinToString(" · ")
}
