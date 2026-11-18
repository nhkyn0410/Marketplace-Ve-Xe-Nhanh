package com.vexenhanh.journey_notification

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.drawable.Icon
import android.net.Uri
import android.os.Build
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry
import java.util.UUID

/** No Activity is needed to update: FlutterFire registers this plugin in its background engine. */
class JourneyNotificationPlugin : FlutterPlugin, MethodChannel.MethodCallHandler, ActivityAware,
    PluginRegistry.NewIntentListener {
    private lateinit var context: Context
    private lateinit var channel: MethodChannel
    private var activityBinding: ActivityPluginBinding? = null

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        context = binding.applicationContext
        channel = MethodChannel(binding.binaryMessenger, "vexenhanh/journey_notification")
        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        try {
            synchronized(JourneyNotificationStore.lock) {
                val store = JourneyNotificationStore(context)
                when (call.method) {
                    "setEnabled" -> {
                        val enabled = call.arguments as? Boolean ?: error("Expected enabled flag")
                        store.preferences.edit().putBoolean("enabled", enabled).commit()
                        if (!enabled) store.clear()
                        result.success(null)
                    }
                    "startSession" -> {
                        val id = call.arguments as? String ?: error("Expected session id")
                        require(UUID.fromString(id).toString().equals(id, ignoreCase = true))
                        if (store.preferences.getBoolean("enabled", false)) {
                            store.manager.cancel(JourneyNotificationStore.ID)
                            store.preferences.edit().putString("session", id).putInt("revision", -1)
                                .putBoolean("closed", false).remove("openedBooking").commit()
                        }
                        result.success(null)
                    }
                    "update" -> {
                        val snapshot = JourneySnapshot.from(call.arguments as? Map<*, *> ?: error("Expected snapshot"))
                        store.update(snapshot)
                        result.success(null)
                    }
                    "clear" -> {
                        store.clear()
                        result.success(null)
                    }
                    "consumeOpenedBooking" -> {
                        val id = store.preferences.getString("openedBooking", null)
                        store.preferences.edit().remove("openedBooking").commit()
                        result.success(id)
                    }
                    else -> result.notImplemented()
                }
            }
        } catch (_: IllegalArgumentException) {
            result.error("INVALID_JOURNEY_SNAPSHOT", "Dữ liệu hành trình không hợp lệ.", null)
        } catch (_: IllegalStateException) {
            result.error("INVALID_JOURNEY_SNAPSHOT", "Dữ liệu hành trình không hợp lệ.", null)
        } catch (_: SecurityException) {
            result.error("NOTIFICATION_PERMISSION_REQUIRED", "Chưa có quyền thông báo.", null)
        }
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activityBinding = binding
        binding.addOnNewIntentListener(this)
        captureBooking(binding.activity.intent)
    }
    override fun onDetachedFromActivity() {
        activityBinding?.removeOnNewIntentListener(this)
        activityBinding = null
    }
    override fun onDetachedFromActivityForConfigChanges() = onDetachedFromActivity()
    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) = onAttachedToActivity(binding)
    override fun onNewIntent(intent: Intent): Boolean = captureBooking(intent)

    private fun captureBooking(intent: Intent): Boolean {
        val id = intent.getStringExtra(JourneyNotificationStore.BOOKING_EXTRA) ?: return false
        val session = intent.getStringExtra(JourneyNotificationStore.SESSION_EXTRA) ?: return false
        return synchronized(JourneyNotificationStore.lock) {
            val store = JourneyNotificationStore(context)
            if (!store.preferences.getBoolean("enabled", false) || store.preferences.getString("session", null) != session) return@synchronized false
            if (runCatching { UUID.fromString(id) }.isFailure) return@synchronized false
            store.preferences.edit().putString("openedBooking", id).commit()
            intent.removeExtra(JourneyNotificationStore.BOOKING_EXTRA)
            intent.removeExtra(JourneyNotificationStore.SESSION_EXTRA)
            true
        }
    }
}

internal class JourneyNotificationStore(private val context: Context) {
    val preferences = context.getSharedPreferences("vxn_journey_notification", Context.MODE_PRIVATE)
    val manager: NotificationManager = context.getSystemService(NotificationManager::class.java)

    fun clear() {
        preferences.edit().putBoolean("closed", true).remove("openedBooking").commit()
        manager.cancel(ID)
    }

    fun update(snapshot: JourneySnapshot) {
        val now = System.currentTimeMillis()
        when (snapshot.action(
            preferences.getBoolean("enabled", false), preferences.getBoolean("closed", true),
            preferences.getString("session", null), preferences.getInt("revision", -1), now,
        )) {
            JourneySnapshot.UpdateAction.IGNORE -> return
            JourneySnapshot.UpdateAction.CLEAR -> { clear(); return }
            JourneySnapshot.UpdateAction.SHOW -> Unit
        }
        if (Build.VERSION.SDK_INT >= 24 && !manager.areNotificationsEnabled()) return
        if (Build.VERSION.SDK_INT >= 26) {
            manager.createNotificationChannel(NotificationChannel(CHANNEL, "Hành trình đang theo dõi", NotificationManager.IMPORTANCE_DEFAULT).apply {
                description = "Tiến độ hành trình mô phỏng đang được bạn theo dõi"
                setSound(null, null)
                enableVibration(false)
            })
        }
        val launch = context.packageManager.getLaunchIntentForPackage(context.packageName) ?: return
        launch.addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP or Intent.FLAG_ACTIVITY_CLEAR_TOP)
            .putExtra(BOOKING_EXTRA, snapshot.bookingId).putExtra(SESSION_EXTRA, snapshot.sessionId)
        val contentIntent = PendingIntent.getActivity(context, ID, launch, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
        val dismiss = PendingIntent.getBroadcast(context, ID, Intent(context, JourneyDismissReceiver::class.java)
            .setData(Uri.parse("vxn-journey-dismiss:${snapshot.sessionId}"))
            .putExtra(SESSION_EXTRA, snapshot.sessionId), PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
        val builder = if (Build.VERSION.SDK_INT >= 26) Notification.Builder(context, CHANNEL) else Notification.Builder(context)
        builder.setSmallIcon(R.drawable.journey_mark_monochrome)
            .setLargeIcon(brandBitmap()).setColor(Color.rgb(43, 126, 173))
            .setContentTitle(snapshot.title(now)).setContentText(snapshot.content())
            .setSubText("Mô phỏng").setContentIntent(contentIntent).setDeleteIntent(dismiss)
            .setCategory(Notification.CATEGORY_NAVIGATION).setOnlyAlertOnce(true)
            .setShowWhen(false).setOngoing(snapshot.stage != "arrived").setAutoCancel(false)
            .setVisibility(Notification.VISIBILITY_PRIVATE)
        if (Build.VERSION.SDK_INT >= 26) builder.setTimeoutAfter(
            minOf(snapshot.expiresAt - now, 120_000L),
        )
        if (Build.VERSION.SDK_INT >= 36) {
            builder.setStyle(Notification.ProgressStyle().setStyledByProgress(false)
                .setProgress(snapshot.progress)
                .setProgressSegments(listOf(Notification.ProgressStyle.Segment(1000).setColor(Color.rgb(43, 126, 173))))
                .setProgressPoints(listOf(333, 667, 1000).map { Notification.ProgressStyle.Point(it).setId(it).setColor(Color.rgb(43, 126, 173)) })
                .setProgressTrackerIcon(Icon.createWithResource(context, R.drawable.journey_bus)))
            // Promoted-ongoing request was added after base API 36; keep API 36.0 compatibility.
            runCatching { Notification.Builder::class.java.getMethod("setRequestPromotedOngoing", Boolean::class.javaPrimitiveType).invoke(builder, snapshot.stage != "arrived") }
        } else builder.setProgress(1000, snapshot.progress, false)
        manager.notify(ID, builder.build())
        preferences.edit().putInt("revision", snapshot.revision).putBoolean("closed", snapshot.ended).commit()
    }

    private fun brandBitmap(): Bitmap {
        val drawable = context.getDrawable(R.drawable.journey_mark)!!
        return Bitmap.createBitmap(96, 96, Bitmap.Config.ARGB_8888).also {
            val canvas = Canvas(it)
            drawable.setBounds(8, 17, 88, 79)
            drawable.draw(canvas)
        }
    }

    companion object {
        val lock = Any()
        const val ID = 7314
        const val CHANNEL = "vxn_journey_demo"
        const val BOOKING_EXTRA = "vxn_journey_booking"
        const val SESSION_EXTRA = "vxn_journey_session"
    }
}

class JourneyDismissReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        synchronized(JourneyNotificationStore.lock) {
            val store = JourneyNotificationStore(context)
            if (store.preferences.getString("session", null) == intent.getStringExtra(JourneyNotificationStore.SESSION_EXTRA)) store.clear()
        }
    }
}
