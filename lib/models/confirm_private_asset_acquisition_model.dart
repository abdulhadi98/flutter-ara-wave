class ConfirmPrivateAssetAcquisitionModel {

  final String apiToken;
  final int assetId;
  final String passcode;

  ConfirmPrivateAssetAcquisitionModel({
    required this.apiToken,
    required this.assetId,
    required this.passcode,
  });

  factory ConfirmPrivateAssetAcquisitionModel.fromJson(Map<String, dynamic> json) => ConfirmPrivateAssetAcquisitionModel(
    apiToken: json["api_token"],
    assetId: json["asset_id"],
    passcode: json["passcode"],
  );

  Map<String, dynamic> toJson() => {
    "api_token": apiToken,
    "asset_id": assetId,
    "passcode": passcode,
  };
}