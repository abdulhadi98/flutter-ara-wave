import 'package:get_it/get_it.dart';
import 'package:wave_flutter/bloc/holdings_screen_bloc.dart';
import 'package:wave_flutter/bloc/news_screen_bloc.dart';
import 'package:wave_flutter/ui/animation/animated_logo_animation_manager.dart';
import 'package:wave_flutter/ui/controllers/holdings_screen_controller.dart';
import 'package:wave_flutter/ui/controllers/news_screen_controller.dart';
import 'package:wave_flutter/ui/controllers/root_screen_controller.dart';

abstract class NewsScreenDi {
  GetIt _getIt = GetIt.instance;
  late RootScreenController rootScreenController;
  late NewsScreenController uiController;
  late NewsScreenBloc newsBloc;

  initScreenDi(){
    rootScreenController = _getIt<RootScreenController>();
    uiController = _getIt<NewsScreenController>();
    newsBloc = _getIt<NewsScreenBloc>();
  }
}

