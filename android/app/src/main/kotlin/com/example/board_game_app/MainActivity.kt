package com.example.board_game_app

import androidx.annotation.NonNull
import com.yandex.mapkit.MapKitFactory
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) { // Your preferred language. Not required, defaults to system language
        //MapKitFactory.setApiKey(BuildConfig.YANDEX_API_KEY)
        MapKitFactory.setApiKey("e1de6552-661d-4c7a-aba2-34461048cfe2")
        super.configureFlutterEngine(flutterEngine)
    }
}
//
//class MainActivity : FlutterActivity() {
//    @Override
//    fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine?) {
////    MapKitFactory.setLocale("YOUR_LOCALE");
//
//        super.configureFlutterEngine(flutterEngine)
//    }
//}