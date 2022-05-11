import 'dart:convert';

import 'package:wave_flutter/helper/utils.dart';

class UserPortfolioFinancials {
  UserPortfolioFinancials({
    this.profitPercentage,
    this.invested,
    this.netWorth,
    this.profit,
  });

  double? profitPercentage;
  double? invested;
  double? netWorth;
  double? profit;

  String get formattedNetWorth => Utils.getFormattedNum(netWorth);
  String get formattedInvested => Utils.getFormattedNum(invested);
  String get formattedProfit => Utils.getFormattedNum(profit);
  String get formattedProfitPercentage => ((profitPercentage?.toInt()??0) <= 0 ? '' : '+') + "${Utils.getFormattedNum(profitPercentage)}%";

  factory UserPortfolioFinancials.fromJson(Map<String, dynamic> json) => UserPortfolioFinancials(
    profitPercentage: json["profit_percentage"] == null ? null : json["profit_percentage"].toDouble(),
    invested: json["invested"] == null ? null : json["invested"].toDouble(),
    netWorth: json["netWorth"] == null ? null : json["netWorth"].toDouble(),
    profit: json["profit"] == null ? null : json["profit"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "profit_percentage": profitPercentage == null ? null : profitPercentage,
    "invested": invested == null ? null : invested,
    "netWorth": netWorth == null ? null : netWorth,
    "profit": profit == null ? null : profit,
  };
}
