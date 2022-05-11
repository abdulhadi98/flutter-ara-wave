import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wave_flutter/bloc/select_company_step_dialog_bloc.dart';
import 'package:wave_flutter/helper/enums.dart';
import 'package:wave_flutter/helper/utils.dart';
import 'package:wave_flutter/models/add_asset_holding_drop_down_menu_model.dart';
import 'package:wave_flutter/models/company_info_step_model.dart';
import 'package:wave_flutter/models/company_shares_step_model.dart';
import 'package:wave_flutter/models/confirm_private_asset_acquisition_model.dart';
import 'package:wave_flutter/models/select_company_step_model.dart';

class SelectCompanyStepDialogContentController {
  final SelectCompanyStepDialogBloc _selectCompanyStepDialogBloc;
  SelectCompanyStepDialogContentController({required selectCompanyStepDialogBloc})
      : _selectCompanyStepDialogBloc = selectCompanyStepDialogBloc;


  final BehaviorSubject<bool> _loadingController = BehaviorSubject.seeded(false);
  get loadingStream => _loadingController.stream;
  bool getLoadingState() => _loadingController.value;
  setLoadingState(bool state) => _loadingController.sink.add(state);

  ConfirmPrivateAssetAcquisitionModel _createConfirmPrivateAssetAcquisitionModel() {
    return ConfirmPrivateAssetAcquisitionModel(
      apiToken: _selectCompanyStepDialogBloc.currentUserApiToken??'',
      assetId: getSelectedPrivateCompany()!.id,
      passcode: shareholderPasscodeTextEditingController.text.trim(),
    );
  }

  _onConfirmPrivateAssetAcquisitionSucceed(Function(SelectCompanyStepModel selectCompany) onDoneCallback) {
    setLoadingState(false);
    SelectCompanyStepModel selectCompany = SelectCompanyStepModel(
      company: getSelectedPrivateCompany()!,
      shareholderPasscode: int.parse(shareholderPasscodeTextEditingController.text),
    );

    onDoneCallback(selectCompany);
  }

  _onConfirmPrivateAssetAcquisitionFailed(BuildContext context, String message) {
    setLoadingState(false);
    Utils.showTranslatedToast(context, message);
  }

  final BehaviorSubject<AddAssetHoldingDropDownMenuModel?> _selectedPrivateCompanyController = BehaviorSubject<AddAssetHoldingDropDownMenuModel?>();
  get selectedPrivateCompanyStream => _selectedPrivateCompanyController.stream;
  AddAssetHoldingDropDownMenuModel? getSelectedPrivateCompany() => _selectedPrivateCompanyController.valueOrNull;
  setSelectedPrivateCompany(AddAssetHoldingDropDownMenuModel? company) => _selectedPrivateCompanyController.sink.add(company);

  final shareholderPasscodeTextEditingController = TextEditingController();
  final BehaviorSubject<bool> _validationController = BehaviorSubject.seeded(false);
  get validationStream => _validationController.stream;
  bool getValidationState() => _validationController.value;
  setValidationState(bool type) => _validationController.sink.add(type);

  final BehaviorSubject<bool> _validationShareholderPasscodeController = BehaviorSubject.seeded(false);
  get validationShareholderPasscodeStream => _validationShareholderPasscodeController.stream;
  bool getValidationShareholderPasscodeState() => _validationShareholderPasscodeController.value;
  setValidationShareholderPasscodeState(bool type) => _validationShareholderPasscodeController.sink.add(type);

  onPrivateCompanySelected(selectedItem) {
    setSelectedPrivateCompany(selectedItem);
    _validateInputs();
  }
  onSharesNumTextFieldChanged(String value) {
    setValidationShareholderPasscodeState(value.length >= 6);
    _validateInputs();
  }

  _validateInputs() {
    bool isValid = _validateSelectedCompany() && _validateShareholderPasscodeValue();
    setValidationState(isValid);
  }

  bool _validateSelectedCompany() {
    return getSelectedPrivateCompany()!=null;
  }

  bool _validateShareholderPasscodeValue() {
    return shareholderPasscodeTextEditingController.text.length >= 6;
  }

  onNextButtonClicked({
    required BuildContext context,
    required Function(SelectCompanyStepModel selectCompany) onDoneCallback,
  }) {
    setLoadingState(true);
    _selectCompanyStepDialogBloc.confirmPrivateAssetAcquisition(
      confirmPrivateAssetAcquisitionModel: _createConfirmPrivateAssetAcquisitionModel(),
      onData: () => _onConfirmPrivateAssetAcquisitionSucceed(onDoneCallback),
      onError: (message) => _onConfirmPrivateAssetAcquisitionFailed(context, message,),
    );
  }

  dispose() {
    _loadingController.close();
    _validationController.close();
    _selectedPrivateCompanyController.close();
    _validationShareholderPasscodeController.close();
    shareholderPasscodeTextEditingController.dispose();
  }
}
