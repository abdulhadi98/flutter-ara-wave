import 'package:get_it/get_it.dart';
import 'package:wave_flutter/bloc/holdings_screen_bloc.dart';
import 'package:wave_flutter/bloc/private_asset_details_screen_bloc.dart';
import 'package:wave_flutter/ui/animation/animated_logo_animation_manager.dart';
import 'package:wave_flutter/ui/controllers/holdings_screen_controller.dart';
import 'package:wave_flutter/ui/controllers/private_asset_details_screen_controller.dart';
import 'package:wave_flutter/ui/controllers/root_screen_controller.dart';

import '../bloc/add_public_asset_holding_bloc.dart';
import '../ui/controllers/home_screen_controller.dart';
import '../ui/root/add_assets/public/add_public_asset_holding_dialog_content_controller.dart';

abstract class PublicAssetDetailsScreenDi {
  GetIt _getIt = GetIt.instance;
  late RootScreenController rootScreenController;
  late PrivateAssetDetailsScreenController uiiController;
  late PrivateAssetDetailsScreenBloc privateAssetDetailsScreenBloc;
  late HoldingsScreenBloc holdingsBloc;
  late HoldingsScreenController uiController;
  late AddPublicAssetHoldingDialogContentController duiController;
  late AddPublicAssetHoldingBloc addPublicAssetHoldingBloc;

  dinitScreenDi() {
    addPublicAssetHoldingBloc = _getIt<AddPublicAssetHoldingBloc>();
    duiController = _getIt<AddPublicAssetHoldingDialogContentController>(
      param1: addPublicAssetHoldingBloc,
    );
  }

  initScreenDi() {
    holdingsBloc = _getIt<HoldingsScreenBloc>();
    rootScreenController = _getIt<RootScreenController>();
    privateAssetDetailsScreenBloc = _getIt<PrivateAssetDetailsScreenBloc>();
    uiiController = _getIt<PrivateAssetDetailsScreenController>(
        param1: privateAssetDetailsScreenBloc);
    uiController = _getIt<HoldingsScreenController>(param1: holdingsBloc);
  }
}
