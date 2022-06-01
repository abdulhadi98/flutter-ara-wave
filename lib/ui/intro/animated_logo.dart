import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:wave_flutter/di/animated_logo_di.dart';
import 'package:wave_flutter/helper/utils.dart';
import 'package:wave_flutter/ui/auth/login_screen.dart';
import 'package:wave_flutter/ui/common_widgets/base_statefull_widget.dart';
import 'dart:math' as math;

import '../../helper/routes_helper.dart';
import '../root/root_screen.dart';

class AnimatedLogo extends BaseStateFullWidget {
  @override
  _AnimatedLogoState createState() => _AnimatedLogoState();
}

class _AnimatedLogoState extends BaseStateFullWidgetState<AnimatedLogo>
    with AnimatedLogoScreenDi {
  @override
  void initState() {
    // WidgetsBinding.instance?.addPostFrameCallback(_afterLayout);
    super.initState();
    animate();

    initScreenDi();
    animationManager.init(tickerProvider: this);
  }

  _afterLayout(_) {
    animationManager.startEnterAnimation(context: context);
  }

  // late AnimationController animeController = AnimationController(duration: const Duration(milliseconds: 6000), vsync: tickerProvider);
  @override
  void dispose() {
    animationManager.dispose();
    super.dispose();
  }

  double x = 0;

  void animate() {
    Future.delayed(Duration(milliseconds: 1), () {
      // deleayed code here
      setState(() {
        x = 1;
      });
      print('delayed execution');
    }).then((value) {
      Future.delayed(Duration(milliseconds: 1700), () {
        setState(() {
          x = 0;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // return AnimatedBuilder(
    //   animation: animationManager.logoAnimationController,
    //   builder: (context, child) {

    return Center(
        child: Container(
      width: width * .35,
      height: width * .35,
      alignment: Alignment.center,
      child: AnimatedOpacity(
        // If the widget is visible, animate to 0.0 (invisible).
        // If the widget is hidden, animate to 1.0 (fully visible).
        opacity: x,
        onEnd: () {
          if (Utils.isLoggedUserExist()) {
            RoutesHelper.navigateReplacementTo(
                classToNavigate: RootScreen(), context: context);
          } else {
            RoutesHelper.navigateReplacementTo(
                classToNavigate: LoginScreen(), context: context);
          }
        },

        duration: const Duration(milliseconds: 2000),
        // The green box must be a child of the AnimatedOpacity widget.
        child: SvgPicture.asset(
          'assets/icons/ic_logo.svg',
          width: width * .125,
          height: width * .125,
        ),
      ),
      // Transform(
      //   alignment: Alignment.center,
      //   transform: Matrix4.rotationY(math.pi),
      //   child: Lottie.asset(
      //     'assets/animation/lottie_logo.json',
      //     fit: BoxFit.contain,
      //     width: width * .35,
      //     height: width * .35,
      //     // repeat: false,
      //     controller: animationManager.logoAnimationController,
      //     onLoaded: (composition) {
      //       // Configure the AnimationController with the duration of the
      //       // Lottie file and start the animation.
      //       animationManager.startEnterAnimation(
      //           context: context, duration: composition.duration);
      //     },
      //   ),
      // ),
    ));

    //
    // if (Utils.isLoggedUserExist()){
    // RoutesHelper.navigateReplacementTo(classToNavigate: RootScreen(), context: context);
    // } else {
    //   RoutesHelper.navigateReplacementTo(classToNavigate: LoginScreen(), context: context);
    // }

    ///// Transform.scale(
    // scale: animationManager.logoAnimation.value,
    // child: FadeTransition(
    //   opacity: animationManager.logoAnimation,
    //   child: Container(
    //     alignment: Alignment.center,
    //     width: width* .3,
    //     // height: containerWidth ,
    //     child: SvgPicture.asset(
    //         'assets/icons/ic_logo.svg',
    //         width: width* .3,
    //         height: width* .3,
    //         fit: BoxFit.contain,
    //     ),
    //   ),
    // ),
    // )
    // ;
    //   },
    // );
  }
}
