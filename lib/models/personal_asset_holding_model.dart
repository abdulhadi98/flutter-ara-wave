import 'dart:convert';

import 'personal_asset_type.dart';

class PersonalAssetHoldingListModel {
  final List<PersonalAssetHoldingModel> holdingList;
  PersonalAssetHoldingListModel({required this.holdingList,});
  factory PersonalAssetHoldingListModel.fromJson(List<dynamic> parsedJson) {
    List<PersonalAssetHoldingModel> holdingList = <PersonalAssetHoldingModel>[];
    holdingList = parsedJson.map((i) => PersonalAssetHoldingModel.fromJson(i)).toList();
    return new PersonalAssetHoldingListModel(holdingList: holdingList);
  }
}

class PersonalAssetHoldingModel {
  PersonalAssetHoldingModel({
    required this.id,
    required this.userId,
    required this.personalAssetTypeId,
    required this.title,
    required this.purchasedPrice,
    required this.createdAt,
    required this.updatedAt,
    this.personalAssetType,
    this.personalAssetPhotos,
  });

  int id;
  int userId;
  int personalAssetTypeId;
  String? title;
  String? purchasedPrice;
  DateTime createdAt;
  DateTime updatedAt;
  PersonalAssetTypeModel? personalAssetType;
  List<PersonalAssetPhotos>? personalAssetPhotos;

  factory PersonalAssetHoldingModel.fromJson(Map<String, dynamic> json) => PersonalAssetHoldingModel(
    id: json["id"] == null ? null : json["id"],
    userId: json["user_id"] == null ? null : json["user_id"],
    personalAssetTypeId: json["personal_asset_type_id"] == null ? null : json["personal_asset_type_id"],
    title: json["title"] == null ? null : json["title"],
    purchasedPrice: json["purchased_price"] == null ? null : json["purchased_price"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    personalAssetType: json["personal_asset_type"] == null ? null : PersonalAssetTypeModel.fromJson(json["personal_asset_type"]),
    personalAssetPhotos: json["personal_asset_photos"] == null ? null : personalAssetPhotosFromJson(json["personal_asset_photos"]!),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "user_id": userId == null ? null : userId,
    "personal_asset_type_id": personalAssetTypeId == null ? null : personalAssetTypeId,
    "title": title == null ? null : title,
    "purchased_price": purchasedPrice == null ? null : purchasedPrice,
    "created_at": createdAt == null ? null : createdAt.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
    "personal_asset_type": personalAssetType == null ? null : personalAssetType!.toJson(),
    "personal_asset_photos": personalAssetPhotos == null ? null : personalAssetPhotosToJson(personalAssetPhotos!),
  };
}

List<PersonalAssetPhotos> personalAssetPhotosFromJson(str) => List<PersonalAssetPhotos>.from(str.map((x) => PersonalAssetPhotos.fromJson(x)));
String personalAssetPhotosToJson(List<PersonalAssetPhotos> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PersonalAssetPhotos {
  PersonalAssetPhotos({
    this.id,
    this.personalAssetId,
    this.link,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? personalAssetId;
  String? link;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory PersonalAssetPhotos.fromJson(Map<String, dynamic> json) => PersonalAssetPhotos(
    id: json["id"] == null ? null : json["id"],
    personalAssetId: json["personal_asset_id"] == null ? null : json["personal_asset_id"],
    link: json["link"] == null ? null : json["link"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "personal_asset_id": personalAssetId == null ? null : personalAssetId,
    "link": link == null ? null : link,
    "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
  };
}
