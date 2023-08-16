package com.mapspeople.mapsindoors.core.models

import com.google.gson.annotations.SerializedName
import com.mapsindoors.core.MPPoint

data class CameraUpdate(
    @SerializedName("mode") private val modeString : String,
    @SerializedName("point") val point : MPPoint?,
    @SerializedName("bounds") val bounds : Bounds?,
    @SerializedName("padding") val padding : Int?,
    @SerializedName("width") val width : Int?,
    @SerializedName("height") val height : Int?,
    @SerializedName("zoom") val zoom : Float?,
    @SerializedName("position") val position : CameraPosition?,
) {
    val mode : CameraUpdateMode
        get() {
            return CameraUpdateMode.fromString(modeString)
        }
}

enum class CameraUpdateMode(val mode: String) {
    FROMPOINT("fromPoint"), FROMBOUNDS("fromBounds"), ZOOMBY("zoomBy"), ZOOMTO("zoomTo"), FROMCAMERAPOSITION("fromCameraPosition");

    companion object {
        fun fromString(value : String) : CameraUpdateMode {
            return when (value) {
                "fromPoint" -> FROMPOINT
                "fromBounds" -> FROMBOUNDS
                "zoomBy" -> ZOOMBY
                "zoomTo" -> ZOOMTO
                "fromCameraPosition" -> FROMCAMERAPOSITION
                else -> throw IllegalArgumentException()
            }
        }
    }
}