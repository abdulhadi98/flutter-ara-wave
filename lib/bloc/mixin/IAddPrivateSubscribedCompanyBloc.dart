import 'package:wave_flutter/models/add_private_asset_holding_model.dart';
import 'package:wave_flutter/models/confirm_private_asset_acquisition_model.dart';
import 'package:wave_flutter/models/private_asset_model.dart';

mixin IAddPrivateSubscribedCompanyBloc {
  fetchPrivateAssets();
  addPrivateSubscribedCompany({
    required AddPrivateAssetHoldingModel addPrivateAssetHoldings,
    required Function(int addedAssetId) onData,
    required Function(String message) onError,
  });
}