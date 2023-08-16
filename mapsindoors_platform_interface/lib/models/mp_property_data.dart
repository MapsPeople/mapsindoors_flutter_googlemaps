part of 'package:mapsindoors_platform_interface/platform_library.dart';

class MPPropertyData extends MapsIndoorsObject {
  final String? _name;
  final List<String>? aliases;
  final Map<String, String>? categories;
  final int? floorIndex;
  final String? floorName;
  final String? building;
  final String? venue;
  //final DisplayRule? _displayRule; // has been removed due to the nature of this display rule being an immutable display rule which cannot be viewed
  final String? type;
  final String? description;
  final String? externalId;
  final int? activeFrom;
  final int? activeTo;
  final Map<String, MPDataField>? contact;
  final Map<String, MPDataField>? fields;
  final String? imageUrl;
  final String? locationType;
  final MPPoint? anchor;
  final bool? bookable;

  static MPPropertyData? fromJson(json) => json != null && json != "null" ? MPPropertyData._fromJson(json is String ? jsonDecode(json) : json) : null;

  MPPropertyData._fromJson(data)
      : _name = data["name"],
        aliases = data["aliases"] != null ? convertJsonArray(data["aliases"]) : null,
        categories = data["categories"] != null ? _convertMap<String>((x) => x.toString(), data["categories"]) : null,
        floorIndex = Platform.isIOS ? data["floor"] : int.tryParse(data["floor"]),
        floorName = data["floorName"],
        building = data["building"],
        venue = data["venue"],
        type = data["type"],
        description = data["description"],
        externalId = data["externalId"],
        activeFrom = data["activeFrom"],
        activeTo = data["activeTo"],
        contact = data["contact"] != null ? _convertMap<MPDataField>(MPDataField._fromJson, data["contact"]) : null,
        fields = data["fields"] != null ? _convertMap<MPDataField>(MPDataField._fromJson, data["fields"]) : null,
        imageUrl = data["imageURL"],
        locationType = data["locationType"],
        anchor = MPPoint.fromJson(data["anchor"]),
        bookable = data["bookable"];

  static Map<String, T> _convertMap<T>(T Function(dynamic value) parser, Map<String, dynamic> map) {
    return map.map((key, value) => MapEntry(key, parser.call(value)));
  }

  String get name {
    return _name!.replaceAll("\\n", "n");
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "name": _name,
      "aliases": aliases,
      "categories": categories,
      "floor": floorIndex.toString(),
      "floorName": floorName,
      "building": building,
      "venue": venue,
      "type": type,
      "description": description,
      "externalId": externalId,
      "activeFrom": activeFrom,
      "activeTo": activeTo,
      "contact": contact,
      "fields": fields,
      "imageURL": imageUrl,
      "locationType": locationType,
      "anchor": anchor,
      "bookable": bookable,
    };
  }
}
