package com.mapspeople.mapsindoors.core.models

import com.google.gson.annotations.SerializedName

data class MapConfig(
    @SerializedName("typeface") val typeface: String?,
    @SerializedName("color") val color: String?,
    @SerializedName("showHalo") val showHalo: Boolean?,
    @SerializedName("showFloorSelector") val showFloorSelector: Boolean?,
    @SerializedName("textSize") val textSize: Double?,
    @SerializedName("showInfoWindowOnLocationClicked") val showInfoWindowOnLocationClicked: Boolean?,
    @SerializedName("showUserPosition") val showUserPosition: Boolean?,
    @SerializedName("tileFadeInEnabled") val tileFadeInEnabled: Boolean?,
    @SerializedName("useDefaultMapsIndoorsStyle") val useDefaultMapsIndoorsStyle: Boolean,
)