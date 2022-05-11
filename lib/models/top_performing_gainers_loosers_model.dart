import 'dart:convert';

import 'package:wave_flutter/helper/utils.dart';


class TopPerformingGainersLoosersModel {
  TopPerformingGainersLoosersModel({
    required this.topPerforming,
    required this.gainersLoosers,
  });

  List<GainersLooser> topPerforming;
  List<GainersLooser> gainersLoosers;

  factory TopPerformingGainersLoosersModel.fromJson(Map<String, dynamic> json) => TopPerformingGainersLoosersModel(
    topPerforming: List<GainersLooser>.from(json["top_performing"].map((x) => GainersLooser.fromJson(x))),
    gainersLoosers: List<GainersLooser>.from(json["gainers_loosers"].map((x) => GainersLooser.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "top_performing": List<dynamic>.from(topPerforming.map((x) => x.toJson())),
    "gainers_loosers": List<dynamic>.from(gainersLoosers.map((x) => x.toJson())),
  };
}

class GainersLooser {
  GainersLooser({
    required this.assetId,
    this.icon,
    required this.title,
    this.purchasePrice,
    required this.growth,
    required this.absGrowth,
  });

  int assetId;
  String? icon;
  String title;
  String? purchasePrice;
  double growth;
  double absGrowth;

  String get growthTitle => (growth.toInt() < 0 ? '' : '+') + "${Utils.getFormattedNum(growth)}%";

  factory GainersLooser.fromJson(Map<String, dynamic> json) => GainersLooser(
    assetId: json["asset_id"] == null ? null : json["asset_id"],
    icon: json["icon"] == null ? null : json["icon"],
    title: json["title"] == null ? null : json["title"],
    purchasePrice: json["purchase_price"] == null ? null : json["purchase_price"],
    growth: json["growth"] == null ? null : json["growth"].toDouble(),
    absGrowth: json["abs_growth"] == null ? null : json["abs_growth"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "asset_id": assetId == null ? null : assetId,
    "icon": icon == null ? null : icon,
    "title": title == null ? null : title,
    "purchase_price": purchasePrice == null ? null : purchasePrice,
    "growth": growth == null ? null : growth,
    "abs_growth": absGrowth == null ? null : absGrowth,
  };
}
