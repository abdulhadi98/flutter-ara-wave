import 'package:rxdart/rxdart.dart';
import 'package:wave_flutter/models/add_personal_asset_holding_model.dart';
import 'package:wave_flutter/models/personal_asset_holding_model.dart';
import 'package:wave_flutter/models/personal_asset_type.dart';
import 'package:wave_flutter/models/personal_asset_type_step.dart';
import 'package:wave_flutter/services/api_provider.dart';
import 'package:wave_flutter/services/data_resource.dart';
import 'local_user_bloc.dart';
import 'mixin/IAddPersonalAssetBloc.dart';

class AddPersonalAssetDialogBloc with IAddPersonalAssetBloc {
  final ApiProvider _apiProvider;
  final LocalUserBloc _localUserBloc;
  AddPersonalAssetDialogBloc({required apiProvider, required localUserBloc,})
      : _apiProvider = apiProvider, _localUserBloc = localUserBloc;

  static const String LOG_TAG = 'AddPersonalAssetDialogBloc';

  String? get currentUserApiToken => _localUserBloc.currentUser?.apiToken;

  @override
  addPersonalAssetHolding({
    required AddPersonalAssetHoldingModel addPersonalAssetHoldingModel,
    required Function(/*PersonalAssetHoldingModel holding*/) onData,
    required Function(String message) onError,
  }) async {
    try {
      final response = await _apiProvider.addPersonalAssetsHolding(addPersonalAssetHoldings: addPersonalAssetHoldingModel);
      // PersonalAssetHoldingModel holding = PersonalAssetHoldingModel.fromJson(response,);
      onData();
    } on FormatException catch (error) {
      print('$LOG_TAG: addPersonalAssetHolding() FormatException: ${error.message}');
      onError(error.message);
    } catch (error) {
      print('$LOG_TAG: addPersonalAssetHolding() Exception: ${error.toString()}');
      onError('something_went_wrong');
    }
  }

  @override
  dispose() {

  }

}