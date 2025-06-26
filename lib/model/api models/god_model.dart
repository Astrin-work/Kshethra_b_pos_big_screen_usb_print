// To parse this JSON data, do
//
//     final godmodel = godmodelFromJson(jsonString);

import 'dart:convert';

List<Godmodel> godmodelFromJson(String str) => List<Godmodel>.from(json.decode(str).map((x) => Godmodel.fromJson(x)));

String godmodelToJson(List<Godmodel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Godmodel {
  int devathaId;
  String devathaName;
  String devathaImage;
  List<Counter> counters;

  Godmodel({
    required this.devathaId,
    required this.devathaName,
    required this.devathaImage,
    required this.counters,
  });

  factory Godmodel.fromJson(Map<String, dynamic> json) => Godmodel(
    devathaId: json["devathaId"],
    devathaName: json["devathaName"],
    devathaImage: json["devathaImage"],
    counters: List<Counter>.from(json["counters"].map((x) => Counter.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "devathaId": devathaId,
    "devathaName": devathaName,
    "devathaImage": devathaImage,
    "counters": List<dynamic>.from(counters.map((x) => x.toJson())),
  };
}

class Counter {
  int counterId;
  String counterName;
  List<Vazhipadus> vazhipadus;

  Counter({
    required this.counterId,
    required this.counterName,
    required this.vazhipadus,
  });

  factory Counter.fromJson(Map<String, dynamic> json) => Counter(
    counterId: json["counterId"],
    counterName: json["counterName"],
    vazhipadus: List<Vazhipadus>.from(json["vazhipadus"].map((x) => Vazhipadus.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "counterId": counterId,
    "counterName": counterName,
    "vazhipadus": List<dynamic>.from(vazhipadus.map((x) => x.toJson())),
  };
}

class Vazhipadus {
  int offerId;
  String offerName;
  int cost;
  int limit;
  DateTime enteryTime;
  bool status;

  Vazhipadus({
    required this.offerId,
    required this.offerName,
    required this.cost,
    required this.limit,
    required this.enteryTime,
    required this.status,
  });

  factory Vazhipadus.fromJson(Map<String, dynamic> json) => Vazhipadus(
    offerId: json["offerId"],
    offerName: json["offerName"],
    cost: json["cost"],
    limit: json["limit"],
    enteryTime: DateTime.parse(json["enteryTime"]),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "offerId": offerId,
    "offerName": offerName,
    "cost": cost,
    "limit": limit,
    "enteryTime": enteryTime.toIso8601String(),
    "status": status,
  };
}
