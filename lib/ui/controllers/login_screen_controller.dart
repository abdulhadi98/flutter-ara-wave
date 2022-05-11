import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class LoginScreenController{

  final emailTextEditingController = TextEditingController();
  final passwordTextEditingController = TextEditingController();

  final BehaviorSubject<bool> loadingLoginController = BehaviorSubject<bool>.seeded(false);
  get loadingLoginStream => loadingLoginController.stream;
  bool getLoadingLoginState() => loadingLoginController.value;
  setLoadingLoginState(bool state) => loadingLoginController.sink.add(state);

}