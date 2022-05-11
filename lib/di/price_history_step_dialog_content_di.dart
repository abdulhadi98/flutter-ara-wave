import 'package:get_it/get_it.dart';
import 'package:wave_flutter/bloc/price_history_bloc.dart';
import 'package:wave_flutter/ui/root/add_assets/price_history/price_history_step_dialog_content_controller.dart';

abstract class PriceHistoryStepDialogContentDi {
  GetIt _getIt = GetIt.instance;
  late PriceHistoryStepDialogContentController uiController;
  late PriceHistoryBloc priceHistoryBloc;

  initScreenDi({required assetId, required assetType,}) {
    priceHistoryBloc = _getIt<PriceHistoryBloc>();
    uiController = _getIt<PriceHistoryStepDialogContentController>(
      param1: {
        'asset_type': assetType,
        'asset_id': assetId,
      },
      param2: priceHistoryBloc,
    );
  }
}

