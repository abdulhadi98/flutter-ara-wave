import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wave_flutter/bloc/authentication_bloc.dart';
import 'package:wave_flutter/bloc/home_screen_bloc.dart';
import 'package:wave_flutter/helper/enums.dart';
import 'package:wave_flutter/main.dart';

class HomeScreenController {

  final HomeScreenBloc _homeScreenBloc;
  final AuthenticationBloc _authBloc;
  HomeScreenController({required homeScreenBloc, required authBloc,}):
        _homeScreenBloc = homeScreenBloc, _authBloc = authBloc;

  logout(context) async {
    _authBloc.logout();
    await _homeScreenBloc.deleteCurrentUserData();
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => MyApp()), (Route<dynamic> route) => false);
  }

}