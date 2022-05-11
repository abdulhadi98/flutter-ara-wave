import 'package:get_it/get_it.dart';
import 'package:wave_flutter/bloc/select_personal_asset_type_dialog_content_bloc.dart';
import 'package:wave_flutter/models/personal_asset_type.dart';
import 'package:wave_flutter/ui/root/add_assets/personal/steps/text/add_personal_asset_text_step_widget_controller.dart';

abstract class AddPersonalAssetTextStepWidgetDi {
  GetIt _getIt = GetIt.instance;
  late AddPersonalAssetTextStepWidgetController uiController;

  initScreenDi(List<PersonalAssetTypeOptionModel> options){
    uiController = _getIt<AddPersonalAssetTextStepWidgetController>(param1: options);
  }
}

