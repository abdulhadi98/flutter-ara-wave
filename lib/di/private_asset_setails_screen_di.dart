import 'package:get_it/get_it.dart';
import 'package:wave_flutter/bloc/holdings_screen_bloc.dart';
import 'package:wave_flutter/bloc/private_asset_details_screen_bloc.dart';
import 'package:wave_flutter/ui/animation/animated_logo_animation_manager.dart';
import 'package:wave_flutter/ui/controllers/holdings_screen_controller.dart';
import 'package:wave_flutter/ui/controllers/private_asset_details_screen_controller.dart';
import 'package:wave_flutter/ui/controllers/root_screen_controller.dart';

abstract class PrivateAssetDetailsScreenDi {
  GetIt _getIt = GetIt.instance;
  late RootScreenController rootScreenController;
  late PrivateAssetDetailsScreenController uiController;
  late PrivateAssetDetailsScreenBloc privateAssetDetailsScreenBloc;

  initScreenDi(){
    rootScreenController = _getIt<RootScreenController>();
    privateAssetDetailsScreenBloc = _getIt<PrivateAssetDetailsScreenBloc>();
    uiController = _getIt<PrivateAssetDetailsScreenController>(param1: privateAssetDetailsScreenBloc);
  }
}

