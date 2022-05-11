import 'package:wave_flutter/models/add_personal_asset_holding_model.dart';
import 'package:wave_flutter/models/personal_asset_holding_model.dart';

mixin IAddPersonalAssetBloc {
  addPersonalAssetHolding({
    required AddPersonalAssetHoldingModel addPersonalAssetHoldingModel,
    required Function(/*PersonalAssetHoldingModel holding*/) onData,
    required Function(String message) onError,
  });
  dispose();
}