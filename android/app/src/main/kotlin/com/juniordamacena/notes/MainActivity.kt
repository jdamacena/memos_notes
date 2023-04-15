package com.juniordamacena.notes

import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
    protected override fun onPause() {
        super.onPause()

        // Workaround for problem that the app preview on the recent apps
        // screen on Motorola phone shows flickering and a black screen, more details here:
        // https://github.com/flutter/flutter/issues/66212
        try {
            java.lang.Thread.sleep(200)
        } catch (e: InterruptedException) {
            e.printStackTrace()
        }
    }
}
