import 'dart:convert';

PriceHistoryModel priceHistoryModelFromJson(String str) => PriceHistoryModel.fromJson(json.decode(str));
String priceHistoryModelToJson(PriceHistoryModel data) => json.encode(data.toJson());

class PriceHistoryModel {
  PriceHistoryModel({
    this.apiToken,
    this.id,
    this.assetId,
    this.userId,
    this.assetType,
    this.createdAt,
    this.updatedAt,
    this.yearPrice,
  });

  String? apiToken;
  int? id;
  int? assetId;
  int? userId;
  String? assetType;
  List<YearPrice>? yearPrice;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory PriceHistoryModel.fromJson(Map<String, dynamic> json) => PriceHistoryModel(
    id: json["id"] == null ? null : json["id"],
    assetId: json["asset_id"] == null ? null : json["asset_id"],
    userId: json["user_id"] == null ? null : json["user_id"],
    assetType: json["asset_type"] == null ? null : json["asset_type"],
    yearPrice: json["year_price"] == null ? null : yearPriceListFromJson(json["year_price"]),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "api_token": apiToken,
    "id": id == null ? null : id,
    "asset_id": assetId == null ? null : assetId,
    "user_id": userId == null ? null : userId,
    "asset_type": assetType == null ? null : assetType,
    "year_price": yearPrice == null ? null : yearPriceListToJson(yearPrice!),
    "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
  };
}

yearPriceListToJson(list) => json.encode(List<dynamic>.from(list.map((x) => x.toJson())));
List<YearPrice> yearPriceListFromJson(json) => List<YearPrice>.from(json.map((x) => YearPrice.fromJson(x)));


class YearPrice {
  String year;
  String? price;
  YearPrice({required this.year, this.price});
  factory YearPrice.fromJson(Map<String, dynamic> json) => YearPrice(
    year: json["year"] == null ? null : json["year"],
    price: json["price"] == null ? null : json["price"],
  );

  Map<String, dynamic> toJson() => {
    "year": year == null ? null : year,
    "price": price == null ? null : price,
  };
}
