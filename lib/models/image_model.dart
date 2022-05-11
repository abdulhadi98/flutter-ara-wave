import 'dart:convert';

List<ImageModel> mediaPhotoModelFromJson(String str) => List<ImageModel>.from(json.decode(str).map((x) => ImageModel.fromJson(x)));
String mediaPhotoModelToJson(List<ImageModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ImageListModel {
  final List<ImageModel>? images;

  ImageListModel({
    this.images,
  });

  factory ImageListModel.fromJson(List<dynamic> parsedJson) {
    List<ImageModel> images = [];
    images = parsedJson.map((i) => ImageModel.fromJson(i)).toList();

    return new ImageListModel(images: images);
  }
}

class ImageModel {
  ImageModel({
    required this.url,
    required this.id,
  });

  late String url;
  late int id;

  factory ImageModel.fromJson(Map<String, dynamic> json) => ImageModel(
    url: json["url"]== null ? null : json["url"],
    id: json["id"] == null ? null : json["id"],
  );

  Map<String, dynamic> toJson() => {
    "url": url,
    "id": id,
  };
}