import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wave_flutter/bloc/authentication_bloc.dart';
import 'package:wave_flutter/helper/utils.dart';

class ResetPasswordScreenController {

  final AuthenticationBloc _authenticationBloc;
  ResetPasswordScreenController({required authenticationBloc, }):
        _authenticationBloc = authenticationBloc;

  final emailTextEditingController = TextEditingController();
  final oldPasswordTextEditingController = TextEditingController();
  final newPasswordTextEditingController = TextEditingController();
  final confirmNewPasswordTextEditingController = TextEditingController();

  final BehaviorSubject<bool> loadingResetPasswordController = BehaviorSubject<bool>.seeded(false);
  get loadingResetPasswordStream => loadingResetPasswordController.stream;
  bool getLoadingResetPasswordState() => loadingResetPasswordController.value;
  setLoadingResetPasswordState(bool state) => loadingResetPasswordController.sink.add(state);

  onResetPasswordClicked(context) {
    if(_validateInputs()) {
      setLoadingResetPasswordState(true);
      _authenticationBloc.resetPassword(
        email: emailTextEditingController.text,
        oldPassword: oldPasswordTextEditingController.text,
        newPassword: newPasswordTextEditingController.text,
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
    if(emailTextEditingController.text.isEmpty) {
      Utils.showToast('Please enter your email');
      return false;
    }

    if(oldPasswordTextEditingController.text.isEmpty) {
      Utils.showToast('Please enter your old password');
      return false;
    }

    if((newPasswordTextEditingController.text.isEmpty && confirmNewPasswordTextEditingController.text.isEmpty)
        || newPasswordTextEditingController.text != confirmNewPasswordTextEditingController.text) {
      Utils.showToast('Your passwords are\'nt matched');
      return false;
    }

    return true;
  }

  disposeStreams() {
    loadingResetPasswordController.close();
  }
}