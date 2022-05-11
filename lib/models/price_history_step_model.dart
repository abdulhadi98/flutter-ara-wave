import 'dart:convert';
import 'package:wave_flutter/models/price_history_model.dart';

class PriceHistoryStepModel {
  PriceHistoryStepModel({
    required this.yearPriceList,
  });

  List<YearPrice> yearPriceList;

  @override
  String toString() {
    return yearPriceListToJson(yearPriceList);
  }
}