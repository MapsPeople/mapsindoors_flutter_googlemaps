part of 'package:mapsindoors_platform_interface/platform_library.dart';

/// A unique identifier for floors
@immutable
class MPFloorId extends DynamicObjectId {
  const MPFloorId(String value) : super(value);
}

/// A MapsIndoors geographical entity. A [MPFloor] is contained within a [MPBuilding].
class MPFloor extends MPEntity<MPFloorId> implements Comparable<MPFloor> {
  /// The default floor index is 0, as that is the index of ground floors and any point outside a [MPBuilding]
  static const defaultGroundFloorIndex = 0;
  final MPFloorId _id;
  final String _displayName;
  final MPMultiPolygon? _geometry;
  final List<String>? _aliases;

  /// The building id of the floor
  String? buildingId;
  final int? _floorIndex;

  /// Attempts to build a [MPFloor] from a JSON object, this method will decode the object if needed
  static MPFloor? fromJson(json) => json != null && json != "null" ? MPFloor._fromJson(json is String ? jsonDecode(json) : json) : null;

  MPFloor._fromJson(data)
      : _id = MPFloorId(data["id"]),
        _displayName = data["name"],
        _floorIndex = data["floorIndex"],
        _geometry = MPMultiPolygon.fromJson(data["geometry"]),
        _aliases = data["aliases"] != null ? convertJsonArray<String>(data["aliases"]) : null;

  /// Get the floor's [geometry]
  MPMultiPolygon get geometry => _geometry!;

  /// Get the floor's [id]
  @override
  MPFloorId get id => _id;

  /// Get the floor's [id] value
  String get floorId => _id.value;

  /// Get the floor's [floorIndex]
  int get floorIndex => _floorIndex ?? defaultGroundFloorIndex;

  /// Get the floor's [displayName]
  String get displayName => _displayName;

  /// Get the floor's [bounds]
  @override
  MPBounds? get bounds => _geometry?.bounds;

  /// Get a list of [aliases] for the floor
  List<String>? get aliases => _aliases;

  /// Inherited from [MPEntity], a floor's [geometry] is never a [MPPoint]
  @override
  bool get isPoint => false;

  /// Get the floor's [position], this is usually the center of the floor's [geometry]
  @override
  MPPoint get position => _geometry!.bounds.center;

  /// Converts the [MPFloor] to a JSON representation that can be parsed by the MapsIndoors Platform SDK
  @override
  Map<String, dynamic> toJson() => {"id": _id.value, "name": _displayName, "geometry": _geometry, "floorIndex": _floorIndex, "aliases": _aliases, "entityBounds": bounds, "entityIsPoint": false};

  /// Compares two [MPFloor] objects based on their [floorIndex]
  @override
  int compareTo(other) {
    return _floorIndex != other._floorIndex ? (_floorIndex! < other._floorIndex! ? -1 : 1) : 0;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is MPFloor && id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}
