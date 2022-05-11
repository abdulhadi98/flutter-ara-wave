import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wave_flutter/models/add_personal_asset_holding_model.dart';
import 'package:wave_flutter/models/add_private_asset_holding_model.dart';
import 'package:wave_flutter/models/public_asset_graph_model.dart';
import 'package:wave_flutter/models/assets_financials.dart';
import 'package:wave_flutter/models/personal_asset_holding_model.dart';
import 'package:wave_flutter/models/personal_asset_model.dart';
import 'package:wave_flutter/models/holding_list_model.dart';
import 'package:wave_flutter/models/personal_asset_type.dart';
import 'package:wave_flutter/models/private_asset_holding_model.dart';
import 'package:wave_flutter/models/private_asset_model.dart';
import 'package:wave_flutter/models/public_asset_graph_request_body.dart';
import 'package:wave_flutter/models/public_asset_holding_model.dart';
import 'package:wave_flutter/models/public_asset_model.dart';
import 'package:wave_flutter/models/upload_image_model.dart';
import 'package:wave_flutter/models/user_model.dart';
import 'package:wave_flutter/services/api_provider.dart';
import 'package:wave_flutter/services/data_resource.dart';
import 'package:wave_flutter/storage/data_store.dart';
import 'general_bloc.dart';

class HoldingsScreenBloc{

  final ApiProvider _apiProvider;
  final DataStore _dataStore;
  final GeneralBloc _generalBLoc;
  HoldingsScreenBloc({required apiProvider, required generalBLoc, required dataStore}):
        _apiProvider = apiProvider, _generalBLoc = generalBLoc, _dataStore = dataStore;

  static const String LOG_TAG = 'HoldingsScreenBloc';

  UserModel? get currentUser => _dataStore.userModel;

  get personalAssetsFinancialsStream => _generalBLoc.personalAssetsFinancialsStream;
  DataResource<AssetsFinancials>? getPersonalAssetsFinancials() => _generalBLoc.getPersonalAssetsFinancials();
  fetchPersonalAssetsFinancials() => _generalBLoc.fetchPersonalAssetsFinancials();

  get privateAssetsFinancialsStream => _generalBLoc.privateAssetsFinancialsStream;
  DataResource<AssetsFinancials>? getPrivateAssetsFinancials() => _generalBLoc.getPrivateAssetsFinancials();
  fetchPrivateAssetsFinancials() => _generalBLoc.fetchPrivateAssetsFinancials();

  get publicAssetsFinancialsStream => _generalBLoc.publicAssetsFinancialsStream;
  DataResource<AssetsFinancials>? getPublicAssetsFinancials() => _generalBLoc.getPublicAssetsFinancials();
  fetchPublicAssetsFinancials() => _generalBLoc.fetchPublicAssetsFinancials();

  final _assetHoldingsController = BehaviorSubject<DataResource<List<HoldingModel>>>();
  get assetHoldingsStream => _assetHoldingsController.stream;
  DataResource<List<HoldingModel>> getAssetHoldings() => _assetHoldingsController.value;
  setAssetHoldings(DataResource<List<HoldingModel>> dataRes) => _assetHoldingsController.sink.add(dataRes);

  fetchPrivateAssetHoldings({onData, onError}) {
    _fetchAssetHoldings(
      fetchList: () async {
        final response = await _apiProvider.getPrivateAssetsHolding(token: _dataStore.userModel?.apiToken,);
        return privateHoldingListFromJson(response);
        },
      onData: onData,
      onError: onError,
    );
  }

  fetchPublicAssetHoldings({onData, onError}) {
    _fetchAssetHoldings(
        fetchList: () async {
          final response = await _apiProvider.gePublicAssetsHolding(token: _dataStore.userModel?.apiToken,);
          return PublicHoldingListModel.fromJson(response,).holdingList;
          },
      onData: onData,
      onError: onError,
    );
  }

  _fetchAssetHoldings({required fetchList, onData, onError}) async {
    DataResource<List<HoldingModel>> dataRes;
    try {
      setAssetHoldings(DataResource.loading());

      var assetHoldings = await fetchList();

      if(assetHoldings.isNotEmpty) dataRes = DataResource.success(assetHoldings);
      else dataRes = DataResource.noResults();
      setAssetHoldings(dataRes);
      if(onData!=null) onData();
    } on FormatException catch (error) {
      print('$LOG_TAG: fetchAssetHoldings() FormatException: ${error.message}');
      dataRes = DataResource.failure(error.message);
      setAssetHoldings(dataRes);
      if(onData!=null) onError(error.message);
    } catch (error) {
      print('$LOG_TAG: fetchAssetHoldings() Exception: ${error.toString()}');
      dataRes = DataResource.failure('something_went_wrong');
      setAssetHoldings(dataRes);
      if(onData!=null) onError('something_went_wrong');
    }
  }

  final _personalAssetHoldingsController = BehaviorSubject<DataResource<List<PersonalAssetHoldingModel>>?>();
  get personalAssetHoldingsStream => _personalAssetHoldingsController.stream;
  DataResource<List<PersonalAssetHoldingModel>>? getPersonalAssetHoldings() => _personalAssetHoldingsController.value;
  setPersonalAssetHoldings(DataResource<List<PersonalAssetHoldingModel>>? dataRes) => _personalAssetHoldingsController.sink.add(dataRes);

  fetchPersonalAssetHoldings({onData, onError}) async {
    DataResource<List<PersonalAssetHoldingModel>> dataRes;
    try {
      setPersonalAssetHoldings(DataResource.loading());

      final response = await _apiProvider.getPersonalAssetsHolding(token: _dataStore.userModel?.apiToken,);
      List<PersonalAssetHoldingModel> holdings = PersonalAssetHoldingListModel.fromJson(response,).holdingList;

      if(holdings.isNotEmpty) dataRes = DataResource.success(holdings);
      else dataRes = DataResource.noResults();
      setPersonalAssetHoldings(dataRes);
      if(onData!=null) onData();
    } on FormatException catch (error) {
      print('$LOG_TAG: fetchPersonalAssetHoldings() FormatException: ${error.message}');
      dataRes = DataResource.failure(error.message);
      setPersonalAssetHoldings(dataRes);
      if(onData!=null) onError(error.message);
    } catch (error) {
      print('$LOG_TAG: fetchPersonalAssetHoldings() Exception: ${error.toString()}');
      dataRes = DataResource.failure('something_went_wrong');
      setPersonalAssetHoldings(dataRes);
      if(onData!=null) onError('something_went_wrong');
    }
  }

  addPrivateAssetHolding({
    required AddPrivateAssetHoldingModel addPrivateAssetHoldings,
    required Function(PrivateAssetModel holding) onData,
    required Function(String message) onError,
  }) async {
    try {
      final response = await _apiProvider.addPrivateAssetsHolding(addPrivateAssetHoldings: addPrivateAssetHoldings);
      PrivateAssetModel holding = PrivateAssetModel.fromJson(response,);
      onData(holding);
    } on FormatException catch (error) {
      print('$LOG_TAG: addPrivateAssetHolding() FormatException: ${error.message}');
      onError(error.message);
    } catch (error) {
      print('$LOG_TAG: addPrivateAssetHolding() Exception: ${error.toString()}');
      onError('something_went_wrong');
    }
  }

  addPublicAssetHolding({
    required AddPrivateAssetHoldingModel addPublicAssetHoldings,
    required Function(PrivateAssetModel holding) onData,
    required Function(String message) onError,
  }) async {
    // try {
    //   final response = await _apiProvider.addPublicAssetsHolding(addPublicAssetHoldings: addPublicAssetHoldings);
    //   PrivateAssetModel holding = PrivateAssetModel.fromJson(response,);
    //   onData(holding);
    // } on FormatException catch (error) {
    //   print('$LOG_TAG: addPrivateAssetHolding() FormatException: ${error.message}');
    //   onError(error.message);
    // } catch (error) {
    //   print('$LOG_TAG: addPrivateAssetHolding() Exception: ${error.toString()}');
    //   onError('something_went_wrong');
    // }
  }

  final _personalAssetTypesController = BehaviorSubject<DataResource<List<PersonalAssetTypeModel>>?>();
  get personalAssetTypesStream => _personalAssetTypesController.stream;
  DataResource<List<PersonalAssetTypeModel>>? getPersonalAssetTypes() => _personalAssetTypesController.value;
  setPersonalAssetTypes(DataResource<List<PersonalAssetTypeModel>>? dataRes) => _personalAssetTypesController.sink.add(dataRes);

  fetchPersonalAssetTypes() async {
    DataResource<List<PersonalAssetTypeModel>> dataRes;
    try {
      setPersonalAssetTypes(DataResource.loading());

      final response = await _apiProvider.getPersonalAssetTypes();
      List<PersonalAssetTypeModel> types = personalAssetTypeListModelFromJson(response,);

      if(types.isNotEmpty) dataRes = DataResource.success(types);
      else dataRes = DataResource.noResults();
      setPersonalAssetTypes(dataRes);
    } on FormatException catch (error) {
      print('$LOG_TAG: fetchPersonalAssetTypes() FormatException: ${error.message}');
      dataRes = DataResource.failure(error.message);
      setPersonalAssetTypes(dataRes);
    } catch (error) {
      print('$LOG_TAG: fetchPersonalAssetTypes() Exception: ${error.toString()}');
      dataRes = DataResource.failure('something_went_wrong');
      setPersonalAssetTypes(dataRes);
    }
  }

  addPersonalAssetHolding({
    required AddPersonalAssetHoldingModel addPersonalAssetHoldings,
    required /*Function(PrivateAssetModel holding)*/ onData,
    required Function(String message) onError,
  }) async {
    try {
      final response = await _apiProvider.addPersonalAssetsHolding(addPersonalAssetHoldings: addPersonalAssetHoldings);
      // PrivateAssetModel holding = PrivateAssetModel.fromJson(response,);
      onData();
    } on FormatException catch (error) {
      print('$LOG_TAG: addPersonalAssetHolding() FormatException: ${error.message}');
      onError(error.message);
    } catch (error) {
      print('$LOG_TAG: addPersonalAssetHolding() Exception: ${error.toString()}');
      onError('something_went_wrong');
    }
  }

  get privateAssetsStream => _generalBLoc.privateAssetsStream;
  DataResource<List<PrivateAssetModel>>? getPrivateAssets() => _generalBLoc.getPrivateAssets();
  setPrivateAssets(DataResource<List<PrivateAssetModel>>? dataRes) => _generalBLoc.setPrivateAssets(dataRes);
  fetchPrivateAssets() async => _generalBLoc.fetchPrivateAssets();

  get publicAssetsStream => _generalBLoc.publicAssetsStream;
  DataResource<List<PublicAssetModel>>? getPublicAssets() => _generalBLoc.getPublicAssets();
  setPublicAssets(DataResource<List<PublicAssetModel>>? dataRes) => _generalBLoc.setPublicAssets(dataRes);
  fetchPublicAssets() async => _generalBLoc.fetchPublicAssets();

  // final _publicAssetHistoricalController = BehaviorSubject<DataResource<List<AssetHistoricalModel>>?>();
  // get publicAssetHistoricalStream => _publicAssetHistoricalController.stream;
  // DataResource<List<AssetHistoricalModel>>? getPublicAssetHistorical() => _publicAssetHistoricalController.value;
  // setPublicAssetHistorical(DataResource<List<AssetHistoricalModel>>? dataRes) => _publicAssetHistoricalController.sink.add(dataRes);

  // fetchPublicAssetHistorical({
  //   required int interval,
  //   required String range,
  // }) async {
  //   DataResource<List<AssetHistoricalModel>> dataRes;
  //   try {
  //     setPrivateAssets(DataResource.loading());
  //     var response = await _apiProvider.getPublicAssetHistoricalData(
  //       token: currentUser?.apiToken,
  //       interval: interval,
  //       range: range,
  //     );
  //     List<AssetHistoricalModel> assets = assetHistoricalModelFromJson(response);
  //     dataRes = DataResource.success(assets);
  //     setPublicAssetHistorical(dataRes);
  //   } on FormatException catch (error) {
  //     dataRes =  DataResource.failure(error.message);
  //     setPublicAssetHistorical(dataRes);
  //     print('$LOG_TAG fetchPublicAssetHistorical FormatException: ${error.message})');
  //   } catch (error) {
  //     dataRes =  DataResource.failure('something_went_wrong');
  //     setPublicAssetHistorical(dataRes);
  //     print('$LOG_TAG fetchPublicAssetHistorical Exception: ${error.toString()})');
  //   }
  // }

  final _publicAssetGraphController = BehaviorSubject<DataResource<List<PublicAssetGraphModel>>?>();
  get publicAssetGraphStream => _publicAssetGraphController.stream;
  DataResource<List<PublicAssetGraphModel>>? getPublicAssetGraph() => _publicAssetGraphController.value;
  setPublicAssetGraph(DataResource<List<PublicAssetGraphModel>>? dataRes) => _publicAssetGraphController.sink.add(dataRes);

  fetchPublicAssetMainGraph({
    required PublicAssetGraphRequestBody publicAssetGraphRequestBody,
  }) async {
    DataResource<List<PublicAssetGraphModel>> dataRes;
    try {
      setPublicAssetGraph(DataResource.loading());
      final response = await _apiProvider.getPublicAssetMainGraph(publicAssetGraphRequestBody: publicAssetGraphRequestBody);
      List<PublicAssetGraphModel> graphInfoList = List<PublicAssetGraphModel>.from(response.map((x) => PublicAssetGraphModel.fromJson(x)));
      dataRes = DataResource.success(graphInfoList);
      setPublicAssetGraph(dataRes);
    } on FormatException catch (error) {
      dataRes =  DataResource.failure(error.message);
      setPublicAssetGraph(dataRes);
      print('$LOG_TAG fetchPublicAssetMainGraph FormatException: ${error.message}');
    } catch (error) {
      dataRes =  DataResource.failure('something_went_wrong');
      setPublicAssetGraph(dataRes);
      print('$LOG_TAG fetchPublicAssetMainGraph Exception: ${error.toString()}');
    }
  }

  uploadImageList({required List<UploadImageModel> images, required onData, required onError}) {
    int c= 0;
    uploadFirstFile() {
      _uploadImage(
          uploadImageModel: images[c],
          onData: () {
            c++;
            if (c<images.length) {
              uploadFirstFile();
            } else {
              onData();
            }
          },
          onError: (e) {
            c++;
            onError(e);
          });
    }

    uploadFirstFile();
  }

  _uploadImage({required UploadImageModel uploadImageModel, required onData, required onError}) async {
    try {
      final response = await _apiProvider.uploadImage(uploadImageModel: uploadImageModel,);
      uploadImageModel.url = response["url"];
      onData();
    } on FormatException catch (error) {
      print('$LOG_TAG: uploadImage() FormatException: ${error.message}');
      onError(error.message);
    } catch (error) {
      print('$LOG_TAG: uploadImage() Exception: ${error.toString()}');
      onError('something_went_wrong');
    }
  }

  disposeStreams(){
    _assetHoldingsController.close();
    _publicAssetGraphController.close();
    _personalAssetTypesController.close();
    _personalAssetHoldingsController.close();
    // _publicAssetHistoricalController.close();
    setPrivateAssets(null);
  }
}