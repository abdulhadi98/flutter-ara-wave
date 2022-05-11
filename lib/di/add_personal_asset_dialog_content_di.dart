import 'package:get_it/get_it.dart';
import 'package:wave_flutter/bloc/add_personal_asset_dialog_bloc.dart';
import 'package:wave_flutter/ui/root/add_assets/personal/dialog_content/add_personal_asset_dialog_content_controller.dart';

abstract class AddPersonalAssetDialogContentDi {
  GetIt _getIt = GetIt.instance;
  late AddPersonalAssetDialogContentController uiController;
  late AddPersonalAssetDialogBloc addPersonalAssetBloc;

  initScreenDi(){
    addPersonalAssetBloc = _getIt<AddPersonalAssetDialogBloc>();
    uiController = _getIt<AddPersonalAssetDialogContentController>(param1: addPersonalAssetBloc);
  }
}

