package com.mapspeople.mapsindoors.core

import com.mapspeople.mapsindoors.core.*
import android.content.Context
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class MapViewFactory(private val binaryMessenger: BinaryMessenger, private val lifecycleProvider: MapsindoorsPlugin.LifecycleProvider, private val readyListener: OnMapViewReady?) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    override fun create(context: Context?, viewId: Int, args: Any?): PlatformView {
        return MapView(context!!, binaryMessenger, args as HashMap<*,*>?, lifecycleProvider).also {
            readyListener?.ready(it)
        }
    }

    public fun interface OnMapViewReady {
        fun ready(view: MapView)
    }
}