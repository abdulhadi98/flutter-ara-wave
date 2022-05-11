class AddPublicAssetHoldingModel {
  String apiToken;
  String assetId;
  String quantity;
  String purchasedAt;
  String verified;
  String stockExchange;

  AddPublicAssetHoldingModel({
    required this.apiToken,
    required this.assetId,
    required this.quantity,
    required this.purchasedAt,
    required this.verified,
    required this.stockExchange,
  });

  Map<String, dynamic> toJson() => {
    "api_token": apiToken,
    "asset_id": assetId,
    "quantity": quantity,
    "purchased_at": purchasedAt,
    "verified": verified,
    "stock_exchange": stockExchange,
  };
}