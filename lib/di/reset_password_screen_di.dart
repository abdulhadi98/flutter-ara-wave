import 'package:get_it/get_it.dart';
import 'package:wave_flutter/bloc/home_screen_bloc.dart';
import 'package:wave_flutter/bloc/authentication_bloc.dart';
import 'package:wave_flutter/ui/animation/animated_logo_animation_manager.dart';
import 'package:wave_flutter/ui/controllers/home_screen_controller.dart';
import 'package:wave_flutter/ui/controllers/login_screen_controller.dart';
import 'package:wave_flutter/ui/controllers/forget_password_screen_controller.dart';
import 'package:wave_flutter/ui/controllers/reset_password_screen_controller.dart';
import 'package:wave_flutter/ui/controllers/root_screen_controller.dart';
import 'package:wave_flutter/ui/controllers/sign_up_screen_controller.dart';

abstract class ResetPasswordScreenDi {
  GetIt _getIt = GetIt.instance;
  late ResetPasswordScreenController uiController;
  late AuthenticationBloc authBloc;

  initScreenDi(){
    authBloc = _getIt<AuthenticationBloc>();
    uiController = _getIt<ResetPasswordScreenController>(param1: authBloc,);
  }
}

