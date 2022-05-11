import 'package:get_it/get_it.dart';
import 'package:wave_flutter/ui/root/add_assets/personal/item_selector/add_personal_asset_selector_widget_controller.dart';

abstract class AddPersonalAssetSelectorWidgetDi<T> {
  GetIt _getIt = GetIt.instance;
  late AddPersonalAssetSelectorWidgetController<T> uiController;

  initScreenDi(){
    uiController = _getIt<AddPersonalAssetSelectorWidgetController<T>>();
  }
}

