part of 'package:mapsindoors_platform_interface/platform_library.dart';

/// A filter that can be applied during search, this will limit the returned [MPEntity]s to those that
/// fulfills the filter
class MPFilter extends MapsIndoorsObject {
  static MPFilterBuilder builder() => MPFilterBuilder();

  /// How many of the applicable locations to [take]
  final int? take;

  /// How many of the applicable locations to [skip]
  final int? skip;

  /// The [depth] property makes it possible to get the n'th descendant of a parent location
  ///
  /// Thus, the [depth] property only applies to filters that has set one or more parents.
  /// The hierarchical tree of data is generally structured as Venue &gt; Building &gt; Floor &gt; Room &gt; POI.
  ///
  /// For example, this means that a Floor is the 1st descendant of a Building.
  /// So to get all locations inside a Building, set the [depth] to 3.
  ///
  /// The default value is 1, giving you only the immediate descendant of the specified parents.
  final int? depth;

  /// The [floorIndex] property makes it possible to get the locations on a specific floor
  final int? floorIndex;

  /// A list of categories (keys) from, for example, [MPLocation.categories]
  final List<String>? categories;

  /// A list of location ids to search in
  final List<String>? locations;

  /// A list of location [types] to search in
  final List<String>? types;

  /// A list of parent ids
  final List<String>? parents;

  /// The outer bounds of the query
  final MPBounds? mapExtend;

  /// A [geometry] to search inside
  final MPBounds? geometry;

  /// Allows queries to return results that are marked as non-searchable.
  final bool? ignoreLocationSearchableStatus;

  /// Allows queries to return results that are marked as inactive using the active from/to mechanism.
  final bool? ignoreLocationActiveStatus;

  MPFilter._(this.take, this.skip, this.depth, this.floorIndex, this.categories, this.locations, this.types, this.parents, this.mapExtend, this.geometry, this.ignoreLocationActiveStatus, this.ignoreLocationSearchableStatus);

  /// Converts the [MPFilter] to a JSON representation that can be parsed by the MapsIndoors Platform SDK
  @override
  Map<String, dynamic> toJson() {
    return {
      "take": take,
      "skip": skip,
      "depth": depth,
      "floorIndex": floorIndex,
      "categories": categories,
      "locations": locations,
      "types": types,
      "parents": parents,
      "mapExtend": mapExtend?.toJson(),
      "geometry": geometry?.toJson(),
      "ignoreLocationSearchableStatus": ignoreLocationSearchableStatus,
      "ignoreLocationActiveStatus": ignoreLocationActiveStatus,
    };
  }
}

/// Constructs a [MPFilter]
class MPFilterBuilder {
  int? _take;
  int? _skip;
  int? _depth;
  int? _floorIndex;
  List<String>? _categories;
  List<String>? _locations;
  List<String>? _types;
  List<String>? _parents;
  MPBounds? _mapExtend;
  MPBounds? _geometry;
  bool? _ignoreLocationSearchableStatus;
  bool? _ignoreLocationActiveStatus;

  /// Set the [take] property of the filter, limiting the number of results
  void setTake(int take) {
    _take = take;
  }

  /// Set the [skip] property of the filter, discarding the first [skip] results
  void setSkip(int skip) {
    _skip = skip;
  }

  /// Set the [depth] property of the filter, including the [depth]'th descendant of a parent location
  void setDepth(int depth) {
    _depth = depth;
  }

  /// Set the [floorIndex] property of the filter, limiting the filter to a single floor index
  void setFloorIndex(int floorIndex) {
    _floorIndex = floorIndex;
  }

  /// Set the [categories] property of the filter, limiting the filter to results that are part of the [categories]
  void setCategories(List<String> categories) {
    _categories = List.from(categories);
  }

  /// Set the [locations] property of the filter, limiting the filter to results included in the [locations]
  void setLocations(List<String> locations) {
    _locations = List.from(locations);
  }

  /// Set the [types] property of the filter, limiting the fliter to results with any of the [types]
  void setTypes(List<String> types) {
    _types = List.from(types);
  }

  /// Set the [parents] property of the filter, a list of parent used to search for results
  void setParents(List<String> parents) {
    _parents = List.from(parents);
  }

  /// Set the [mapExtend] property of the filter, limiting the filter's outer bounds
  void setMapExtend(MPBounds mapExtend) {
    _mapExtend = mapExtend;
  }

  /// Set the [geometry] property of the filter, limiting the filter to search inside the [geometry]
  void setGeometry(MPBounds geometry) {
    _geometry = geometry;
  }

  /// Set a [ignore] property of the filter, ignoring non-searchable status for results
  void setIgnoreLocationSearchableStatus(bool ignore) {
    _ignoreLocationSearchableStatus = ignore;
  }

  /// Set a [ignore] property of the filter, ignoring non-active status for results
  void setIgnoreLocationActiveStatus(bool ignore) {
    _ignoreLocationActiveStatus = ignore;
  }

  /// Construct the filter
  MPFilter build() {
    return MPFilter._(_take, _skip, _depth, _floorIndex, _categories, _locations, _types, _parents, _mapExtend, _geometry, _ignoreLocationActiveStatus, _ignoreLocationSearchableStatus);
  }
}
