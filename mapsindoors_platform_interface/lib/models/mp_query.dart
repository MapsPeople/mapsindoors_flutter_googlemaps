part of 'package:mapsindoors_platform_interface/platform_library.dart';

/// A collection of query parameters used to query MapsIndoors
class MPQuery extends MapsIndoorsObject {
  static MPQueryBuilder builder() => MPQueryBuilder();

  /// The queried text (search text)
  final String? query;

  /// The query is restricted to entities near this point
  final MPPoint? near;

  /// A list of properties for this query
  final List<String>? queryProperties;

  const MPQuery._(this.query, this.near, this.queryProperties);

  /// Converts the [MPQuery] to a JSON representation that can be parsed by the MapsIndoors Platform SDK
  @override
  Map<String, dynamic> toJson() {
    return {
      "query": query,
      "near": near?.toJson(),
      "queryProperties": queryProperties,
    };
  }
}

/// A builder for [MPQuery]
class MPQueryBuilder {
  String? _query;
  MPPoint? _near;
  List<String>? _queryProperties;

  /// The [query] text
  void setQuery(String query) {
    _query = query;
  }

  /// The point where the queried target is [near]
  void setNear(MPPoint near) {
    _near = near;
  }

  /// Set the coordinates where the queried target is near
  void setNearWithCoordinates({required num longitude, required num latitude}) {
    _near = MPPoint.withCoordinates(latitude: latitude, longitude: longitude);
  }

  /// A list of query [properties], see [MPLocationPropertyNames]
  void setQueryProperties(List<String> properties) {
    _queryProperties = properties.toList(growable: true);
  }

  /// Add a single query [property], see [MPLocationPropertyNames]
  void addQueryProperty(String property) {
    _queryProperties ??= List.empty(growable: true);
    _queryProperties?.add(property);
  }

  /// Construct a [MPQuery]
  MPQuery build() {
    return MPQuery._(_query, _near, _queryProperties);
  }
}
