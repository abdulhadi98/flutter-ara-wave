import 'package:wave_flutter/models/confirm_private_asset_acquisition_model.dart';
import 'package:wave_flutter/services/api_provider.dart';
import 'local_user_bloc.dart';

class SelectCompanyStepDialogBloc {
  final LocalUserBloc _localUserBloc;
  final ApiProvider _apiProvider;
  SelectCompanyStepDialogBloc({required apiProvider, required localUserBloc,})
      : _apiProvider = apiProvider, _localUserBloc = localUserBloc;

  static const String LOG_TAG = 'SelectCompanyStepDialogBloc';

  String? get currentUserApiToken => _localUserBloc.currentUser?.apiToken;

  confirmPrivateAssetAcquisition({
    required ConfirmPrivateAssetAcquisitionModel confirmPrivateAssetAcquisitionModel,
    required Function() onData,
    required Function(String message) onError,
  }) async {
    try {
      var response = await _apiProvider.confirmPrivateAssetAcquisition(
        confirmPrivateAssetAcquisitionModel: confirmPrivateAssetAcquisitionModel,
      );
      onData();
    } on FormatException catch (error) {
      print('$LOG_TAG fetchPrivateAssets FormatException: ${error.message}');
      onError(error.message);
    } catch (error) {
      print('$LOG_TAG fetchPrivateAssets Exception: ${error.toString()}');
      onError(error.toString());
    }
  }

  dispose() {}
}