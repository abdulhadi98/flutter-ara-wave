import 'package:wave_flutter/models/public_asset_model.dart';
import 'holding_list_model.dart';

class PublicHoldingListModel {
  final List<HoldingModel> holdingList;
  PublicHoldingListModel({required this.holdingList,});
  factory PublicHoldingListModel.fromJson(List<dynamic> parsedJson) {
    List<HoldingModel> holdingList = <HoldingModel>[];
    holdingList = parsedJson.map((i) => PublicHoldingModel.fromJson(i)).toList();
    return new PublicHoldingListModel(holdingList: holdingList);
  }
}

class PublicHoldingModel extends HoldingModel {

  PublicHoldingModel({
    required purchasedPrice,
    required quantity,
    required this.id,
    required this.verified,
    required this.publicAssetId,
    required this.asset,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
    required this.purchasedAt,
  }): super(
    purchasedPrice: purchasedPrice,
    quantity: quantity,
  );

  int id;
  int userId;
  int publicAssetId;
  PublicAssetModel asset;
  int verified;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime purchasedAt;


  factory PublicHoldingModel.fromJson(Map<String, dynamic> json) => PublicHoldingModel(
    id: json["id"],
    userId: json["user_id"],
    purchasedPrice: json["purchased_price"],
    quantity: json["quantity"],
    purchasedAt: DateTime.parse(json["purchased_at"]),
    verified: json["verified"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    publicAssetId: json["public_asset_id"],
    asset: PublicAssetModel.fromJson(json["public_asset"]),
  );

  Map<String, dynamic> toJson() => {
    "public_asset_id": publicAssetId,
  };
}