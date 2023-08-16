package com.mapspeople.mapsindoors

import android.content.Context
import com.mapspeople.mapsindoors.core.*
import com.mapspeople.mapsindoors.core.models.*
import com.mapsindoors.core.MPFloorSelectorInterface
import com.mapsindoors.googlemaps.MPMapConfig
import com.google.android.gms.maps.GoogleMap
import com.google.android.gms.maps.OnMapReadyCallback
import com.google.android.gms.maps.CameraUpdate as GMCameraUpdate
import com.google.android.gms.maps.GoogleMap.CancelableCallback
import com.google.android.gms.maps.MapView
import android.view.View

abstract class PlatformMapView(private val context: Context) : PlatformMapViewInterface, OnMapReadyCallback {
    private val mMap: MapView = MapView(context)
    private var mGoogleMap: GoogleMap? = null

    init {
        mMap.getMapAsync(this)
        mMap.onCreate(null)
    }

    override fun disposeMap() {
        mMap.onDestroy()
        mGoogleMap = null
    }

    override fun getMapView(): View {
        return mMap
    }

    override fun makeMPConfig(config: MapConfig?, floorSelectorInterface: MPFloorSelectorInterface) : MPMapConfig? {
        return config?.makeMPMapConfig(context, mGoogleMap!!, mMap, context.getString(R.string.google_maps_key), floorSelectorInterface);
    }

    override val currentCameraPosition: CameraPosition? get() {
        return mGoogleMap?.cameraPosition?.toCameraPosition()
    }

    override fun updateCamera(move: Boolean, update: CameraUpdate, duration: Int?, success: () -> Unit) {
        val cameraUpdate = update.toGMCameraUpdate()
        if (move) {
            mGoogleMap?.moveCamera(cameraUpdate)
            success()
        } else if (duration != null) {
            mGoogleMap?.animateCamera(cameraUpdate, duration, object :
                GoogleMap.CancelableCallback {
                override fun onCancel() = success()
                override fun onFinish() = success()
            })
        } else {
            mGoogleMap?.animateCamera(cameraUpdate)
            success()
        }
    }

    override fun onMapReady(p0: GoogleMap) {
        mGoogleMap = p0
        mMap.onStart()
        whenMapReady()
    }
}