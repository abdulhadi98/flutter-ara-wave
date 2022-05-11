
import 'holding_list_model.dart';

class BasePrivateAssetHoldingModel extends HoldingModel {
  BasePrivateAssetHoldingModel({
    required purchasedPrice,
    required quantity,
    required this.headquarterCity,
    required this.country,
    required this.investedCapital,
    required this.shareClass,
    required this.companySharesOutstanding,
    required this.privateAssetId,
  }): super(
    purchasedPrice: purchasedPrice,
    quantity: quantity,
  );
  String headquarterCity;
  String country;
  String investedCapital;
  String shareClass;
  String companySharesOutstanding;
  int privateAssetId;
}

class AddPrivateAssetHoldingModel extends BasePrivateAssetHoldingModel {

  AddPrivateAssetHoldingModel({
    required this.apiToken,
    required this.source,
    required this.purchasedAt,
    required purchasedPrice,
    required quantity,
    required assetId,
    required companySharesOutstanding,
    required country,
    required headquarterCity,
    required investedCapital,
    required shareClass,
  }): super(
    purchasedPrice: purchasedPrice,
    quantity: quantity,
    companySharesOutstanding: companySharesOutstanding,
    country: country,
    headquarterCity: headquarterCity,
    investedCapital: investedCapital,
    privateAssetId: assetId,
    shareClass: shareClass,
  );

  String apiToken;
  String source;
  String purchasedAt;

  Map<String, dynamic> toJson() => {
    "api_token": apiToken,
    "asset_id": privateAssetId,
    "purchased_price": purchasedPrice,
    "purchased_at": purchasedAt,
    "quantity": quantity,
    "source": source,
    "headquarter_city": headquarterCity,
    "country": country,
    "invested_capital": investedCapital,
    "share_class": shareClass,
    "shares_outstanding": companySharesOutstanding,
  };
}