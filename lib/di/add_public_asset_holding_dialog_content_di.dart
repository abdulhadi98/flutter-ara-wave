import 'package:get_it/get_it.dart';
import 'package:wave_flutter/bloc/add_public_asset_holding_bloc.dart';
import 'package:wave_flutter/ui/root/add_assets/public/add_public_asset_holding_dialog_content.dart';
import 'package:wave_flutter/ui/root/add_assets/public/add_public_asset_holding_dialog_content_controller.dart';
abstract class AddPublicAssetHoldingDialogContentDi {
  GetIt _getIt = GetIt.instance;
  late AddPublicAssetHoldingDialogContentController uiController;
  late AddPublicAssetHoldingBloc addPublicAssetHoldingBloc;

  initScreenDi(){
    addPublicAssetHoldingBloc = _getIt<AddPublicAssetHoldingBloc>();
    uiController = _getIt<AddPublicAssetHoldingDialogContentController>(param1: addPublicAssetHoldingBloc);
  }
}

