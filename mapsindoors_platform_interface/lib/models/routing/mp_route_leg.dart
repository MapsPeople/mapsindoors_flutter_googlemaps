part of 'package:mapsindoors_platform_interface/platform_library.dart';

/// A leg of a [MPRoute] is defined as all steps between any context shifts (entering/exiting buildings, changing floors)
/// A leg is comprised of a list of [steps] as well as a [startLocation] and an [endLocation]
class MPRouteLeg extends MapsIndoorsObject {
  /// The start address of the leg
  final String? startAddress;

  /// The end address of the leg
  final String? endAddress;

  /// The start coordinate of the leg
  final MPRouteCoordinate? startLocation;

  /// The end coordinate of the lg
  final MPRouteCoordinate? endLocation;

  /// The [steps] the leg consists of
  final List<MPRouteStep>? steps;

  /// The distance of the leg
  final MPRouteProperty? distance;

  /// The expected time it takes to traverse
  final MPRouteProperty? duration;

  const MPRouteLeg._({this.startAddress, this.endAddress, this.startLocation, this.endLocation, this.steps, this.distance, this.duration});

  /// Converts the [MPRouteLeg] to a JSON representation that can be parsed by the MapsIndoors Platform SDK
  @override
  Map<String, dynamic> toJson() {
    var jsonMPRouteSteps = steps?.map((e) => e.toJson()).toList();
    return {
      "start_address": startAddress,
      "end_address": endAddress,
      "start_location": startLocation?.toJson(),
      "end_location": endLocation?.toJson(),
      "steps": jsonMPRouteSteps,
      "distance": distance?.toJson(),
      "duration": duration?.toJson()
    };
  }

  /// Attempts to build a [MPRouteLeg] from a JSON object, this method will decode the object if needed
  static MPRouteLeg? fromJson(json) => json != null && json != "null" ? MPRouteLeg._fromJson(json is String ? jsonDecode(json) : json) : null;

  static MPRouteLeg _fromJson(data) {
    final endAddress = data["end_address"];
    final startAddress = data["start_address"];
    final distance = (data["distance"] is num) ? MPRouteProperty.fromJson(data["distance"]) : MPRouteProperty.fromJson(data["distance"]);
    final duration = (data["duration"] is num) ? MPRouteProperty.fromJson(data["duration"]) : MPRouteProperty.fromJson(data["duration"]);
    final startLocation = MPRouteCoordinate.fromJson(data["start_location"]);
    final endLocation = MPRouteCoordinate.fromJson(data["end_location"]);
    final list = convertJsonArray(data["steps"]);
    final routeSteps = List<MPRouteStep?>.generate(list.length, (index) => MPRouteStep.fromJson(list[index]));
    routeSteps.removeWhere((element) => element == null);
    final steps = routeSteps.cast<MPRouteStep>();

    return MPRouteLeg._(startAddress: startAddress, endAddress: endAddress, startLocation: startLocation, endLocation: endLocation, steps: steps, distance: distance, duration: duration);
  }
}
