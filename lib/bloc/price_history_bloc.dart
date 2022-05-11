import 'package:wave_flutter/models/price_history_model.dart';
import 'package:wave_flutter/services/api_provider.dart';
import 'local_user_bloc.dart';
import 'mixin/IPriceHistoryBloc.dart';

class PriceHistoryBloc with IPriceHistoryBloc {
  final ApiProvider _apiProvider;
  final LocalUserBloc _localUserBloc;

  PriceHistoryBloc({required apiProvider, required localUserBloc})
      : _apiProvider = apiProvider, _localUserBloc = localUserBloc;

  static const String LOG_TAG = 'PriceHistoryBloc';

  String? get currentUserApiToken => _localUserBloc.currentUser?.apiToken;

  @override
  addPriceHistory({
    required PriceHistoryModel priceHistoryModel,
    required Function() onData,
    required Function(String message) onError,
  }) async {
    try {
      final response = await _apiProvider.addAssetPriceHistoryHolding(priceHistoryModel: priceHistoryModel);
      // PriceHistoryModel holding = PriceHistoryModel.fromJson(response,);
      onData();
    } on FormatException catch (error) {
      print('$LOG_TAG: addPriceHistory() FormatException: ${error.message}');
      onError(error.message);
    } catch (error) {
      print('$LOG_TAG: addPriceHistory() Exception: ${error.toString()}');
      onError('something_went_wrong');
    }
  }

}