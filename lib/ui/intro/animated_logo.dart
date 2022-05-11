import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:wave_flutter/di/animated_logo_di.dart';
import 'package:wave_flutter/helper/utils.dart';
import 'package:wave_flutter/ui/common_widgets/base_statefull_widget.dart';
import 'dart:math' as math;

class AnimatedLogo extends BaseStateFullWidget {
  @override
  _AnimatedLogoState createState() => _AnimatedLogoState();
}

class _AnimatedLogoState extends BaseStateFullWidgetState<AnimatedLogo> with AnimatedLogoScreenDi{

  @override
  void initState() {
    // WidgetsBinding.instance?.addPostFrameCallback(_afterLayout);
    super.initState();

    initScreenDi();
    animationManager.init(tickerProvider: this);
  }

  _afterLayout(_){
    animationManager.startEnterAnimation(context: context);
  }

  @override
  void dispose() {
    animationManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // return AnimatedBuilder(
    //   animation: animationManager.logoAnimationController,
    //   builder: (context, child) {
        return Container(
          width: width* .35,
          height: width* .35,
          alignment: Alignment.center,
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(math.pi),
            child: Lottie.asset(
                'assets/animation/lottie_logo.json',
                fit: BoxFit.contain,
                width: width* .35,
                height: width* .35,
                // repeat: false,
                controller: animationManager.logoAnimationController,
              onLoaded: (composition) {
                // Configure the AnimationController with the duration of the
                // Lottie file and start the animation.
                animationManager.startEnterAnimation(context: context, duration: composition.duration);
              },
            ),
          ),
        );
          // Transform.scale(
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