import 'package:get_it/get_it.dart';
import 'package:wave_flutter/ui/animation/animated_logo_animation_manager.dart';
import 'package:wave_flutter/ui/controllers/root_screen_controller.dart';

abstract class RootScreenDi {
  GetIt _getIt = GetIt.instance;
  late RootScreenController uiController;

  initScreenDi(){
    uiController = _getIt<RootScreenController>();
  }
}

