// To parse this JSON data, do
//
//     final getSingleTemplemodel = getSingleTemplemodelFromJson(jsonString);

import 'dart:convert';

GetSingleTemplemodel getSingleTemplemodelFromJson(String str) => GetSingleTemplemodel.fromJson(json.decode(str));

String getSingleTemplemodelToJson(GetSingleTemplemodel data) => json.encode(data.toJson());

class GetSingleTemplemodel {
  String templeName;

  GetSingleTemplemodel({
    required this.templeName,
  });

  GetSingleTemplemodel copyWith({
    String? templeName,
  }) =>
      GetSingleTemplemodel(
        templeName: templeName ?? this.templeName,
      );

  factory GetSingleTemplemodel.fromJson(Map<String, dynamic> json) => GetSingleTemplemodel(
    templeName: json["templeName"],
  );

  Map<String, dynamic> toJson() => {
    "templeName": templeName,
  };
}
