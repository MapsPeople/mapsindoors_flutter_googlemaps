part of 'package:mapsindoors_platform_interface/platform_library.dart';

/// A step of a [MPRoute], the step is usually contained in a [MPRouteLeg]
class MPRouteStep extends MapsIndoorsObject {
  /// The [distance] of the step
  final MPRouteProperty? distance;

  /// The estimated [duration] of the step
  final MPRouteProperty? duration;

  /// The origin of the step
  final MPRouteCoordinate? startLocation;

  /// The destination of the step
  final MPRouteCoordinate? endLocation;

  /// The coordinates the step is made up of
  final List<MPRouteCoordinate>? geometry;

  /// The type of [MPHighway] of the step
  final String? highway;

  /// Some [abutters] set on the step
  final String? abutters;

  /// The step [maneuver] embedded in HTML
  final String? htmlInstructions;

  /// The steps' [maneuver], eg. "Straight", "Turn lef"
  final String? maneuver;

  /// How the step is traversed
  final String? travelMode;

  /// A list of substeps if any
  final List<MPRouteStep>? steps;

  /// A list of modes it is possible to travel the step with (eg. a bike path can both be walked on, as well as biked on)
  final List<String>? availableTravelModes;

  const MPRouteStep._({this.distance, this.duration, this.startLocation, this.endLocation, this.geometry, this.highway, this.abutters, this.htmlInstructions, this.maneuver, this.travelMode, this.steps, this.availableTravelModes});

  /// Converts the [MPRouteStep] to a JSON representation that can be parsed by the MapsIndoors Platform SDK
  @override
  Map<String, dynamic> toJson() {
    var jsonRouteSteps = steps?.map((e) => e.toJson()).toList();
    var jsonGeometry = geometry?.map((e) => e.toJson()).toList();
    return {
      "distance": distance?.toJson(),
      "duration": duration?.toJson(),
      "start_location": startLocation?.toJson(),
      "end_location": endLocation?.toJson(),
      "geometry": jsonGeometry,
      "highway": highway,
      "abutters": abutters,
      "html_instructions": htmlInstructions,
      "maneuver": maneuver,
      "travel_mode": travelMode,
      "steps": jsonRouteSteps,
      "available_travel_modes": availableTravelModes
    };
  }

  /// Attempts to build a [MPRouteStep] from a JSON object, this method will decode the object if needed
  static MPRouteStep? fromJson(json) => json != null && json != "null" ? MPRouteStep._fromJson(json is String ? jsonDecode(json) : json) : null;

  static MPRouteStep _fromJson(data) {
    final distance = (data["distance"] is num) ? MPRouteProperty.fromJson(data["distance"]) : MPRouteProperty.fromJson(data["distance"]);
    final duration = (data["duration"] is num) ? MPRouteProperty.fromJson(data["duration"]) : MPRouteProperty.fromJson(data["duration"]);
    final startLocation = MPRouteCoordinate.fromJson(data["start_location"]);
    final endLocation = MPRouteCoordinate.fromJson(data["end_location"]);
    var highway;
    if (data["highway"] is String) {
      highway = data["highway"];
    } else if (data["highway"] != null) {
      highway = data["highway"]["value"];
    }
    final abutters = data["abutters"];
    final htmlInstructions = data["html_instructions"];
    final maneuver = data["maneuver"];
    final travelMode = data["travel_mode"];
    var availableTravelModes;
    if (data["available_travel_modes"] != null) {
      availableTravelModes = convertJsonArray<String>(data["available_travel_modes"]);
    }
    var steps;
    if (data["steps"] != null) {
      var jsonRouteSteps = convertJsonArray(data["steps"]);
      var routeSteps = List<MPRouteStep?>.generate(jsonRouteSteps.length, (index) => MPRouteStep.fromJson(jsonRouteSteps[index]));
      routeSteps.removeWhere((element) => element == null);
      steps = routeSteps.cast<MPRouteStep>();
    }

    var geometry;
    if (data["geometry"] != null) {
      var jsonGeometry = convertJsonArray(data["geometry"]);
      var routeGeometry = List<MPRouteCoordinate?>.generate(jsonGeometry.length, (index) => MPRouteCoordinate.fromJson(jsonGeometry[index]));
      routeGeometry.removeWhere((element) => element == null);
      geometry = routeGeometry.cast<MPRouteCoordinate>();
    }
    return MPRouteStep._(
        distance: distance,
        duration: duration,
        startLocation: startLocation,
        endLocation: endLocation,
        highway: highway,
        abutters: abutters,
        htmlInstructions: htmlInstructions,
        maneuver: maneuver,
        travelMode: travelMode,
        availableTravelModes: availableTravelModes,
        steps: steps,
        geometry: geometry);
  }
}
