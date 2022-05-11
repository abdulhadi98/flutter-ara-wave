import 'package:wave_flutter/models/price_history_model.dart';

mixin IPriceHistoryBloc {
  addPriceHistory({
    required PriceHistoryModel priceHistoryModel,
    required Function() onData,
    required Function(String message) onError,
  });
}