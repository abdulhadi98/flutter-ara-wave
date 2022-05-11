import 'package:get_it/get_it.dart';
import 'package:wave_flutter/bloc/my_portfolio_screen_bloc.dart';
import 'package:wave_flutter/ui/animation/animated_logo_animation_manager.dart';
import 'package:wave_flutter/ui/controllers/root_screen_controller.dart';

abstract class MyPortfolioScreenDi {
  GetIt _getIt = GetIt.instance;
  late RootScreenController rootScreenController;
  late MyPortfolioScreenBloc myPortfolioScreenBloc;

  initScreenDi(){
    rootScreenController = _getIt<RootScreenController>();
    myPortfolioScreenBloc = _getIt<MyPortfolioScreenBloc>();
  }
}

