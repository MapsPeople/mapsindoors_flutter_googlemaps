part of 'package:mapsindoors_platform_interface/platform_library.dart';

/// A camera position object, used to move the camera to a specific position.
class MPCameraPosition extends MapsIndoorsObject {
  final num zoom;
  final MPPoint target;
  final num tilt;
  final num bearing;

  /// Attempts to build a [MPCameraPosition] from a JSON object, this method will decode the object if needed
  static MPCameraPosition? fromJson(json) => json != null && json != "null" ? MPCameraPosition._fromJson(json is String ? jsonDecode(json) : json) : null;

  /// Build a Camera Position, with optional tilt and bearing parameters.
  const MPCameraPosition({required this.zoom, required this.target, this.tilt = 0, this.bearing = 0});

  static MPCameraPosition _fromJson(data) {
    final zoom = data["zoom"];
    final tilt = data["tilt"];
    final bearing = data["bearing"];
    final target = MPPoint.fromJson(data["target"])!;
    return new MPCameraPosition(zoom: zoom, target: target, bearing: bearing, tilt: tilt);
  }

  @override
  Map<String, dynamic> toJson() {
    return {"zoom": zoom, "tilt": tilt, "bearing": bearing, "target": target.toJson()};
  }
}

/// Construct a camera position.
class MPCameraPositionBuilder {
  /// Copy another position to use as a reference.
  MPCameraPositionBuilder.fromPosition(MPCameraPosition position)
      : target = position.target,
        zoom = position.zoom,
        tilt = position.tilt,
        bearing = position.bearing;

  /// Start the builder, a target and zoom is required to build a [MPCameraPosition]
  MPCameraPositionBuilder({required this.target, required this.zoom});

  num zoom;
  MPPoint target;
  num tilt = 0;
  num bearing = 0;

  MPCameraPosition build() {
    return MPCameraPosition(zoom: zoom, target: target, tilt: tilt, bearing: bearing);
  }
}
