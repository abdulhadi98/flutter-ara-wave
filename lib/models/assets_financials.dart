
import 'package:wave_flutter/helper/utils.dart';

class AssetsFinancials {

  AssetsFinancials({
    required this.assetNetworth,
    required this.assetGrowth,
});
  double assetNetworth;
  String assetGrowth;

  String getAssetGrowthRounded() {
    bool isNegativeNum = assetGrowth.startsWith('-');
    String num = assetGrowth.substring(isNegativeNum ? 1 : 0, assetGrowth.length-1);
    String roundedNum = Utils.getFormattedNum(double.parse(num));
    return isNegativeNum ? '-$roundedNum%' : '+$roundedNum%';
  }

  String get formattedNetWorth => Utils.getFormattedNum(assetNetworth);


  factory AssetsFinancials.fromJson(Map<String, dynamic> json) => AssetsFinancials(
    assetNetworth: json["asset_networth"].toDouble(),
    assetGrowth: json["asset_growth"],
  );

  Map<String, dynamic> toJson() => {
    "asset_networth": assetNetworth,
    "asset_growth": assetGrowth,
  };
}