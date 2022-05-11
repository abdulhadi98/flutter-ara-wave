import 'dart:convert';
import 'package:wave_flutter/helper/utils.dart';
import 'package:wave_flutter/models/image_model.dart';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));
String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    this.name,
    this.email,
    this.firstName,
    this.lastName,
    this.password,
    this.joinDate,
    this.bio,
    this.country,
    this.city,
    this.phone,
    this.updatedAt,
    this.createdAt,
    this.id,
    this.apiToken,
    this.netWorth,
  });

  String? name;
  String? email;
  String? firstName;
  String? lastName;
  String? password;
  DateTime? joinDate;
  String? bio;
  String? country;
  String? city;
  String? phone;
  DateTime? updatedAt;
  DateTime? createdAt;
  int? id;
  String? apiToken;
  double? netWorth;

  String get formattedNetWorth => Utils.getFormattedNum(netWorth??0);

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    name: json["name"] == null ? null : json["name"],
    email: json["email"] == null ? null : json["email"],
    firstName: json["first_name"] == null ? null : json["first_name"],
    lastName: json["last_name"] == null ? null : json["last_name"],
    joinDate: json["join_date"] == null ? null : DateTime.parse(json["join_date"]),
    bio: json["bio"],
    country: json["country"] == null ? null : json["country"],
    city: json["city"] == null ? null : json["city"],
    phone: json["phone"] == null ? null : json["phone"],
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    id: json["id"] == null ? null : json["id"],
    apiToken: json["api_token"] == null ? null : json["api_token"],
    netWorth: json["net_worth"] == null ? null : json["net_worth"],
  );

  Map<String, dynamic> toJson() => {
    "name": name == null ? null : name,
    "email": email == null ? null : email,
    "first_name": firstName == null ? null : firstName,
    "last_name": lastName == null ? null : lastName,
    "join_date": joinDate == null ? null : joinDate?.toIso8601String(),
    "bio": bio,
    "country": country == null ? null : country,
    "city": city == null ? null : city,
    "phone": phone == null ? null : phone,
    "updated_at": updatedAt == null ? null : updatedAt?.toIso8601String(),
    "created_at": createdAt == null ? null : createdAt?.toIso8601String(),
    "id": id == null ? null : id,
    "api_token": apiToken == null ? null : apiToken,
    "net_worth": netWorth == null ? null : netWorth,
  };
}