
import 'dart:convert';

class BaseAddPrivateAssetManuallyModel {
  String? companyName;
  String? headquarterCity;
  String? country;
  String? yearOfInvestment;
  String? investedCapital;
  String? sharesPurchased;
  String? shareClass;
  String? companySharesOutstanding;
  String? marketValue;

  BaseAddPrivateAssetManuallyModel({
    this.companyName,
    this.headquarterCity,
    this.country,
    this.yearOfInvestment,
    this.investedCapital,
    this.sharesPurchased,
    this.shareClass,
    this.companySharesOutstanding,
    this.marketValue,
  });
}

class AddPrivateAssetManuallyModel extends BaseAddPrivateAssetManuallyModel {
  String apiToken;

  AddPrivateAssetManuallyModel({
    required this.apiToken,
    required String companyName,
    required String headquarterCity,
    required String country,
    required String yearOfInvestment,
    required String investedCapital,
    required String sharesPurchased,
    required String shareClass,
    required String companySharesOutstanding,
    required String marketValue,
  }): super(
    companyName: companyName,
    headquarterCity: headquarterCity,
    country: country,
    yearOfInvestment: yearOfInvestment,
    investedCapital: investedCapital,
    sharesPurchased: sharesPurchased,
    shareClass: shareClass,
    companySharesOutstanding: companySharesOutstanding,
    marketValue: marketValue,
  );

  Map<String, dynamic> toJson() => {
    "api_token": apiToken,
    "company_name": companyName,
    "headquarter_city": headquarterCity,
    "coutry": country,
    "year_of_investment": yearOfInvestment,
    "invested_capital": investedCapital,
    "shares_purchased": sharesPurchased,
    "share_class": shareClass,
    "company_shares_outstanding": companySharesOutstanding,
    "market_value": marketValue,
  };
}


// PrivateAssetManuallyModel privateAssetManuallyListFromJson(String str) => PrivateAssetManuallyModel.fromJson(json.decode(str));
// String privateAssetManuallyListToJson(PrivateAssetManuallyModel data) => json.encode(data.toJson());

class PrivateAssetManuallyModel extends BaseAddPrivateAssetManuallyModel {
  PrivateAssetManuallyModel({
    this.id,
    this.userId,
    this.privateAssetManuallyModelMarketValue,
    this.purchasedPrice,
    this.createdAt,
    this.updatedAt,
    this.totalBalance,
    this.profit,
    this.profitPercentage,
    this.returnOnInvestment,
    this.marketCapitalization,
    companySharesOutstanding,
    companyName,
    headquarterCity,
    country,
    yearOfInvestment,
    investedCapital,
    sharesPurchased,
    shareClass,
    marketValue,
  });

  int? id;
  int? userId;
  String? privateAssetManuallyModelMarketValue;
  double? purchasedPrice;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? totalBalance;
  int? profit;
  String? profitPercentage;
  String? returnOnInvestment;
  int? marketCapitalization;

  factory PrivateAssetManuallyModel.fromJson(Map<String, dynamic> json) => PrivateAssetManuallyModel(
    id: json["id"] == null ? null : json["id"],
    userId: json["user_id"] == null ? null : json["user_id"],
    companyName: json["company_name"] == null ? null : json["company_name"],
    headquarterCity: json["headquarter_city"] == null ? null : json["headquarter_city"],
    country: json["coutry"] == null ? null : json["coutry"],
    yearOfInvestment: json["year_of_investment"] == null ? null : json["year_of_investment"],
    investedCapital: json["invested_capital"] == null ? null : json["invested_capital"],
    sharesPurchased: json["shares_purchased"] == null ? null : json["shares_purchased"],
    shareClass: json["share_class"] == null ? null : json["share_class"],
    companySharesOutstanding: json["shares_outstanding"] == null ? null : json["shares_outstanding"],
    // privateAssetManuallyModelMarketValue: json["market_value"] == null ? null : json["market_value"],
    purchasedPrice: json["purchased_price"] == null ? null : double.parse(json["purchased_price"].toString()),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    // totalBalance: json["totalBalance"] == null ? null : json["totalBalance"],
    // profit: json["profit"] == null ? null : json["profit"],
    // profitPercentage: json["profitPercentage"] == null ? null : json["profitPercentage"],
    // returnOnInvestment: json["returnOnInvestment"] == null ? null : json["returnOnInvestment"],
    // marketCapitalization: json["marketCapitalization"] == null ? null : json["marketCapitalization"],
    marketValue: json["marketValue"] == null ? null : json["marketValue"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "user_id": userId == null ? null : userId,
    "company_name": companyName == null ? null : companyName,
    "headquarter_city": headquarterCity == null ? null : headquarterCity,
    "coutry": country == null ? null : country,
    "year_of_investment": yearOfInvestment == null ? null : yearOfInvestment,
    "invested_capital": investedCapital == null ? null : investedCapital,
    "shares_purchased": sharesPurchased == null ? null : sharesPurchased,
    "share_class": shareClass == null ? null : shareClass,
    "shares_outstanding": companySharesOutstanding == null ? null : companySharesOutstanding,
    "market_value": privateAssetManuallyModelMarketValue == null ? null : privateAssetManuallyModelMarketValue,
    "purchased_price": purchasedPrice == null ? null : purchasedPrice,
    "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
    "totalBalance": totalBalance == null ? null : totalBalance,
    "profit": profit == null ? null : profit,
    "profitPercentage": profitPercentage == null ? null : profitPercentage,
    "returnOnInvestment": returnOnInvestment == null ? null : returnOnInvestment,
    "marketCapitalization": marketCapitalization == null ? null : marketCapitalization,
    "marketValue": marketValue == null ? null : marketValue,
  };
}


