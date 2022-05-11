import 'package:wave_flutter/bloc/AddPrivateSubscribedCompanyBloc.dart';
import 'package:wave_flutter/helper/enums.dart';
import 'package:wave_flutter/models/add_private_asset_holding_model.dart';
import 'package:wave_flutter/models/confirm_private_asset_acquisition_model.dart';
import 'package:wave_flutter/models/select_company_step_model.dart';
import 'package:wave_flutter/ui/root/add_assets/private/base_add_private_asset_dialog_content_controller.dart';

class AddPrivateSubscribedCompanyDialogContentController extends BaseAddPrivateAssetDialogContentController<AddPrivateAssetHoldingModel> {
  final AddPrivateSubscribedCompanyBloc _addPrivateSubscribedCompanyBloc;
  AddPrivateSubscribedCompanyDialogContentController({
    required addPrivateSubscribedCompanyBloc,
  }): _addPrivateSubscribedCompanyBloc = addPrivateSubscribedCompanyBloc {
    _addPrivateSubscribedCompanyBloc.fetchPrivateAssets();
  }

  SelectCompanyStepModel? selectCompanyStep;
  onSelectCompanyNextClicked({
    required AddingPrivateAssetStep nextStep,
    required SelectCompanyStepModel selectCompanyStep,
  }){
    this.selectCompanyStep = selectCompanyStep;
    onNextButtonClicked(nextStep);
  }

  @override
  addAsset({
    required AddPrivateAssetHoldingModel addAssetModel,
    required Function(int addedAssetId) onData,
    required Function(String message) onError,
  }) {
    _addPrivateSubscribedCompanyBloc.addPrivateSubscribedCompany(
      addPrivateAssetHoldings: addAssetModel,
      onData: onData,
      onError: onError,
    );
  }

  @override
  createAddAssetModel() {
    return AddPrivateAssetHoldingModel(
      apiToken: _addPrivateSubscribedCompanyBloc.currentUserApiToken??'',
      assetId: selectCompanyStep!.company.id,
      headquarterCity: companyInfo!.headquarterCity,
      country: companyInfo!.country,
      purchasedAt: companyInfo!.initialInvestmentYear.toString(),
      investedCapital: companySharesStep!.investmentCapital,
      purchasedPrice: companySharesStep!.sharesPurchased,
      shareClass: companySharesStep!.sharesClass,
      companySharesOutstanding: companySharesStep!.companySharesOutstanding,
      quantity: 1000, // TODO
      source: 'test', //TODO
    );
  }

  @override
  dispose() {}
}