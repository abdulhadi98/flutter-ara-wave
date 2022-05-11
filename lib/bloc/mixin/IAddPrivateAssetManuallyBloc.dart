import 'package:wave_flutter/models/add_private_asset_holding_model.dart';
import 'package:wave_flutter/models/add_private_asset_manually_model.dart';
import 'package:wave_flutter/models/private_asset_model.dart';

mixin IAddPrivateAssetManuallyBloc {
  addPrivateAssetManually({
    required AddPrivateAssetManuallyModel addPrivateAssetManuallyModel,
    required Function(int addedAssetId) onData,
    required Function(String message) onError,
  });
}