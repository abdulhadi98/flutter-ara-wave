class PublicAssetHoldingRequestBody {
  final String apiToken;
  final int assetId;

  PublicAssetHoldingRequestBody({
    required this.apiToken,
    required this.assetId,
  });

  Map<String, dynamic> toJson() => {
    "api_token": apiToken,
    "asset_id": assetId,
  };
}