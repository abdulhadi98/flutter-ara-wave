
import 'package:wave_flutter/services/urls_container.dart';

class AssetListModel {
  final List<AssetModel> assets;
  AssetListModel({required this.assets,});
  factory AssetListModel.fromJson(List<dynamic> parsedJson) {
    List<AssetModel> assets = <AssetModel>[];
    assets = parsedJson.map((i) => AssetModel.fromJson(i)).toList();
    return new AssetListModel(assets: assets);
  }
}

class AssetModel{
  AssetModel({
    this.id,
    this.name,
    this.stockSymbol,
    this.icon,
    this.purchasePrice,
    this.salePrice,
    this.serialNumber,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? name;
  String? stockSymbol;
  String? icon;
  String? purchasePrice;
  String? salePrice;
  String? serialNumber;
  DateTime? createdAt;
  DateTime? updatedAt;

  String? get iconUrl => '${UrlsContainer.baseUrl}/images/public_assets/$icon'; //TODO

  factory AssetModel.fromJson(Map<String, dynamic> json) => AssetModel(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    stockSymbol: json["stock_symbol"] == null ? null : json["stock_symbol"],
    icon: json["icon"] == null ? null : json["icon"],
    purchasePrice: json["purchase_price"] == null ? null : json["purchase_price"],
    salePrice: json["sale_price"] == null ? null : json["sale_price"],
    serialNumber: json["serial_number"] == null ? null : json["serial_number"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
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
  };
}


class PrivateAssetType {
  PrivateAssetType({
    this.id,
    this.name,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? name;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory PrivateAssetType.fromJson(Map<String, dynamic> json) => PrivateAssetType(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "created_at": createdAt == null ? null : createdAt?.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt?.toIso8601String(),
  };
}

class PrivateAssetSubType {
  PrivateAssetSubType({
    this.id,
    this.name,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? name;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory PrivateAssetSubType.fromJson(Map<String, dynamic> json) => PrivateAssetSubType(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "created_at": createdAt == null ? null : createdAt?.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt?.toIso8601String(),
  };
}

class PrivateAssetCategory {
  PrivateAssetCategory({
    this.id,
    this.name,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? name;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory PrivateAssetCategory.fromJson(Map<String, dynamic> json) => PrivateAssetCategory(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "created_at": createdAt == null ? null : createdAt?.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt?.toIso8601String(),
  };
}


