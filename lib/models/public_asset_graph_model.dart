import 'dart:convert';

class PublicAssetGraphModel {
  PublicAssetGraphModel({
    required this.date,
    required this.value,
  });

  DateTime date;
  double value;

  factory PublicAssetGraphModel.fromJson(Map<String, dynamic> json) => PublicAssetGraphModel(
    date: DateTime.parse(json["date"]),
    value: json["value"].toDouble(),
  );
}
