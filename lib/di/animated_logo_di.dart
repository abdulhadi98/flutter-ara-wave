import 'package:get_it/get_it.dart';
import 'package:wave_flutter/ui/animation/animated_logo_animation_manager.dart';

abstract class AnimatedLogoScreenDi {
  GetIt _getIt = GetIt.instance;
  late AnimatedLogoAnimationManager animationManager;

  initScreenDi(){
    animationManager = _getIt<AnimatedLogoAnimationManager>();
  }
}

