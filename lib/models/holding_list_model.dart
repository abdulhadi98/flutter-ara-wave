import 'dart:convert';

class HoldingModel {

  HoldingModel({
    required this.purchasedPrice,
    required this.quantity,
  });

  String purchasedPrice;
  int quantity;

  factory HoldingModel.fromJson(Map<String, dynamic> json) => HoldingModel(
      purchasedPrice: json["purchased_price"],
      quantity: json["quantity"],
  );

  Map<String, dynamic> toJson() => {
    "purchased_price": purchasedPrice,
    "quantity": quantity,
  };
}