import 'package:wave_flutter/models/add_private_asset_manually_model.dart';
import 'package:wave_flutter/services/api_provider.dart';
import 'local_user_bloc.dart';
import 'mixin/IAddPrivateAssetManuallyBloc.dart';


class AddPrivateAssetManuallyBloc with IAddPrivateAssetManuallyBloc {
  final LocalUserBloc _localUserBloc;
  final ApiProvider _apiProvider;
  AddPrivateAssetManuallyBloc({required apiProvider, required localUserBloc})
      : _apiProvider = apiProvider, _localUserBloc = localUserBloc;

  static const String LOG_TAG = 'AddPrivateAssetManuallyBloc';

  String? get currentUserApiToken => _localUserBloc.currentUser?.apiToken;

  @override
  addPrivateAssetManually({
    required AddPrivateAssetManuallyModel addPrivateAssetManuallyModel,
    required Function(int addedAssetId) onData,
    required Function(String message) onError,
  }) async {
    try {
      final response = await _apiProvider.addPrivateAssetsManual(addPrivateAssetManuallyModel: addPrivateAssetManuallyModel);
      PrivateAssetManuallyModel asset = PrivateAssetManuallyModel.fromJson(response,);
      onData(asset.id!);
    } on FormatException catch (error) {
      print('$LOG_TAG: addPrivateAssetManually() FormatException: ${error.message}');
      onError(error.message);
    } catch (error) {
      print('$LOG_TAG: addPrivateAssetManually() Exception: ${error.toString()}');
      onError('something_went_wrong');
    }
  }

  dispose() {}
}