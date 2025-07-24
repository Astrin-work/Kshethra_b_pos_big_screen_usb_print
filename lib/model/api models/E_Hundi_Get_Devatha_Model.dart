// To parse this JSON data, do
//
//     final ehundigetdevathamodel = ehundigetdevathamodelFromJson(jsonString);

import 'dart:convert';

List<Ehundigetdevathamodel> ehundigetdevathamodelFromJson(String str) => List<Ehundigetdevathamodel>.from(json.decode(str).map((x) => Ehundigetdevathamodel.fromJson(x)));

String ehundigetdevathamodelToJson(List<Ehundigetdevathamodel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Ehundigetdevathamodel {
  int devathaId;
  String devathaImage;
  int devathaNameId;
  String devathaName;

  Ehundigetdevathamodel({
    required this.devathaId,
    required this.devathaImage,
    required this.devathaNameId,
    required this.devathaName,
  });

  Ehundigetdevathamodel copyWith({
    int? devathaId,
    String? devathaImage,
    int? devathaNameId,
    String? devathaName,
  }) =>
      Ehundigetdevathamodel(
        devathaId: devathaId ?? this.devathaId,
        devathaImage: devathaImage ?? this.devathaImage,
        devathaNameId: devathaNameId ?? this.devathaNameId,
        devathaName: devathaName ?? this.devathaName,
      );

  factory Ehundigetdevathamodel.fromJson(Map<String, dynamic> json) => Ehundigetdevathamodel(
    devathaId: json["devathaId"],
    devathaImage: json["devathaImage"],
    devathaNameId: json["devathaNameId"],
    devathaName: json["devathaName"],
  );

  Map<String, dynamic> toJson() => {
    "devathaId": devathaId,
    "devathaImage": devathaImage,
    "devathaNameId": devathaNameId,
    "devathaName": devathaName,
  };
}
