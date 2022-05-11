import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wave_flutter/models/company_shares_step_model.dart';
import '../base_add_asset_step_controller.dart';

class CompanySharesStepDialogContentController extends BaseAddAssetStepController {
  final investmentCapitalTextEditingController = TextEditingController();
  final sharedPurchasesTextEditingController = TextEditingController();
  final sharesClassTextEditingController = TextEditingController();
  final companySharesOutstandingTextEditingController = TextEditingController();
  final marketValueTextEditingController = TextEditingController();

  onInvestmentCapitalTextFieldChanged(String value) {
    updateValidationState();
  }

  onSharedPurchasesTextFieldChanged(String value) {
    updateValidationState();
  }

  onSharesClassTextFieldChanged(String value) {
    updateValidationState();
  }

  onCompanySharesOutstandingTextFieldChanged(String value) {
    updateValidationState();
  }

  onMarketValueTextFieldChanged(String value) {
    updateValidationState();
  }

  bool _validateInvestmentCapitalValue() {
    return investmentCapitalTextEditingController.text.isNotEmpty;
  }

  bool _validateSharedPurchasesValue() {
    return sharedPurchasesTextEditingController.text.isNotEmpty;
  }

  bool _validateSharesClassValue() {
    return sharesClassTextEditingController.text.isNotEmpty;
  }

  bool _validateCompanySharesOutstandingValue() {
    return companySharesOutstandingTextEditingController.text.isNotEmpty;
  }

  bool _validateMarketValue() {
    return marketValueTextEditingController.text.isNotEmpty;
  }

  onPriceHistoryButtonClicked({required Function(CompanySharesStepModel sharesStepModel) onDoneCallback}) {
    CompanySharesStepModel companyInfoStepModel = CompanySharesStepModel(
      investmentCapital:investmentCapitalTextEditingController.text,
      sharesPurchased: sharedPurchasesTextEditingController.text,
      sharesClass: sharesClassTextEditingController.text,
      companySharesOutstanding: companySharesOutstandingTextEditingController.text,
      marketValue: int.parse(marketValueTextEditingController.text),
    );

    onDoneCallback(companyInfoStepModel);
  }

  @override
  dispose() {
    investmentCapitalTextEditingController.dispose();
    sharedPurchasesTextEditingController.dispose();
    sharesClassTextEditingController.dispose();
    companySharesOutstandingTextEditingController.dispose();
  }

  @override
  bool validateInputs() {
    return _validateInvestmentCapitalValue()
        && _validateSharedPurchasesValue()
        && _validateSharesClassValue()
        && _validateCompanySharesOutstandingValue()
        && _validateMarketValue();
  }
}
