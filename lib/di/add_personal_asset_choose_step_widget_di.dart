import 'package:get_it/get_it.dart';
import 'package:wave_flutter/bloc/add_personal_asset_choose_step_widget_bloc.dart';
import 'package:wave_flutter/ui/root/add_assets/personal/steps/choose/add_personal_asset_choose_step_widget_controller.dart';


abstract class AddPersonalAssetChooseStepWidgetDi {
  GetIt _getIt = GetIt.instance;
  late AddPersonalAssetChooseStepWidgetController uiController;
  late AddPersonalAssetChooseStepWidgetBloc addPersonalAssetChooseStepBloc;

  initScreenDi() {
    addPersonalAssetChooseStepBloc = _getIt<AddPersonalAssetChooseStepWidgetBloc>();
    uiController = _getIt<AddPersonalAssetChooseStepWidgetController>(param1: addPersonalAssetChooseStepBloc);
  }
}

