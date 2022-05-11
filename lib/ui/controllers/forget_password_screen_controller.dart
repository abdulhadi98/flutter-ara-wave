import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wave_flutter/bloc/authentication_bloc.dart';
import 'package:wave_flutter/helper/utils.dart';

class ForgetPasswordScreenController {

  final AuthenticationBloc _authenticationBloc;
  ForgetPasswordScreenController({required authenticationBloc, }):
        _authenticationBloc = authenticationBloc;

  final emailTextEditingController = TextEditingController();

  final BehaviorSubject<bool> loadingResetPasswordController = BehaviorSubject<bool>.seeded(false);
  get loadingResetPasswordStream => loadingResetPasswordController.stream;
  bool getLoadingResetPasswordState() => loadingResetPasswordController.value;
  setLoadingResetPasswordState(bool state) => loadingResetPasswordController.sink.add(state);

  onResetPasswordClicked(context) {
    if(_validateInputs()) {
      setLoadingResetPasswordState(true);
      _authenticationBloc.forgetPassword(
        email: emailTextEditingController.text,
        onData: () => _onResetPasswordSucceed(context),
        onError: (message) => _onResetPasswordFailed(context, message),
      );
    }
  }

  _onResetPasswordSucceed(context) {
    setLoadingResetPasswordState(false);
    Utils.showToast('Reset password has done successfully');
    Navigator.of(context).pop();
  }

  _onResetPasswordFailed(context, message) {
    setLoadingResetPasswordState(false);
    Utils.showTranslatedToast(context, message);
  }

  bool _validateInputs(){
    if(emailTextEditingController.text.isNotEmpty) return true;

    Utils.showToast('Please enter your email');
    return false;
  }

  disposeStreams() {
    loadingResetPasswordController.close();
  }
}