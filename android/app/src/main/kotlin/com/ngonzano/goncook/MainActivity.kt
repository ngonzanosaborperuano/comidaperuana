package com.ngonzano.goncook

import android.os.Build
import android.provider.Settings
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import com.ngonzano.goncook.PigeonApi
import com.ngonzano.goncook.DeviceInfoApi

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        // Registrar implementación de la API de Pigeon
        PigeonApi.setUp(
            flutterEngine.dartExecutor.binaryMessenger, 
            DeviceInfoApiImpl(this)
        )
    }
}

// Implementar la interfaz generada por Pigeon
class DeviceInfoApiImpl(private val context: android.content.Context) : DeviceInfoApi {
    override fun getDeviceModel(): String {
        return Build.MODEL
    }
    
    override fun getOsVersion(): String {
        return Build.VERSION.RELEASE
    }
    
    override fun getDeviceId(): String {
        return Settings.Secure.getString(
            context.contentResolver,
            Settings.Secure.ANDROID_ID
        ) ?: "unknown"
    }
}
