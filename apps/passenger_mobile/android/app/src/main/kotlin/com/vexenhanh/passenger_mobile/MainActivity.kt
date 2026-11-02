package com.vexenhanh.passenger_mobile

import android.app.NotificationChannel
import android.app.NotificationManager
import android.os.Build
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        createNotificationChannels()
    }

    /** Kênh trùng tên với kênh máy chủ gửi (`push-notifier.ts`), để khách tắt riêng ưu đãi trong Cài đặt Android. */
    private fun createNotificationChannels() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return
        getSystemService(NotificationManager::class.java).createNotificationChannels(
            listOf(
                NotificationChannel("vxn_important", "Vé và chuyến đi", NotificationManager.IMPORTANCE_HIGH),
                NotificationChannel("vxn_offers", "Ưu đãi và tin tức", NotificationManager.IMPORTANCE_DEFAULT),
            ),
        )
    }
}
