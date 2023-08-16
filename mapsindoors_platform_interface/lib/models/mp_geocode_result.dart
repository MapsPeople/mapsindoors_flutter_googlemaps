part of 'package:mapsindoors_platform_interface/platform_library.dart';

/// GeoCode class to represent results from a reverse GeoCode.
class MPGeocodeResult {
  /// Get the [areas], that the [MPPoint] is inside
  final List<MPLocation> areas;

  /// Get the [rooms], that the [MPPoint] is inside
  final List<MPLocation> rooms;

  /// Get the [floors], that the [MPPoint] is inside
  final List<MPLocation> floors;

  /// Get the [buildings], that the [MPPoint] is inside
  final List<MPLocation> buildings;

  /// Get the [venues], that the [MPPoint] is inside
  final List<MPLocation> venues;

  /// Attempts to build a [MPFloor] from a JSON object, this method will decode the object if needed
  static MPGeocodeResult? fromJson(json) => json != null && json != "null" ? MPGeocodeResult._fromJson(json is String ? jsonDecode(json) : json) : null;

  static List<MPLocation> convert(dynamic data) {
    return convertMIList<MPLocation>(data, (p0) => MPLocation.fromJson(p0));
  }

  MPGeocodeResult._fromJson(data)
      : areas = convert(data["areas"]),
        rooms = convert(data["rooms"]),
        floors = convert(data["floors"]),
        buildings = convert(data["buildings"]),
        venues = convert(data["venues"]);
}
