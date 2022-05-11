import 'package:wave_flutter/models/add_private_asset_holding_model.dart';
import 'package:wave_flutter/models/add_private_asset_manually_model.dart';
import 'package:wave_flutter/models/add_public_asset_holding_model.dart';
import 'package:wave_flutter/models/private_asset_model.dart';

mixin IAddPublicAssetHoldingBloc {
  fetchPublicAssets();
  addPublicAssetHolding({
    required AddPublicAssetHoldingModel addPublicAssetHoldingModel,
    required Function(PrivateAssetModel holding) onData,
    required Function(String message) onError,
  });
}