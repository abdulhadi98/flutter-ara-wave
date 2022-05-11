import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class SignUpScreenController{

  final emailTextEditingController = TextEditingController();
  final passwordTextEditingController = TextEditingController();
  final firstNameTextEditingController = TextEditingController();
  final lastNameTextEditingController = TextEditingController();
  final phoneTextEditingController = TextEditingController();

  final BehaviorSubject<bool> loadingSignUpController = BehaviorSubject<bool>.seeded(false);
  get loadingSignUpStream => loadingSignUpController.stream;
  bool getLoadingSignUpState() => loadingSignUpController.value;
  setLoadingSignUpState(bool state) => loadingSignUpController.sink.add(state);

  final BehaviorSubject<String?> selectedCountryController = BehaviorSubject<String?>();
  get selectedCountryStream => selectedCountryController.stream;
  String? getSelectedCountry() => selectedCountryController.valueOrNull;
  setSelectedCountry(String? country) => selectedCountryController.sink.add(country);

}