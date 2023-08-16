part of 'package:mapsindoors_platform_interface/platform_library.dart';

/// Governs the topmost
class MPSolution {
  /// The solution's [config]uration object
  final MPSolutionConfig config;

  /// The solution's [id]
  final String id;

  /// The id of the solution in customer systems
  final String? customerId;

  /// The solution's [name]
  final String name;

  /// The solution's default language
  final String defaultLanguage;

  /// A list of available languages for the solution
  final List<String> availableLanguages;

  /// The URL used to fetch data from the CMS
  final String? mapClientUrl;

  /// The solution's location template
  final String? locationTemplate;
  final List<String> _modules;

  /// Attempts to build a [MPSolution] from a JSON object, this method will decode the object if needed
  static MPSolution? fromJson(json) => json != null && json != "null" ? MPSolution._fromJson(json is String ? jsonDecode(json) : json) : null;

  MPSolution._fromJson(data)
      : config = MPSolutionConfig.fromJson(data["solutionConfig"])!,
        id = data["id"],
        customerId = data["customerId"],
        name = data["name"],
        defaultLanguage = data["defaultLanguage"],
        availableLanguages = convertJsonArray<String>(data["availableLanguages"]),
        mapClientUrl = data["mapClientUrl"],
        locationTemplate = data["locationTemplate"],
        _modules = data["modules"].cast<String>();

  /// Parses a [venueId] and a [locationId] to create a [mapClientUrl]
  Future<String?> parseMapClientUrl(String venueId, String locationId) async {
    return await UtilPlatform.instance.parseMapClientUrl(venueId, locationId);
  }

  /// Check if the solution has support for a [language]
  bool hasLanguage(String? language) => language != null ? availableLanguages.contains(language) : false;

  /// Check whether the 22nd zoom level is available for select map providers
  bool isZoom22Enabled() => _modules.contains("z22");

  /// Check whether wall extrusions are available for select map providers
  bool is3DWallsEnabled() => _modules.contains("3dwalls");

  /// Check whether room extrusions are available for select map providers
  bool is3DExtrusionsEnabled() => _modules.contains("3dextrusions");
}
