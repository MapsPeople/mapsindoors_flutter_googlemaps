part of 'package:mapsindoors_platform_interface/platform_library.dart';

class MPVenueInfo extends MapsIndoorsObject {
  final String? _name;
  final List<String>? _aliases;
  final String? _language;
  final Map<String, MPDataField>? _fields;

  static MPVenueInfo? fromJson(json) => json != null && json != "null" ? MPVenueInfo._fromJson(json is String ? jsonDecode(json) : json) : null;

  MPVenueInfo._fromJson(data)
      : _name = data["name"],
        _aliases = data["aliases"] != null ? convertJsonArray<String>(data["aliases"]) : null,
        _language = data["language"],
        _fields = (data["fields"] as Map<String, dynamic>?)?.map((key, value) => MapEntry(key, MPDataField.fromJson(value)!));

  @override
  Map<String, dynamic> toJson() => {"name": _name, "aliases": _aliases, "language": _language, "fields": _fields};
}
