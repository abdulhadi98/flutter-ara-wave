import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wave_flutter/helper/enums.dart';
import 'package:wave_flutter/helper/utils.dart';
import 'package:wave_flutter/models/company_info_step_model.dart';
import 'package:wave_flutter/models/company_shares_step_model.dart';

abstract class BaseAddPrivateAssetDialogContentController<T> {

  final BehaviorSubject<bool> _loadingController = BehaviorSubject.seeded(false);
  get loadingStream => _loadingController.stream;
  bool getLoadingState() => _loadingController.value;
  setLoadingState(bool state) => _loadingController.sink.add(state);

  final BehaviorSubject<AddingPrivateAssetStep> _addingPrivateAssetStepController = BehaviorSubject<AddingPrivateAssetStep>();
  get addingPrivateAssetStepStream => _addingPrivateAssetStepController.stream;
  AddingPrivateAssetStep getAddingPrivateAssetStep() => _addingPrivateAssetStepController.value;
  setAddingPrivateAssetStep(AddingPrivateAssetStep company) => _addingPrivateAssetStepController.sink.add(company);

  onNextButtonClicked(AddingPrivateAssetStep nextStep) {
    setAddingPrivateAssetStep(nextStep);
  }

  CompanyInfoStepModel? companyInfo;
  onCompanyInfoNextClicked({
    required AddingPrivateAssetStep nextStep,
    required CompanyInfoStepModel companyInfo,
  }) {
    this.companyInfo = companyInfo;
    onNextButtonClicked(nextStep);
  }

  int? addedAssetId;
  CompanySharesStepModel? companySharesStep;
  onPriceHistoryButtonClicked({
    required BuildContext context,
    required AddingPrivateAssetStep nextStep,
    required CompanySharesStepModel sharesStep,
    required VoidCallback onAssetAdded,
  }) {
    companySharesStep = sharesStep;
    setLoadingState(true);
    addAsset(
      addAssetModel: createAddAssetModel(),
      onData: (addedAssetId) => onAssetAddedSucceed(onAssetAdded, nextStep, addedAssetId),
      onError: (message) => onAssetAddedFailed(context, message),
    );
  }

  addAsset({
    required T addAssetModel,
    required Function(int addedAssetId) onData,
    required Function(String message) onError,
  });
  T createAddAssetModel();
  onAssetAddedSucceed(VoidCallback onAssetAdded, AddingPrivateAssetStep nextStep, addedAssetId) {
    this.addedAssetId = addedAssetId;
    onAssetAdded();
    setLoadingState(false);
    onNextButtonClicked(nextStep);
  }
  onAssetAddedFailed(context, message) {
    setLoadingState(false);
    Utils.showTranslatedToast(context, message);
  }

  onFinishedClicked(BuildContext context) {
    Navigator.of(context).pop();
  }

  /// This the method you must use to dispose streams and controller
  /// after finish using them.
  disposeParent() {
    _addingPrivateAssetStepController.close();
    _loadingController.close();
    dispose();
  }

  dispose();
}