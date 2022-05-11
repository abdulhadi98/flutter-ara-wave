import 'package:flutter/material.dart';
import 'package:wave_flutter/helper/routes_helper.dart';
import 'package:wave_flutter/helper/utils.dart';
import 'package:wave_flutter/ui/animation/base_animation_manager.dart';
import '../auth/login_screen.dart';
import 'package:wave_flutter/ui/root/root_screen.dart';

class AnimatedLogoAnimationManager extends BaseAnimationManager {

  late AnimationController _logoAnimationController;
  AnimationController get logoAnimationController => _logoAnimationController;

  late Animation<double> _logoAnimation;
  Animation<double> get logoAnimation => _logoAnimation;

  @override
  init({@required tickerProvider}) {
    super.init(tickerProvider: tickerProvider);
  }

  @override
  initAnimations() {
    _logoAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(new CurvedAnimation(parent: _logoAnimationController, curve: Interval(0.0, 1.0, curve: Curves.decelerate)));
  }

  @override
  initControllers({required tickerProvider}) {
    _logoAnimationController = AnimationController(duration: const Duration(milliseconds: 6000), vsync: tickerProvider);
  }

  @override
  startEnterAnimation({context, duration}) {
    _logoAnimationController
      ..duration = duration
      ..forward();
    _logoAnimationController.addListener(() {
      if (_logoAnimationController.isCompleted) {
        if (Utils.isLoggedUserExist()){
          RoutesHelper.navigateReplacementTo(classToNavigate: RootScreen(), context: context);
        } else {
          RoutesHelper.navigateReplacementTo(classToNavigate: LoginScreen(), context: context);
        }
      }
    });
  }

  @override
  dispose() {
    _logoAnimationController.dispose();
  }

}