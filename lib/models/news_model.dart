import 'dart:convert';
import 'package:wave_flutter/models/image_model.dart';

class NewsListModel {
  NewsListModel({
    required this.news,
  });

  List<NewsModel> news;

  factory NewsListModel.fromJson(Map<String, dynamic> json) => NewsListModel(
    news: List<NewsModel>.from(json["items"].map((x) => NewsModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "items": List<dynamic>.from(news.map((x) => x.toJson())),
  };
}

class NewsModel {
  NewsModel({
    required this.id,
    required this.title,
    required this.description,
    required this.formattedDescription,
    required this.url,
    required this.author,
    required this.date,
    this.enclosure,
    required this.hash,
    required this.createdAt,
  });

  String id;
  String title;
  String description;
  String formattedDescription;
  String url;
  String author;
  DateTime date;
  Enclosure? enclosure;
  String hash;
  DateTime createdAt;

  factory NewsModel.fromJson(Map<String, dynamic> json) => NewsModel(
    id: json["id"] == null ? null : json["id"],
    title: json["title"] == null ? null : json["title"],
    description: json["description"] == null ? null : json["description"],
    formattedDescription: json["formattedDescription"] == null ? null : json["formattedDescription"],
    url: json["url"] == null ? null : json["url"],
    author: json["author"] == null ? null : json["author"],
    date: DateTime.parse(json["date"]),
    enclosure: json["enclosure"]==null ? null : Enclosure.fromJson(json["enclosure"]),
    hash: json["hash"] == null ? null : json["hash"],
    createdAt: DateTime.parse(json["createdAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "title": title == null ? null : title,
    "description": description == null ? null : description,
    "formattedDescription": formattedDescription == null ? null : formattedDescription,
    "url": url == null ? null : url,
    "author": author == null ? null : author,
    "date": date == null ? null : date.toIso8601String(),
    "enclosure": enclosure == null ? null : enclosure!.toJson(),
    "hash": hash == null ? null : hash,
    "createdAt": createdAt == null ? null : createdAt.toIso8601String(),
  };
}

class Enclosure {
  Enclosure({
    required this.url,
    required this.size,
    required this.type,
  });

  String url;
  String size;
  String type;

  factory Enclosure.fromJson(Map<String, dynamic> json) => Enclosure(
    url: json["url"],
    size: json["size"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "url": url == null ? null : url,
    "size": size == null ? null : size,
    "type": type,
  };

}
