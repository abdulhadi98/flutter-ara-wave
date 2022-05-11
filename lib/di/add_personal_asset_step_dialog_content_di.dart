import 'package:get_it/get_it.dart';
import 'package:wave_flutter/bloc/add_personal_asset_dialog_bloc.dart';
import 'package:wave_flutter/bloc/add_personal_asset_step_dialog_content_bloc.dart';
import 'package:wave_flutter/models/add_personal_asset_holding_model.dart';
import 'package:wave_flutter/models/personal_asset_type_step.dart';
import 'package:wave_flutter/ui/root/add_assets/personal/dialog_content/add_personal_asset_dialog_content_controller.dart';
import 'package:wave_flutter/ui/root/add_assets/personal/steps/add_personal_asset_step_dialog_content_controller.dart';

abstract class AddPersonalAssetStepDialogContentDi {
  GetIt _getIt = GetIt.instance;
  late AddPersonalAssetStepDialogContentController uiController;
  late AddPersonalAssetStepDialogContentBloc addPersonalAssetStepDialogContentBloc;

  initScreenDi(
      List<PersonalAssetTypeStep> steps,
      Function(List<AddPersonalAssetOptionModel> chooseOptionList, List<String>? imageUrlList) onNextClicked,
      ){
    addPersonalAssetStepDialogContentBloc = _getIt<AddPersonalAssetStepDialogContentBloc>();
    uiController = _getIt<AddPersonalAssetStepDialogContentController>(
      param1: addPersonalAssetStepDialogContentBloc,
      param2: {
        "steps": steps,
        "onDoneCallback": onNextClicked,
      }
    );
  }
}

