import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:wave_flutter/helper/routes_helper.dart';
import 'package:wave_flutter/helper/utils.dart';
import 'package:wave_flutter/ui/common_widgets/base_statefull_widget.dart';
import 'package:wave_flutter/ui/intro/animated_logo.dart';
import '../auth/login_screen.dart';
import 'package:wave_flutter/ui/root/root_screen.dart';


class SplashScreen extends BaseStateFullWidget{
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends BaseStateFullWidgetState<SplashScreen>{

  @override
  void initState() {
    // WidgetsBinding.instance?.addPostFrameCallback(_afterLayout);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        child: AnimatedLogo(),
      ),
    );
  }
}
