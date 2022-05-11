import 'package:rxdart/rxdart.dart';
import 'package:wave_flutter/models/add_public_asset_holding_model.dart';
import 'package:wave_flutter/models/private_asset_model.dart';
import 'package:wave_flutter/models/public_asset_model.dart';
import 'package:wave_flutter/services/api_provider.dart';
import 'package:wave_flutter/services/data_resource.dart';
import 'local_user_bloc.dart';
import 'mixin/IAddPublicAssetHoldingBloc.dart';

class AddPublicAssetHoldingBloc with IAddPublicAssetHoldingBloc {

  final ApiProvider _apiProvider;
  final LocalUserBloc _localUserBloc;
  AddPublicAssetHoldingBloc({required apiProvider, required localUserBloc,})
      : _apiProvider = apiProvider, _localUserBloc = localUserBloc;

  static const String LOG_TAG = 'AddPublicAssetHoldingBloc';

  String? get currentUserApiToken => _localUserBloc.currentUser?.apiToken;

  @override
  addPublicAssetHolding({
    required AddPublicAssetHoldingModel addPublicAssetHoldingModel,
    required Function(PrivateAssetModel holding) onData,
    required Function(String message) onError,
  }) async {
    try {
      final response = await _apiProvider.addPublicAssetsHolding(addPublicAssetHoldingModel: addPublicAssetHoldingModel);
      PrivateAssetModel holding = PrivateAssetModel.fromJson(response,);
      onData(holding);
    } on FormatException catch (error) {
      print('$LOG_TAG: addPublicAssetHolding() FormatException: ${error.message}');
      onError(error.message);
    } catch (error) {
      print('$LOG_TAG: addPublicAssetHolding() Exception: ${error.toString()}');
      onError('something_went_wrong');
    }
  }

  final _publicAssetsController = BehaviorSubject<DataResource<List<PublicAssetModel>>?>();
  get publicAssetsStream => _publicAssetsController.stream;
  DataResource<List<PublicAssetModel>>? getPublicAssets() => _publicAssetsController.valueOrNull;
  setPublicAssets(DataResource<List<PublicAssetModel>>? dataRes) => _publicAssetsController.sink.add(dataRes);

  @override
  fetchPublicAssets() async {
    DataResource<List<PublicAssetModel>> dataRes;
    try {
      setPublicAssets(DataResource.loading());
      var response = await _apiProvider.getPublicAssets();
      List<PublicAssetModel> assets = PublicAssetListModel.fromJson(response).assets;

      dataRes = DataResource.success(assets);
      setPublicAssets(dataRes);
    } on FormatException catch (error) {
      dataRes =  DataResource.failure(error.message);
      setPublicAssets(dataRes);
      print('$LOG_TAG fetchPublicAssets FormatException: ${error.message})');
    } catch (error) {
      dataRes =  DataResource.failure('something_went_wrong');
      setPublicAssets(dataRes);
      print('$LOG_TAG fetchPublicAssets Exception: ${error.toString()})');
    }
  }

  dispose() {
    _publicAssetsController.close();
  }
}