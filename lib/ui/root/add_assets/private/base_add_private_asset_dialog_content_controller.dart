import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wave_flutter/helper/enums.dart';
import 'package:wave_flutter/helper/utils.dart';
import 'package:wave_flutter/models/company_info_step_model.dart';
import 'package:wave_flutter/models/company_shares_step_model.dart';
import 'package:wave_flutter/services/data_resource.dart';

import '../../../../bloc/holdings_screen_bloc.dart';
import '../../../controllers/holdings_screen_controller.dart';
import '../../../controllers/root_screen_controller.dart';
import '../../holdings_screen.dart';

abstract class BaseAddPrivateAssetDialogContentController<T> {
  final BehaviorSubject<bool> _loadingController =
      BehaviorSubject.seeded(false);
  get loadingStream => _loadingController.stream;
  bool getLoadingState() => _loadingController.value;
  setLoadingState(bool state) => _loadingController.sink.add(state);

  final BehaviorSubject<AddingPrivateAssetStep>
      _addingPrivateAssetStepController =
      BehaviorSubject<AddingPrivateAssetStep>();
  get addingPrivateAssetStepStream => _addingPrivateAssetStepController.stream;
  AddingPrivateAssetStep getAddingPrivateAssetStep() =>
      _addingPrivateAssetStepController.value;
  setAddingPrivateAssetStep(AddingPrivateAssetStep company) =>
      _addingPrivateAssetStepController.sink.add(company);

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
      onData: (addedAssetId) =>
          onAssetAddedSucceed(onAssetAdded, nextStep, addedAssetId),
      onError: (message) => onAssetAddedFailed(context, message),
    );
  }

  addAsset({
    required T addAssetModel,
    required Function(int addedAssetId) onData,
    required Function(String message) onError,
  });
  T createAddAssetModel();
  onAssetAddedSucceed(VoidCallback onAssetAdded,
      AddingPrivateAssetStep nextStep, addedAssetId) {
    this.addedAssetId = addedAssetId;
    onAssetAdded();
    initScreenDi();
    setLoadingState(false);
    onNextButtonClicked(nextStep);
  }

  onAssetAddedFailed(context, message) {
    setLoadingState(false);
    Utils.showTranslatedToast(context, message);
  }

  GetIt _getIt = GetIt.instance;
  late RootScreenController rootScreenController;
  late HoldingsScreenController uiController;
  late HoldingsScreenBloc holdingsBloc;

  initScreenDi() {
    rootScreenController = _getIt<RootScreenController>();

    holdingsBloc = _getIt<HoldingsScreenBloc>();
    uiController = _getIt<HoldingsScreenController>(param1: holdingsBloc);
  }

  onFinishedClicked(BuildContext context) {
    Navigator.of(context).pop();
    if (HoldingsScreen.staticHoldingsScreenController != null) {
      HoldingsScreen.staticHoldingsScreenController!.fetchAssetsResults();
      HoldingsScreen.staticHoldingsScreenController!
          .fetchAssetsFinancialsResults();
    } else
      uiController.fetchAssetsResults();
    

    // rootScreenController.setCurrentScreen(AppMainScreens.HOLDINGS_SCREEN);

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
