import 'package:rxdart/rxdart.dart';
import 'package:wave_flutter/bloc/mixin/IAddPrivateSubscribedCompanyBloc.dart';
import 'package:wave_flutter/models/add_private_asset_holding_model.dart';
import 'package:wave_flutter/models/confirm_private_asset_acquisition_model.dart';
import 'package:wave_flutter/models/private_asset_holding_model.dart';
import 'package:wave_flutter/models/private_asset_model.dart';
import 'package:wave_flutter/services/api_provider.dart';
import 'package:wave_flutter/services/data_resource.dart';
import 'local_user_bloc.dart';

class AddPrivateSubscribedCompanyBloc with IAddPrivateSubscribedCompanyBloc {
  final LocalUserBloc _localUserBloc;
  final ApiProvider _apiProvider;
  AddPrivateSubscribedCompanyBloc({required apiProvider, required localUserBloc,})
      : _apiProvider = apiProvider, _localUserBloc = localUserBloc;

  static const String LOG_TAG = 'AddPrivateSubscribedCompanyBloc';

  String? get currentUserApiToken => _localUserBloc.currentUser?.apiToken;

  @override
  addPrivateSubscribedCompany({
    required AddPrivateAssetHoldingModel addPrivateAssetHoldings,
    required Function(int addedAssetId) onData,
    required Function(String message) onError,
  }) async {
    try {
      final response = await _apiProvider.addPrivateAssetsHolding(addPrivateAssetHoldings: addPrivateAssetHoldings);
      int addedAssetId = int.parse(response['Private_asset_id']);
      onData(addedAssetId);
    } on FormatException catch (error) {
      print('$LOG_TAG: addPrivateSubscribedCompany() FormatException: ${error.message}');
      onError(error.message);
    } catch (error) {
      print('$LOG_TAG: addPrivateSubscribedCompany() Exception: ${error.toString()}');
      onError('something_went_wrong');
    }
  }

  final _privateAssetsController = BehaviorSubject<DataResource<List<PrivateAssetModel>>?>();
  ValueStream<DataResource<List<PrivateAssetModel>>?> get privateAssetsStream => _privateAssetsController.stream;
  DataResource<List<PrivateAssetModel>>? getPrivateAssets() => _privateAssetsController.valueOrNull;
  setPrivateAssets(DataResource<List<PrivateAssetModel>>? dataRes) => _privateAssetsController.sink.add(dataRes);

  @override
  fetchPrivateAssets() async {
    DataResource<List<PrivateAssetModel>> dataRes;
    try {
      setPrivateAssets(DataResource.loading());
      var response = await _apiProvider.getPrivateAssets();
      List<PrivateAssetModel> assets = PrivateAssetListModel.fromJson(response).assets;

      assets.forEach((element) {
        element.initAssetMetasLists();
      });

      dataRes = DataResource.success(assets);
      setPrivateAssets(dataRes);
    } on FormatException catch (error) {
      dataRes =  DataResource.failure(error.message);
      setPrivateAssets(dataRes);
      print('$LOG_TAG fetchPrivateAssets FormatException: ${error.message})');
    } catch (error) {
      dataRes =  DataResource.failure('something_went_wrong');
      setPrivateAssets(dataRes);
      print('$LOG_TAG fetchPrivateAssets Exception: ${error.toString()})');
    }
  }

  dispose() {
    _privateAssetsController.close();
  }
}