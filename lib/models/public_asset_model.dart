import 'package:wave_flutter/models/asset_list_model.dart';

class PublicAssetListModel {
  final List<PublicAssetModel> assets;
  PublicAssetListModel({required this.assets,});
  factory PublicAssetListModel.fromJson(List<dynamic> parsedJson) {
    List<PublicAssetModel> assets = <PublicAssetModel>[];
    assets = parsedJson.map((i) => PublicAssetModel.fromJson(i)).toList();
    return PublicAssetListModel(assets: assets);
  }
}

class PublicAssetModel extends AssetModel{
  PublicAssetModel({
    id,
    name,
    stockSymbol,
    icon,
    purchasePrice,
    salePrice,
    serialNumber,
    createdAt,
    updatedAt,

    this.assetTypeId,
    this.assetSubTypeId,
    this.assetCategoryId,
    this.assetType,
    this.assetSubType,
    this.assetCategory,
  }) : super(
      id: id,
      name: name,
      stockSymbol: stockSymbol,
      icon: icon,
      purchasePrice: purchasePrice,
      salePrice: salePrice,
      serialNumber: serialNumber,
      createdAt: createdAt,
      updatedAt: updatedAt,
  );

  int? assetTypeId;
  int? assetSubTypeId;
  int? assetCategoryId;
  PrivateAssetType? assetType;
  PrivateAssetSubType? assetSubType;
  PrivateAssetCategory? assetCategory;

  factory PublicAssetModel.fromJson(Map<String, dynamic> json) => PublicAssetModel(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    stockSymbol: json["stock_symbol"] == null ? null : json["stock_symbol"],
    icon: json["icon"] == null ? null : json["icon"],
    purchasePrice: json["purchase_price"] == null ? null : json["purchase_price"],
    salePrice: json["sale_price"] == null ? null : json["sale_price"],
    serialNumber: json["serial_number"] == null ? null : json["serial_number"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),

    assetTypeId: json["public_asset_type_id"] == null ? null : json["public_asset_type_id"],
    assetSubTypeId: json["public_asset_sub_type_id"] == null ? null : json["public_asset_sub_type_id"],
    assetCategoryId: json["public_asset_category_id"] == null ? null : json["public_asset_category_id"],
    assetType: json["public_asset_type"] == null ? null : PrivateAssetType.fromJson(json["public_asset_type"]),
    assetSubType: json["public_asset_sub_type"] == null ? null : PrivateAssetSubType.fromJson(json["public_asset_sub_type"]),
    assetCategory: json["public_asset_category"] == null ? null : PrivateAssetCategory.fromJson(json["public_asset_category"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "stock_symbol": stockSymbol == null ? null : stockSymbol,
    "icon": icon == null ? null : icon,
    "purchase_price": purchasePrice == null ? null : purchasePrice,
    "sale_price": salePrice == null ? null : salePrice,
    "serial_number": serialNumber == null ? null : serialNumber,
    "created_at": createdAt == null ? null : createdAt?.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt?.toIso8601String(),
    "public_asset_type_id": assetTypeId == null ? null : assetTypeId,
    "public_asset_sub_type_id": assetSubTypeId == null ? null : assetSubTypeId,
    "public_asset_category_id": assetCategoryId == null ? null : assetCategoryId,
    "public_asset_type": assetType == null ? null : assetType?.toJson(),
    "public_asset_sub_type": assetSubType == null ? null : assetSubType?.toJson(),
    "public_asset_category": assetCategory == null ? null : assetCategory?.toJson(),
  };
}