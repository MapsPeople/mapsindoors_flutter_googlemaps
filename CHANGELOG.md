# Changelog

## 2.1.3

* Fixed issue with `MapsIndoorsWidget.readyListener` not being called on very initial load of MapsIndoors.

## 2.1.2

* Updated Mapsindoors SDKs
  * Android to 4.2.12
  * iOS to 4.2.14

## 2.1.1

* Fixed issue where `OnMapReadyListener` would not be invoked during the initial load on iOS.

## 2.1.0

* Updated Mapsindoors SDKs
  * Android to 4.2.10
  * iOS to 4.2.13
* Added `showRouteLegButtons` to `MPDirectionsRenderer`
* Added `setLabelOptions` to `MapsindoorsWidget`

## 2.0.1

* RETRACTED

## 2.0.0

* Moved from mapsindoors to allow for multiple map providers
* Changes to classes:
  * MapControl
    * MapControl has merged with the MapsIndoorsWidget, combining them into a single entity. the Widget will still be built in the build tree, and accepts a listener as a parameter to wait for the MapControl part to be initialized.
* MapsIndoors
  * Has been split up into functions on the namespace to align better with dart language standards. Some methods have changed naming to avoid collision with popular method and parameter naming (eg. MapsIndoors.load() is now loadMapsIndoors())
* Changes to the Widget
  * The MapsIndoorsWidget has been changed to be a UniqueWidget, this is to ensure that the underlying MapsIndoors in the platform code can function normally.
  