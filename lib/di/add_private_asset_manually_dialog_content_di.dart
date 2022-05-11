import 'package:get_it/get_it.dart';
import 'package:wave_flutter/bloc/AddPrivateAssetManuallyBloc.dart';
import 'package:wave_flutter/ui/root/add_assets/private/manually/add_private_asset_manually_dialog_content_controller.dart';

abstract class AddPrivateAssetManuallyDialogContentDi {
  GetIt _getIt = GetIt.instance;
  late AddPrivateAssetManuallyDialogContentController uiController;
  late AddPrivateAssetManuallyBloc addPrivateAssetManuallyBloc;

  initScreenDi(){
    addPrivateAssetManuallyBloc = _getIt<AddPrivateAssetManuallyBloc>();
    uiController = _getIt<AddPrivateAssetManuallyDialogContentController>(param1: addPrivateAssetManuallyBloc);
  }
}

