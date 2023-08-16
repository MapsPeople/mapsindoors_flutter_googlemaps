package com.mapspeople.mapsindoors.core

import com.mapspeople.mapsindoors.core.models.*
import com.mapsindoors.core.MPFloorSelectorInterface
import com.mapsindoors.core.MPIMapConfig
import android.view.View

interface PlatformMapViewInterface {
    val currentCameraPosition: CameraPosition?
    fun disposeMap()
    fun getMapView() : View
    fun makeMPConfig(config: MapConfig?, floorSelectorInterface: MPFloorSelectorInterface) : MPIMapConfig?
    fun updateCamera(move: Boolean, update: CameraUpdate, duration: Int?, success: () -> Unit)
    fun whenMapReady()
}