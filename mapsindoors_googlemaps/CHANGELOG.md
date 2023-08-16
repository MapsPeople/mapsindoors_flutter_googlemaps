# Changelog

## 2.0.0

* Moved from [mapsindoors](https://pub.dev/packages/mapsindoors) to allow for multiple map providers
* Changes to classes:
  * MapControl
    * ``MapControl`` has merged with the ``MapsIndoorsWidget``, combining them into a single entity. the ``Widget`` will still be built in the build tree, and accepts a listener as a parameter to wait for the MapControl part to be initialized.
  * MapsIndoors
    * Has been split up into functions on the namespace to align better with dart language standards. Some methods have changed naming to avoid collision with popular method and parameter naming (eg. ``MapsIndoors.load()`` is now ``loadMapsIndoors()``)
* Changes to the Widget
  * The ``MapsIndoorsWidget`` has been changed to be a [``UniqueWidget``](https://api.flutter.dev/flutter/widgets/UniqueWidget-class.html), this is to ensure that the underlying MapsIndoors in the platform code can function normally.