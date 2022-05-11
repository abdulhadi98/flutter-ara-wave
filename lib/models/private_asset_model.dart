import 'package:wave_flutter/models/asset_list_model.dart';
import 'package:collection/collection.dart';

class PrivateAssetListModel {
  final List<PrivateAssetModel> assets;
  PrivateAssetListModel({required this.assets,});
  factory PrivateAssetListModel.fromJson(List<dynamic> parsedJson) {
    List<PrivateAssetModel> assets = <PrivateAssetModel>[];
    assets = parsedJson.map((i) => PrivateAssetModel.fromJson(i)).toList();
    return new PrivateAssetListModel(assets: assets);
  }
}


class PrivateAssetModel extends AssetModel{
  PrivateAssetModel({
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
    this.assetMetas,
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
  List<PrivateAssetMeta>? assetMetas;

  double? assetNetworth;
  String? assetGrowth;

  // List<List<PrivateAssetMeta>> assetMetasLists = [];
  Map<String, Map<String, List<PrivateAssetMeta>>> assetMetasMap = {};

  void initAssetMetasLists() {
    Map<String, List<PrivateAssetMeta>> map = {};
    assetMetas?.forEach((element) {
      groupBy(map, element, element.template);
    });

    map.forEach((key, value) {
      Map<String, List<PrivateAssetMeta>> tempMap = {};
      value.forEach((element) {
        groupBy(tempMap, element, element.heading);
      });
      assetMetasMap[key] = tempMap;
    });
  }

  Map<String, List<T>>groupBy<T>(Map<String, List<T>> map, T element, String key) {
    List<T> values = map[key] ?? [];
    values.add(element);
    map[key] = values;
    return map;
  }

  factory PrivateAssetModel.fromJson(Map<String, dynamic> json) => PrivateAssetModel(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    stockSymbol: json["stock_symbol"] == null ? null : json["stock_symbol"],
    icon: json["icon"] == null ? null : json["icon"],
    purchasePrice: json["purchase_price"] == null ? null : json["purchase_price"],
    salePrice: json["sale_price"] == null ? null : json["sale_price"],
    serialNumber: json["serial_number"] == null ? null : json["serial_number"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),

    assetTypeId: json["private_asset_type_id"] == null ? null : json["private_asset_type_id"],
    assetSubTypeId: json["private_asset_sub_type_id"] == null ? null : json["private_asset_sub_type_id"],
    assetCategoryId: json["private_asset_category_id"] == null ? null : json["private_asset_category_id"],
    assetType: json["private_asset_type"] == null ? null : PrivateAssetType.fromJson(json["private_asset_type"]),
    assetSubType: json["private_asset_sub_type"] == null ? null : PrivateAssetSubType.fromJson(json["private_asset_sub_type"]),
    assetCategory: json["private_asset_category"] == null ? null : PrivateAssetCategory.fromJson(json["private_asset_category"]),
    assetMetas: json["private_asset_metas"] == null ? null : List<PrivateAssetMeta>.from(json["private_asset_metas"].map((x) => PrivateAssetMeta.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "stock_symbol": stockSymbol == null ? null : stockSymbol,
    "icon": icon == null ? null : icon,
    "purchase_price": purchasePrice == null ? null : purchasePrice,
    "sale_price": salePrice == null ? null : salePrice,
    "private_asset_type_id": assetTypeId == null ? null : assetTypeId,
    "private_asset_sub_type_id": assetSubTypeId == null ? null : assetSubTypeId,
    "private_asset_category_id": assetCategoryId == null ? null : assetCategoryId,
    "serial_number": serialNumber == null ? null : serialNumber,
    "created_at": createdAt == null ? null : createdAt?.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt?.toIso8601String(),
    "private_asset_type": assetType == null ? null : assetType?.toJson(),
    "private_asset_sub_type": assetSubType == null ? null : assetSubType?.toJson(),
    "private_asset_category": assetCategory == null ? null : assetCategory?.toJson(),
    "private_asset_metas": assetMetas == null ? null : List<dynamic>.from(assetMetas!.map((x) => x.toJson())),
  };
}

class PrivateAssetMeta {
  PrivateAssetMeta({
    required this.id,
    required this.privateAssetId,
    required this.template,
    required this.heading,
    required this.label,
    required this.value,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  int privateAssetId;
  String template;
  String heading;
  String label;
  String value;
  String date;
  DateTime createdAt;
  DateTime updatedAt;

  factory PrivateAssetMeta.fromJson(Map<String, dynamic> json) => PrivateAssetMeta(
    id: json["id"] == null ? null : json["id"],
    privateAssetId: json["private_asset_id"] == null ? null : json["private_asset_id"],
    template: json["template"] == null ? null : json["template"],
    heading: json["heading"] == null ? null : json["heading"],
    label: json["label"] == null ? null : json["label"],
    value: json["value"] == null ? null : json["value"],
    date: json["date"] == null ? null : json["date"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "private_asset_id": privateAssetId == null ? null : privateAssetId,
    "template": template == null ? null : template,
    "heading": heading == null ? null : heading,
    "label": label == null ? null : label,
    "value": value == null ? null : value,
    "date": date == null ? null : date,
    "created_at": createdAt == null ? null : createdAt.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
  };
}
