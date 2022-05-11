import 'package:flutter/material.dart';
import 'package:wave_flutter/bloc/AddPrivateAssetManuallyBloc.dart';
import 'package:wave_flutter/helper/enums.dart';
import 'package:wave_flutter/helper/utils.dart';
import 'package:wave_flutter/models/add_private_asset_manually_model.dart';
import 'package:wave_flutter/models/price_history_step_model.dart';
import 'package:wave_flutter/ui/root/add_assets/private/base_add_private_asset_dialog_content_controller.dart';

class AddPrivateAssetManuallyDialogContentController extends BaseAddPrivateAssetDialogContentController<AddPrivateAssetManuallyModel> {
  final AddPrivateAssetManuallyBloc _addPrivateAssetManuallyBloc;
  AddPrivateAssetManuallyDialogContentController({
    required addPrivateAssetManuallyBloc,
  }): _addPrivateAssetManuallyBloc = addPrivateAssetManuallyBloc;

  @override
  addAsset({
    required AddPrivateAssetManuallyModel addAssetModel,
    required Function(int addedAssetId) onData,
    required Function(String message) onError
  }) {
    _addPrivateAssetManuallyBloc.addPrivateAssetManually(
      addPrivateAssetManuallyModel: addAssetModel,
      onData: onData,
      onError: onError,
    );
  }

  @override
  createAddAssetModel() {
    return AddPrivateAssetManuallyModel(
      apiToken: _addPrivateAssetManuallyBloc.currentUserApiToken??'',
      companyName: companyInfo!.name,
      headquarterCity: companyInfo!.headquarterCity,
      country: companyInfo!.country,
      yearOfInvestment: companyInfo!.initialInvestmentYear.toString(),
      investedCapital: companySharesStep!.investmentCapital.toString(),
      sharesPurchased: companySharesStep!.sharesPurchased.toString(),
      shareClass: companySharesStep!.sharesClass.toString(),
      companySharesOutstanding: companySharesStep!.companySharesOutstanding.toString(),
      marketValue: companySharesStep!.marketValue.toString(),
    );
  }

  @override
  dispose() {}
}