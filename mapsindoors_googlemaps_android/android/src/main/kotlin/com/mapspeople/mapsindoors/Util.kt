package com.mapspeople.mapsindoors

import java.lang.reflect.Type

import android.content.Context
import android.graphics.Typeface

import com.google.android.gms.maps.GoogleMap
import com.google.android.gms.maps.MapView
import com.google.android.gms.maps.model.LatLngBounds
import com.google.android.gms.maps.model.CameraPosition as GMCameraPosition
import com.google.android.gms.maps.CameraUpdate as GMCameraUpdate
import com.google.android.gms.maps.CameraUpdateFactory
import com.google.gson.reflect.TypeToken

import com.mapsindoors.core.MPFloorSelectorInterface
import com.mapsindoors.core.MPPoint
import com.mapsindoors.googlemaps.MPMapConfig
import com.mapsindoors.googlemaps.converters.toLatLng

import com.mapspeople.mapsindoors.core.models.*
import com.mapspeople.mapsindoors.core.models.CameraUpdateMode.*


inline fun <reified T> type(): Type = object: TypeToken<T>() {}.type

fun GMCameraPosition.toCameraPosition() : CameraPosition {
    return CameraPosition(
        zoom = zoom,
        tilt = tilt,
        bearing = bearing,
        target = MPPoint(target.latitude, target.longitude)
    )
}

fun CameraPosition.toGMCameraPosition() : GMCameraPosition {
    return GMCameraPosition.builder().bearing(bearing!!).target(target!!.latLng.toLatLng()).tilt(tilt!!).zoom(zoom!!).build()
}


fun CameraUpdate.toGMCameraUpdate() : GMCameraUpdate = when (mode) {
    FROMPOINT -> CameraUpdateFactory.newLatLng(point!!.latLng.toLatLng())

    FROMBOUNDS -> if (width != null && height != null) {
            CameraUpdateFactory.newLatLngBounds(LatLngBounds(bounds!!.southWest.latLng.toLatLng(), bounds!!.northEast.latLng.toLatLng()), width, height, padding!!)
        } else {
            CameraUpdateFactory.newLatLngBounds(LatLngBounds(bounds!!.southWest.latLng.toLatLng(), bounds!!.northEast.latLng.toLatLng()), padding!!)
        }

    ZOOMBY -> CameraUpdateFactory.zoomBy(zoom!!)

    ZOOMTO -> CameraUpdateFactory.zoomTo(zoom!!)

    FROMCAMERAPOSITION -> CameraUpdateFactory.newCameraPosition(position!!.toGMCameraPosition())

}

fun MapConfig.makeMPMapConfig(context: Context, map: GoogleMap, mapView: MapView, apiKey: String, floorSelector: MPFloorSelectorInterface?) : MPMapConfig {
    val builder = MPMapConfig.Builder(context, map, apiKey, mapView, useDefaultMapsIndoorsStyle)

    typeface?.let {
        val tf = Typeface.create(it, Typeface.NORMAL)
        builder.setMapLabelFont(tf, color!!, showHalo!!)
    }
    showFloorSelector?.let {
        builder.setShowFloorSelector(it)
    }
    textSize?.let {
        builder.setMapLabelTextSize(it.toInt())
    }
    showInfoWindowOnLocationClicked?.let {
        builder.setShowInfoWindowOnLocationClicked(it)
    }
    showUserPosition?.let {
        builder.setShowUserPosition(it)
    }
    tileFadeInEnabled?.let {
        builder.setTileFadeInEnabled(it)
    }
    floorSelector?.let {
        builder.setFloorSelector(it)
    }
    return builder.build()
}