part of 'package:mapsindoors_platform_interface/platform_library.dart';

/// A unique identifier for locations
@immutable
class MPLocationId extends DynamicObjectId {
  const MPLocationId(String value) : super(value);
}

/// A MapsIndoors geographical entity. A [MPLocation] can exist anywhere,
/// but it is usually only used inside [MPVenue]s and [MPBuilding]s.
class MPLocation extends MPEntity<MPLocationId> {
  final MPLocationId id;
  final MPGeometry? _geometry;
  final List<String>? _restrictions;
  final MPPropertyData? _properties;
  final MPPoint? _point;

  const MPLocation._({required this.id, MPGeometry? geometry, List<String>? restrictions, MPPropertyData? properties, MPPoint? point})
      : _geometry = geometry,
        _restrictions = restrictions,
        _properties = properties,
        _point = point;

  /// Attempts to build a [MPLocation] from a JSON object, this method will decode the object if needed
  static MPLocation? fromJson(json) => json != null && json != "null" ? MPLocation._fromJson(json is String ? jsonDecode(json) : json) : null;

  static MPLocation _fromJson(data) {
    final id = MPLocationId(data["id"]);
    var geometry;
    if (data["geometry"] != null) {
      final geo = data["geometry"];

      if (Platform.isIOS) {
        switch (data["geometryType"]) {
          case MPGeometry.point:
            geometry = MPPoint.fromJson(geo);
            break;
          case MPGeometry.polygon:
            geometry = MPPolygon.fromJson(geo);
            break;
          case MPGeometry.multiPolygon:
            geometry = MPMultiPolygon.fromJson(geo);
            break;
        }
      } else {
        switch (geo["type"]) {
          case MPGeometry.point:
            geometry = MPPoint.fromJson(geo);
            break;
          case MPGeometry.polygon:
            geometry = MPPolygon.fromJson(geo);
            break;
          case MPGeometry.multiPolygon:
            geometry = MPMultiPolygon.fromJson(geo);
            break;
        }
      }
    }
    var point;
    if (Platform.isIOS) {
      if (data["point"] != null) {
        point = MPPoint.fromJson(data["point"]);
      }
      //TODO: fix bounds not being available on iOS
    }
    var restrictions;
    if (data["restrictions"] != null) {
      restrictions = convertJsonArray<String>(data["restrictions"]);
    }
    final properties = MPPropertyData.fromJson(data["properties"]);

    return MPLocation._(id: id, geometry: geometry, restrictions: restrictions, properties: properties, point: point);
  }

  /// Get the location's [bounds]
  @override
  MPBounds get bounds {
    return _calcBounds();
  }

  MPBounds _calcBounds() {
    switch (_geometry!.runtimeType) {
      case MPPolygon:
        return (_geometry as MPPolygon).bounds;
      case MPMultiPolygon:
        return (_geometry as MPMultiPolygon).bounds;
      default:
        return MPBounds(northeast: position, southwest: position);
    }
  }

  /// Inherited from [MPEntity], checks whether the location's [geometry] is a [MPPoint]
  @override
  bool get isPoint => _geometry is MPPoint;

  /// Get the location's [position], this is usually the location's anchor point
  @override
  MPPoint get position => _properties?.anchor ?? MPPoint.withCoordinates(latitude: 0, longitude: 0);

  /// Converts the [MPLocation] to a JSON representation that can be parsed by the MapsIndoors Platform SDK
  @override
  Map<String, dynamic> toJson() => {"id": id.value};

  /// Get the location's [id] value
  String get locationId => id.value;

  /// Get the location's [point]
  MPPoint get point => _point ?? _calcPoint();

  MPPoint _calcPoint() {
    if (_geometry == null) {
      return MPPoint();
    } else {
      final pt = MPPoint.copy(_geometry!.position);
      pt.floorIndex = floorIndex;
      return pt;
    }
  }

  // Get the location's [geometry]
  // This is currently unused
  //MPGeometry get geometry => _geometry!;

  /// Get the location's [name]
  String get name => _properties!.name;

  /// Get a list of [aliases] for the location
  List<String>? get aliases => _properties?.aliases;

  /// Get a list of [categories] the location is contained in
  List<String>? get categories {
    final categoryMap = _properties?.categories?.entries;
    return categoryMap != null ? List.from(categoryMap) : null;
  }

  /// Get the location's [floorIndex]
  int get floorIndex => _properties!.floorIndex!;

  /// Get the name of the [MPFloor] the location is on
  String? get floorName => _properties?.floorName;

  /// Get the name of the [MPBuilding] the location is in
  String? get buildingName => _properties?.building;

  /// Get the name of the [MPVenue] the location is in
  String? get venueName => _properties?.venue;

  /// Get the name of the location's type
  String? get typeName => _properties?.type;

  /// Get the location's [description]
  String? get description => _properties?.description;

  /// Get the location's external id
  String get externalId => _properties!.externalId!;

  /// Get the time (epoch) the location is active from
  int? get activeFrom => _properties?.activeFrom;

  /// Get the time (epoch) the location is active to
  int? get activeTo => _properties?.activeTo;

  /// Get the URL for the location's image
  String? get imageUrl => _properties?.imageUrl;

  /// Get the location's [restrictions]
  List<String>? get restrictions => _restrictions;

  /// Chech whether this location is bookable, this only checks if the location is allowed to be booked
  bool get isBookable => _properties?.bookable ?? false;

  /// Gets the location's [MPLocationType] [baseType]
  MPLocationType get baseType {
    switch (_properties?.type) {
      case "area":
        return MPLocationType.area;
      case "venue":
        return MPLocationType.venue;
      case "building":
        return MPLocationType.building;
      case "room":
        return MPLocationType.room;
      case "floor":
        return MPLocationType.floor;
      case "asset":
        return MPLocationType.asset;
      case "poi":
      default:
        return MPLocationType.poi;
    }
  }

  /// Fetch a property from the location with a [MPLocationPropertyNames] [key]
  Object? getProperty(MPLocationPropertyNames key) {
    switch (key) {
      case MPLocationPropertyNames.name:
        return _properties?.name;
      case MPLocationPropertyNames.aliases:
        return _properties?.aliases;
      case MPLocationPropertyNames.categories:
        return _properties?.categories;
      case MPLocationPropertyNames.floor:
        return _properties?.floorIndex;
      case MPLocationPropertyNames.floorName:
        return _properties?.floorName;
      case MPLocationPropertyNames.building:
        return _properties?.building;
      case MPLocationPropertyNames.venue:
        return _properties?.venue;
      case MPLocationPropertyNames.type:
        return _properties?.type;
      case MPLocationPropertyNames.description:
        return _properties?.description;
      case MPLocationPropertyNames.roomId:
      case MPLocationPropertyNames.externalId:
        return _properties?.externalId;
      case MPLocationPropertyNames.activeFrom:
        return _properties?.activeFrom;
      case MPLocationPropertyNames.activeTo:
        return _properties?.activeTo;
      case MPLocationPropertyNames.contact:
        return _properties?.contact;
      case MPLocationPropertyNames.fields:
        return _properties?.fields;
      case MPLocationPropertyNames.imageURL:
        return _properties?.imageUrl;
      case MPLocationPropertyNames.locationType:
        return _properties?.locationType;
      case MPLocationPropertyNames.anchor:
        return _properties?.anchor;
      case MPLocationPropertyNames.bookable:
        return _properties?.bookable;
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is MPLocation && id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}
