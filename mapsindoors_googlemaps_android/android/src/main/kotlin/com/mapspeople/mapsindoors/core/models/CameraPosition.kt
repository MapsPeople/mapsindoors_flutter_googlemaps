package com.mapspeople.mapsindoors.core.models

import com.google.gson.annotations.SerializedName
import com.mapsindoors.core.MPPoint

data class CameraPosition(
    @SerializedName("zoom") val zoom: Float?,
    @SerializedName("tilt") val tilt: Float?,
    @SerializedName("bearing") val bearing: Float?,
    @SerializedName("target") val target: MPPoint?
)