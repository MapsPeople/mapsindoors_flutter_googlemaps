part of 'package:mapsindoors_platform_interface/platform_library.dart';

/// A route from a origin to a destination broken up into [MPRouteLeg] [legs]
class MPRoute extends MapsIndoorsObject {
  /// The [legs] the route consists of
  final List<MPRouteLeg>? legs;

  /// The [copyrights] for this route, if any
  final String? copyrights;

  /// A [summary] of the route
  final String? summary;

  /// Any [warnings] issued for any paths on the route
  final List<String>? warnings;

  /// All [restrictions] in place for the route
  final List<String>? restrictions;

  /// The outer [bounds] of the route
  final MPBounds? bounds;

  const MPRoute._({this.legs, this.copyrights, this.summary, this.warnings, this.restrictions, this.bounds});

  /// Converts the [MPRoute] to a JSON representation that can be parsed by the MapsIndoors Platform SDK
  @override
  Map<String, dynamic> toJson() {
    var jsonLegs = legs?.map((e) => e.toJson()).toList();
    return {"legs": jsonLegs, "copyrights": copyrights, "summary": summary, "warnings": warnings, "restrictions": restrictions, "bounds": bounds?.toJson()};
  }

  /// Attempts to build a [MPRoute] from a JSON object, this method will decode the object if needed
  static MPRoute? fromJson(json) => json != null && json != "null" ? MPRoute._fromJson(json is String ? jsonDecode(json) : json) : null;

  static MPRoute _fromJson(data) {
    final copyrights = data["copyrights"];
    final summary = data["summary"];
    final warnings = convertJsonArray<String>(data["warnings"]);
    final restrictions = convertJsonArray<String>(data["restrictions"]);
    final list = convertJsonArray(data["legs"]);
    final routeLegs = List<MPRouteLeg?>.generate(list.length, (index) => MPRouteLeg.fromJson(list[index]));
    routeLegs.removeWhere((element) => element == null);
    final legs = routeLegs.cast<MPRouteLeg>();
    var bounds;
    if (data["bounds"] != null) {
      //TODO: fix bounds?
    }
    return MPRoute._(legs: legs, copyrights: copyrights, summary: summary, warnings: warnings, restrictions: restrictions, bounds: bounds);
  }
}
