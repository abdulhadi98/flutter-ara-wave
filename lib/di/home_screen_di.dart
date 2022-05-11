import 'package:get_it/get_it.dart';
import 'package:wave_flutter/bloc/authentication_bloc.dart';
import 'package:wave_flutter/bloc/holdings_screen_bloc.dart';
import 'package:wave_flutter/bloc/home_screen_bloc.dart';
import 'package:wave_flutter/ui/animation/animated_logo_animation_manager.dart';
import 'package:wave_flutter/ui/controllers/home_screen_controller.dart';
import 'package:wave_flutter/ui/controllers/root_screen_controller.dart';

abstract class HomeScreenDi {
  GetIt _getIt = GetIt.instance;
  late HomeScreenController uiController;
  late RootScreenController rootScreenController;
  late HomeScreenBloc homeScreenBloc;
  late AuthenticationBloc authBloc;
  late HoldingsScreenBloc holdingsBloc;

  initScreenDi(){
    homeScreenBloc = _getIt<HomeScreenBloc>();
    authBloc = _getIt<AuthenticationBloc>();
    holdingsBloc = _getIt<HoldingsScreenBloc>();
    rootScreenController = _getIt<RootScreenController>();
    uiController = _getIt<HomeScreenController>(param1: homeScreenBloc, param2: authBloc,);
  }
}

