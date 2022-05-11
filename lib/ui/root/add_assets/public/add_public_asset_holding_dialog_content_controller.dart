import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wave_flutter/bloc/add_public_asset_holding_bloc.dart';
import 'package:wave_flutter/bloc/local_user_bloc.dart';
import 'package:wave_flutter/helper/utils.dart';
import 'package:wave_flutter/models/add_asset_holding_drop_down_menu_model.dart';
import 'package:wave_flutter/models/add_public_asset_holding_model.dart';
import '../base_add_asset_step_controller.dart';

class AddPublicAssetHoldingDialogContentController extends BaseAddAssetStepController {
  final AddPublicAssetHoldingBloc _addPublicAssetHoldingBloc;
  AddPublicAssetHoldingDialogContentController({required addPublicAssetHoldingBloc,})
      : _addPublicAssetHoldingBloc = addPublicAssetHoldingBloc {
    _addPublicAssetHoldingBloc.fetchPublicAssets();
  }

  @override
  dispose() {
    stockExchangeTextEditingController.dispose();
    ofSharesTextEditingController.dispose();
    _purchaseDateController.close();
    _selectedPublicCompanyController.close();
  }

  @override
  bool validateInputs() {
    return _validateSelectedCompanyValue()
        && _validateStockExchangeValue()
        && _validateOfSharesValue()
        && _validatePurchaseDateValue();
  }

  final BehaviorSubject<AddAssetHoldingDropDownMenuModel?> _selectedPublicCompanyController = BehaviorSubject<AddAssetHoldingDropDownMenuModel?>();
  get selectedPublicCompanyStream => _selectedPublicCompanyController.stream;
  AddAssetHoldingDropDownMenuModel? getSelectedPublicCompany() => _selectedPublicCompanyController.valueOrNull;
  setSelectedPublicCompany(AddAssetHoldingDropDownMenuModel? company) => _selectedPublicCompanyController.sink.add(company);

  final BehaviorSubject<DateTime?> _purchaseDateController = BehaviorSubject<DateTime?>();
  get purchaseDateStream => _purchaseDateController.stream;
  DateTime? getPurchaseDate() => _purchaseDateController.valueOrNull;
  setPurchaseDate(DateTime? dateTime) => _purchaseDateController.sink.add(dateTime);

  final stockExchangeTextEditingController = TextEditingController();
  final ofSharesTextEditingController = TextEditingController();

  onPublicCompanySelected(AddAssetHoldingDropDownMenuModel selectedItem) {
    setSelectedPublicCompany(selectedItem);
    updateValidationState();
  }

  onStockExchangeTextFieldChanged(String value) {
    updateValidationState();
  }

  onOfSharesTextFieldChanged(String value) {
    updateValidationState();
  }

  onPurchaseDatePicked(DateTime? dateTime) {
    setPurchaseDate(dateTime);
    updateValidationState();
  }

  bool _validateSelectedCompanyValue() {
    return stockExchangeTextEditingController.text.isNotEmpty;
  }

  bool _validateStockExchangeValue() {
    return stockExchangeTextEditingController.text.isNotEmpty;
  }

  bool _validateOfSharesValue() {
    return ofSharesTextEditingController.text.isNotEmpty;
  }

  bool _validatePurchaseDateValue() {
    return getPurchaseDate()!=null;
  }

  onAddAssetButtonClicked(BuildContext context, VoidCallback onAssetAdded) {
    final addPublicAssetHoldingModel = AddPublicAssetHoldingModel(
      apiToken: _addPublicAssetHoldingBloc.currentUserApiToken??'',
      assetId: getSelectedPublicCompany()!.id.toString(),
      stockExchange: stockExchangeTextEditingController.text,
      quantity: ofSharesTextEditingController.text,
      verified: '1', //ToDo
      purchasedAt: getPurchaseDate().toString().substring(0, 10),
    );
    setLoadingState(true);

    _addPublicAssetHoldingBloc.addPublicAssetHolding(
      addPublicAssetHoldingModel: addPublicAssetHoldingModel,
      onData: (holding) => _onPublicHoldingAddingSucceed(context, onAssetAdded),
      onError: (message) => _onHoldingAddingFailed(context, message),
    );
  }

  _onPublicHoldingAddingSucceed(context, VoidCallback onAssetAdded) {
    setLoadingState(false);
    onAssetAdded();
    Navigator.of(context).pop();
  }

  _onHoldingAddingFailed(context, String message) {
    setLoadingState(false);
    Utils.showTranslatedToast(context, message);
  }
}