package com.example.flutter_helloworld

import android.os.Build
import android.os.Bundle
import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        //make transparent status bar
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            window.statusBarColor = 0x00000000
        }
    }

    public override fun onResume() {
        super.onResume()
        window.clearFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN)
    }
}
