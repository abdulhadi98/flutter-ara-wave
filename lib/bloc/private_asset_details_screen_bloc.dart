import 'package:rxdart/rxdart.dart';
import 'package:wave_flutter/models/private_asset_model.dart';
import 'package:wave_flutter/services/api_provider.dart';
import 'package:wave_flutter/services/data_resource.dart';
import 'package:wave_flutter/storage/data_store.dart';
import 'general_bloc.dart';

class PrivateAssetDetailsScreenBloc {

  final ApiProvider _apiProvider;
  final DataStore _dataStore;
  final GeneralBloc _generalBLoc;
  PrivateAssetDetailsScreenBloc({required apiProvider, required generalBLoc, required dataStore}):
        _apiProvider = apiProvider, _generalBLoc = generalBLoc, _dataStore = dataStore;

  static const String LOG_TAG = 'PrivateAssetDetailsScreenBloc';

  get privateAssetsStream => _generalBLoc.privateAssetsStream;
  DataResource<List<PrivateAssetModel>>? getPrivateAssets() => _generalBLoc.getPrivateAssets();
  setPrivateAssets(DataResource<List<PrivateAssetModel>>? dataRes) => _generalBLoc.setPrivateAssets(dataRes);

  fetchPrivateAssets() async => _generalBLoc.fetchPrivateAssets();

  disposeStreams() {
    setPrivateAssets(null);
  }
}