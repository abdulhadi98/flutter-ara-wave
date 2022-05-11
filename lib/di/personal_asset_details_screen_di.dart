import 'package:get_it/get_it.dart';
import 'package:wave_flutter/bloc/holdings_screen_bloc.dart';
import 'package:wave_flutter/ui/animation/animated_logo_animation_manager.dart';
import 'package:wave_flutter/ui/controllers/holdings_screen_controller.dart';
import 'package:wave_flutter/ui/controllers/personal_asset_details_controllers.dart';
import 'package:wave_flutter/ui/controllers/private_asset_details_screen_controller.dart';
import 'package:wave_flutter/ui/controllers/root_screen_controller.dart';

abstract class PersonalAssetDetailsScreenDi {
  GetIt _getIt = GetIt.instance;
  late RootScreenController rootScreenController;
  late PersonalAssetDetailsScreenController uiController;
  // late HoldingsScreenBloc holdingsBloc;

  initScreenDi(){
    rootScreenController = _getIt<RootScreenController>();
    uiController = _getIt<PersonalAssetDetailsScreenController>();
    // holdingsBloc = _getIt<HoldingsScreenBloc>();
  }
}

