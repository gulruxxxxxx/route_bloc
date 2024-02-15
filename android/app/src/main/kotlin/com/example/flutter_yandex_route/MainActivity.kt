package com.example.flutter_yandex_route

import io.flutter.embedding.android.FlutterActivity
import com.yandex.mapkit.MapKitFactory
import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant;

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        MapKitFactory.setApiKey("a2beafbf-70cb-48b1-b9a6-cfe79aa2253a")
        super.configureFlutterEngine(flutterEngine)
    }
}
