part of '../mapsindoors.dart';

class MPDirectionsService {
  static const String travelModeTransit = "transit";
  static const String travelModeDriving = "driving";
  static const String travelModeWalking = "walking";
  static const String travelModeBicycling = "bicycling";

  /// Creates a [MPDirectionsService] object than can be queried for directions between different [MPPoint]s
  MPDirectionsService() {
    _create();
  }

  void _create() {
    DirectionsServicePlatform.instance.create();
  }

  /// Add an avoided WayType, these are based on [OSM highways](https://wiki.openstreetmap.org/wiki/Key:highway)
  ///
  /// Avoided WayTypes are downprioritized, but if no path is available that does not utilize them, then they will be used in the route.
  ///
  /// Supported types are defined in [MPHighway]
  Future<void> addAvoidWayType(String avoidWayType) =>
      DirectionsServicePlatform.instance.addAvoidWayType(avoidWayType);

  /// Add an excluded WayType, these are based on [OSM highways](https://wiki.openstreetmap.org/wiki/Key:highway)
  ///
  /// Excluded WayTypes are completely excluded, if no path is available that does not utilize them, then no route will be found.
  ///
  /// Supported types are defined in [MPHighway]
  Future<void> addExcludeWayType(String avoidWayType) =>
      DirectionsServicePlatform.instance.addExcludeWayType(avoidWayType);

  /// Clears all added avoidWayTypes
  @Deprecated("Deprecated since 4.3.0. Use clearAvoidWayType() instead")
  Future<void> clearWayType() =>
      DirectionsServicePlatform.instance.clearAvoidWayType();

  /// Clears all added avoidWayTypes
  Future<void> clearAvoidWayType() =>
      DirectionsServicePlatform.instance.clearAvoidWayType();

  /// Clears all added excludeWayTypes
  Future<void> clearExcludeWayType() =>
      DirectionsServicePlatform.instance.clearExcludeWayType();

  /// Sets whether routes should use departure time or arrival time when using the transit travel mode
  Future<void> setIsDeparture(bool isDeparture) =>
      DirectionsServicePlatform.instance.setIsDeparture(isDeparture);

  /// Queries the routing network to generate a route from the [origin] to the [destination].
  ///
  /// Can be supplied with a list of [stops] to visit on the way, and whether to [optimize] the order of the stops.
  ///
  /// Can throw an [MPError] if unable to generate the route.
  Future<MPRoute> getRoute(
      {required MPPoint origin,
      required MPPoint destination,
      List<MPPoint>? stops,
      bool? optimize = false}) {
    return DirectionsServicePlatform.instance.getRoute(
        MPPoint.withCoordinates(
            longitude: origin.longitude,
            latitude: origin.latitude,
            floorIndex: origin.floorIndex != MPPoint.noFloorIndex
                ? origin.floorIndex
                : 0),
        MPPoint.withCoordinates(
            longitude: destination.longitude,
            latitude: destination.latitude,
            floorIndex: destination.floorIndex != MPPoint.noFloorIndex
                ? destination.floorIndex
                : 0),
        stops
            ?.map((it) => MPPoint.withCoordinates(
                longitude: it.longitude,
                latitude: it.latitude,
                floorIndex:
                    it.floorIndex != MPPoint.noFloorIndex ? it.floorIndex : 0))
            .toList(),
        optimize);
  }

  /// defines the travel mode for routes, can be one of the following:
  ///
  /// walking
  ///
  /// bicycling
  ///
  /// driving
  ///
  /// transit
  Future<void> setTravelMode(String travelMode) =>
      DirectionsServicePlatform.instance.setTravelMode(travelMode);

  /// sets the wanted arrival/departure time for routes generated with this [MPDirectionsService],
  /// this setting is used in conjunction with [setIsDeparture] and [setTravelMode]
  Future<void> setTime(int time) =>
      DirectionsServicePlatform.instance.setTime(time);
}
