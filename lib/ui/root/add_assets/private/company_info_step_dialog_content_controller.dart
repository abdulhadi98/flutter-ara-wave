import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wave_flutter/models/company_info_step_model.dart';

import '../base_add_asset_step_controller.dart';

class CompanyInfoStepDialogContentController extends BaseAddAssetStepController {
  final companyNameTextEditingController = TextEditingController();
  final headquarterCityTextEditingController = TextEditingController();
  final countryTextEditingController = TextEditingController();

  onCompanyNameTextFieldChanged(String value) {
    updateValidationState();
  }

  onHeadquarterCityTextFieldChanged(String value) {
    updateValidationState();
  }

  onCountryTextFieldChanged(String value) {
    updateValidationState();
  }

  onInitialInvestmentYearSelected(DateTime? dateTime) {
    setInitialInvestmentYear(dateTime?.year);
    updateValidationState();
  }

  final BehaviorSubject<int?> _initialInvestmentYearController = BehaviorSubject<int?>();
  get initialInvestmentYearStream => _initialInvestmentYearController.stream;
  int? getInitialInvestmentYear() => _initialInvestmentYearController.valueOrNull;
  setInitialInvestmentYear(int? year) => _initialInvestmentYearController.sink.add(year);

  bool _validateCompanyNameValue() {
    return companyNameTextEditingController.text.isNotEmpty;
  }

  bool _validateInitialInvestmentYearValue() {
    return getInitialInvestmentYear() != null;
  }

  bool _validateHeadquarterCityValue() {
    return headquarterCityTextEditingController.text.isNotEmpty;
  }

  bool _validateCountryValue() {
    return countryTextEditingController.text.isNotEmpty;
  }

  onNextClicked(
      {required Function(CompanyInfoStepModel companyInfo) onDoneCallback}) {
    CompanyInfoStepModel companyInfoStepModel = CompanyInfoStepModel(
      name: companyNameTextEditingController.text,
      headquarterCity: headquarterCityTextEditingController.text,
      initialInvestmentYear: getInitialInvestmentYear()!,
      country: countryTextEditingController.text,
    );

    onDoneCallback(companyInfoStepModel);
  }

  @override
  dispose() {
    _initialInvestmentYearController.close();
    companyNameTextEditingController.dispose();
    headquarterCityTextEditingController.dispose();
    countryTextEditingController.dispose();
  }

  @override
  bool validateInputs() {
    return _validateCompanyNameValue() &&
        _validateInitialInvestmentYearValue() &&
        _validateHeadquarterCityValue() &&
        _validateCountryValue();
  }
}
