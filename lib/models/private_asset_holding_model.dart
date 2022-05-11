import 'package:wave_flutter/models/asset_list_model.dart';
import 'add_private_asset_holding_model.dart';
import 'holding_list_model.dart';
import 'private_asset_model.dart';

class PrivateHoldingListModel {
  final List<HoldingModel> holdingList;
  PrivateHoldingListModel({required this.holdingList,});
  factory PrivateHoldingListModel.fromJson(List<dynamic> parsedJson) {
    List<HoldingModel> holdingList = <HoldingModel>[];
    holdingList = parsedJson.map((i) => PrivateHoldingModel.fromJson(i)).toList();
    return new PrivateHoldingListModel(holdingList: holdingList);
  }
}

List<PrivateHoldingModel> privateHoldingListFromJson(json) => List<PrivateHoldingModel>.from(json.map((x) => PrivateHoldingModel.fromJson(x)));

class PrivateHoldingModel extends BasePrivateAssetHoldingModel {

  PrivateHoldingModel({
    required purchasedPrice,
    required quantity,
    required privateAssetId,
    required companySharesOutstanding,
    required country,
    required headquarterCity,
    required investedCapital,
    required shareClass,
    required this.verified,
    this.asset,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
    required this.purchasedAt,
  }): super(
    purchasedPrice: purchasedPrice,
    quantity: quantity,
    companySharesOutstanding: companySharesOutstanding,
    country: country,
    headquarterCity: headquarterCity,
    investedCapital: investedCapital,
    privateAssetId: privateAssetId,
    shareClass: shareClass,
  );

  int userId;
  int id;
  PrivateAssetModel? asset;
  int verified;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime purchasedAt;

  factory PrivateHoldingModel.fromJson(Map<String, dynamic> json) => PrivateHoldingModel(
    asset: json["private_asset"] == null ? null : PrivateAssetModel.fromJson(json["private_asset"]),
    userId: json["user_id"] == null ? null : json["user_id"],
    privateAssetId: json["private_asset_id"] == null ? null : json["private_asset_id"],
    quantity: json["quantity"] == null ? null : json["quantity"],
    purchasedAt: DateTime.parse(json["purchased_at"]),
    headquarterCity: json["headquarter_city"] == null ? null : json["headquarter_city"],
    country: json["country"] == null ? null : json["country"],
    investedCapital: json["invested_capital"] == null ? null : json["invested_capital"],
    shareClass: json["share_class"] == null ? null : json["share_class"],
    companySharesOutstanding: json["shares_outstanding"] == null ? null : json["shares_outstanding"],
    purchasedPrice: json["purchased_price"] == null ? null : json["purchased_price"],
    verified: json["verified"] == null ? null : json["verified"],
    updatedAt: DateTime.parse(json["updated_at"]),
    createdAt: DateTime.parse(json["created_at"]),
    id: json["id"] == null ? null : json["id"],
  );

  Map<String, dynamic> toJson() => {
    "private_asset_id": privateAssetId,
  };
}