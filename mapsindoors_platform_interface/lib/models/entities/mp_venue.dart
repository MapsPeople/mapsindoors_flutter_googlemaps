part of 'package:mapsindoors_platform_interface/platform_library.dart';

/// A unique identifier for venues
@immutable
class MPVenueId extends DynamicObjectId {
  const MPVenueId(String value) : super(value);
}

/// A MapsIndoors geographical entity. A [MPVenue] can exist anywhere,
/// and it can contain a number of [MPBuilding]s and [MPLocation]s.
class MPVenue extends MPEntity<MPVenueId> {
  final MPVenueId id;
  final String? graphId;
  final String administrativeId;
  final String tilesUrl;
  final List<MPMapStyle>? _mapStyles;
  final MPPolygon geometry;
  final int defaultFloor;
  final MPVenueInfo venueInfo;
  final MPPoint? _anchor;
  final List<MPPoint>? _entryPoints;
  final String? externalId;

  /// Attempts to build a [MPVenue] from a JSON object, this method will decode the object if needed
  static MPVenue? fromJson(json) => json != null && json != "null" ? MPVenue._fromJson(json is String ? jsonDecode(json) : json) : null;

  MPVenue._fromJson(data)
      : id = MPVenueId(data["id"]),
        graphId = data["graphId"],
        administrativeId = data["name"],
        tilesUrl = data["tilesUrl"],
        geometry = MPPolygon.fromJson(data["geometry"])!,
        defaultFloor = data["defaultFloor"],
        venueInfo = MPVenueInfo.fromJson(data["venueInfo"])!,
        _anchor = MPPoint.fromJson(data["anchor"]),
        externalId = data["externalId"],
        _mapStyles = convertMIList<MPMapStyle>(data["styles"], (p0) => MPMapStyle.fromJson(p0)),
        _entryPoints = convertMIList<MPPoint>(data["entryPoints"], ((p0) => MPPoint.fromJson(p0)));

  /// Converts the [MPVenue] to a JSON representation that can be parsed by the MapsIndoors Platform SDK
  @override
  Map<String, dynamic> toJson() {
    return {
      "id": id.value,
      "name": administrativeId,
      "graphId": graphId,
      "administrativeId": administrativeId,
      "tilesUrl": tilesUrl,
      "styles": _mapStyles,
      "geometry": geometry,
      "defaultFloor": defaultFloor,
      "venueInfo": venueInfo,
      "anchor": _anchor,
      "entryPoints": _entryPoints,
      "externalId": externalId,
    };
  }

  /// Get the [position] of the venue, this will correspond to the venue's anchor point
  @override
  MPPoint get position => _anchor!;

  /// Get the venue's [bounds]
  @override
  MPBounds? get bounds => geometry.bounds;

  /// Get the venue's [name]
  String? get name => venueInfo._name;

  /// Get the venue's map styles
  List<MPMapStyle> get mapStyles => _mapStyles ?? [];

  /// Get the venue's default mapstyle
  MPMapStyle? get defaultMapStyle => _mapStyles?[0];

  /// Get a list of entry points for the venue
  List<MPPoint> get entryPoints => _entryPoints ?? [];

  /// Fetch a field from the venue
  MPDataField? getField(String? key) => venueInfo._fields?[key];

  /// Inherited from [MPEntity], a venue's [geometry] is never a [MPPoint]
  @override
  bool get isPoint => false;

  /// Check whether a given [mapstyle] is valid for the venue
  bool isMapStyleValid(MPMapStyle mapstyle) {
    if (_mapStyles == null) {
      return false;
    }
    for (var style in _mapStyles!) {
      if (style == mapstyle) {
        return true;
      }
    }
    return false;
  }

  /// Check whether the venue has a valid routing graph
  Future<bool?> get hasGraph async {
    if (graphId == null) {
      return false;
    }
    return await UtilPlatform.instance.venueHasGraph(id.value);
  }

  /// Check whether the venue contains a [point]
  Future<bool?> contains(MPPoint point) async => await UtilPlatform.instance.geometryIsInside(geometry, point);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is MPVenue && id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}
