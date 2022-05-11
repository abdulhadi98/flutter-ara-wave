import 'package:get_it/get_it.dart';
import 'package:wave_flutter/bloc/holdings_screen_bloc.dart';
import 'package:wave_flutter/ui/animation/animated_logo_animation_manager.dart';
import 'package:wave_flutter/ui/controllers/holdings_screen_controller.dart';
import 'package:wave_flutter/ui/controllers/root_screen_controller.dart';

abstract class HoldingsScreenDi {
  GetIt _getIt = GetIt.instance;
  late RootScreenController rootScreenController;
  late HoldingsScreenController uiController;
  late HoldingsScreenBloc holdingsBloc;

  initScreenDi(){
    rootScreenController = _getIt<RootScreenController>();
    holdingsBloc = _getIt<HoldingsScreenBloc>();
    uiController = _getIt<HoldingsScreenController>(param1: holdingsBloc);
  }
}

