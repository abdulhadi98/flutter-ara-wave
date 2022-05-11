import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wave_flutter/models/assets_financials.dart';
import 'package:wave_flutter/models/news_model.dart';
import 'package:wave_flutter/models/private_asset_model.dart';
import 'package:wave_flutter/models/public_asset_model.dart';
import 'package:wave_flutter/models/top_performing_gainers_loosers_model.dart';
import 'package:wave_flutter/models/user_model.dart';
import 'package:wave_flutter/models/user_portfolio_financials.dart';
import 'package:wave_flutter/services/api_provider.dart';
import 'package:wave_flutter/services/data_resource.dart';
import 'package:wave_flutter/storage/data_store.dart';

class GeneralBloc{

  final ApiProvider _apiProvider;
  final DataStore _dataStore;
  GeneralBloc({required apiProvider, required dataStore}):
        _apiProvider = apiProvider, _dataStore = dataStore;

  static const String LOG_TAG = 'GeneralBloc';

  UserModel? get currentUser => _dataStore.userModel;

  final _currentUserController = BehaviorSubject<DataResource<UserModel>?>();
  get currentUserStream => _currentUserController.stream;
  DataResource<UserModel>? getCurrentUser() => _currentUserController.value;
  setCurrentUser(DataResource<UserModel>? dataRes) => _currentUserController.sink.add(dataRes);

  fetchMe() async {
    DataResource<UserModel> dataRes;
    try {
      setCurrentUser(DataResource.loading());
      var response = await _apiProvider.getUser(token: currentUser?.apiToken);
      UserModel userModel = UserModel.fromJson(response);
      _dataStore.setUser(userModel).then((_) {
        _dataStore.getUser();
        dataRes = DataResource.success(userModel);
        setCurrentUser(dataRes);
      });
    } on FormatException catch (error) {
      dataRes =  DataResource.failure(error.message);
      setCurrentUser(dataRes);
      print('$LOG_TAG fetchMe FormatException: ${error.message})');
    } catch (error) {
      dataRes =  DataResource.failure('something_went_wrong');
      setCurrentUser(dataRes);
      print('$LOG_TAG fetchMe Exception: ${error.toString()})');
    }
  }

  final _userPortfolioFinancialsController = BehaviorSubject<DataResource<UserPortfolioFinancials>?>();
  get userPortfolioFinancialsControllerStream => _userPortfolioFinancialsController.stream;
  DataResource<UserPortfolioFinancials>? getUserPortfolioFinancials() => _userPortfolioFinancialsController.value;
  setUserPortfolioFinancials(DataResource<UserPortfolioFinancials>? dataRes) => _userPortfolioFinancialsController.sink.add(dataRes);

  fetchUserPortfolioFinancials() async {
    try {
      var response = await _apiProvider.getUserPortfolioFinancials(token: currentUser?.apiToken);
      UserPortfolioFinancials userPortfolioFinancials = UserPortfolioFinancials.fromJson(response);
      setUserPortfolioFinancials(DataResource.success(userPortfolioFinancials));
    } on FormatException catch (error) {
      // dataRes =  DataResource.failure(error.message);
      // setCurrentUser(dataRes);
      print('$LOG_TAG fetchUserPortfolioFinancials FormatException: ${error.message}');
    } catch (error) {
      // dataRes =  DataResource.failure('something_went_wrong');
      // setCurrentUser(dataRes);
      print('$LOG_TAG fetchUserPortfolioFinancials Exception: ${error.toString()}');
    }
  }

  final _privateAssetsFinancialsController = BehaviorSubject<DataResource<AssetsFinancials>?>();
  get privateAssetsFinancialsStream => _privateAssetsFinancialsController.stream;
  DataResource<AssetsFinancials>? getPrivateAssetsFinancials() => _privateAssetsFinancialsController.valueOrNull;
  setPrivateAssetsFinancials(DataResource<AssetsFinancials>? dataRes) => _privateAssetsFinancialsController.sink.add(dataRes);

  fetchPrivateAssetsFinancials() async {
    DataResource<AssetsFinancials> dataRes;
    try {
      setPrivateAssetsFinancials(DataResource.loading());
      var response = await _apiProvider.getPrivateAssetsFinancials(token: currentUser?.apiToken);
      AssetsFinancials assetsFinancials = AssetsFinancials.fromJson(response);
      dataRes = DataResource.success(assetsFinancials);
      setPrivateAssetsFinancials(dataRes);
    } on FormatException catch (error) {
      dataRes =  DataResource.failure(error.message);
      setPrivateAssetsFinancials(dataRes);
      print('$LOG_TAG fetchPrivateAssetsFinancials FormatException: ${error.message})');
    } catch (error) {
      dataRes =  DataResource.failure('something_went_wrong');
      setPrivateAssetsFinancials(dataRes);
      print('$LOG_TAG fetchPrivateAssetsFinancials Exception: ${error.toString()})');
    }
  }

  final _publicAssetsFinancialsController = BehaviorSubject<DataResource<AssetsFinancials>?>();
  get publicAssetsFinancialsStream => _publicAssetsFinancialsController.stream;
  DataResource<AssetsFinancials>? getPublicAssetsFinancials() => _publicAssetsFinancialsController.valueOrNull;
  setPublicAssetsFinancials(DataResource<AssetsFinancials>? dataRes) => _publicAssetsFinancialsController.sink.add(dataRes);

  fetchPublicAssetsFinancials() async {
    DataResource<AssetsFinancials> dataRes;
    try {
      setPublicAssetsFinancials(DataResource.loading());
      var response = await _apiProvider.getPublicAssetsFinancials(token: currentUser?.apiToken);
      AssetsFinancials assetsFinancials = AssetsFinancials.fromJson(response);
      dataRes = DataResource.success(assetsFinancials);
      setPublicAssetsFinancials(dataRes);
    } on FormatException catch (error) {
      dataRes =  DataResource.failure(error.message);
      setPublicAssetsFinancials(dataRes);
      print('$LOG_TAG fetchPublicAssetsFinancials FormatException: ${error.message})');
    } catch (error) {
      dataRes =  DataResource.failure('something_went_wrong');
      setPublicAssetsFinancials(dataRes);
      print('$LOG_TAG fetchPublicAssetsFinancials Exception: ${error.toString()})');
    }
  }

  final _personalAssetsFinancialsController = BehaviorSubject<DataResource<AssetsFinancials>?>();
  get personalAssetsFinancialsStream => _personalAssetsFinancialsController.stream;
  DataResource<AssetsFinancials>? getPersonalAssetsFinancials() => _personalAssetsFinancialsController.valueOrNull;
  setPersonalAssetsFinancials(DataResource<AssetsFinancials>? dataRes) => _personalAssetsFinancialsController.sink.add(dataRes);

  fetchPersonalAssetsFinancials() async {
    DataResource<AssetsFinancials> dataRes;
    try {
      setPersonalAssetsFinancials(DataResource.loading());
      var response = await _apiProvider.getPersonalAssetsFinancials(token: currentUser?.apiToken);
      AssetsFinancials assetsFinancials = AssetsFinancials.fromJson(response);
      dataRes = DataResource.success(assetsFinancials);
      setPersonalAssetsFinancials(dataRes);
    } on FormatException catch (error) {
      dataRes =  DataResource.failure(error.message);
      setPersonalAssetsFinancials(dataRes);
      print('$LOG_TAG fetchPersonalAssetsFinancials FormatException: ${error.message}');
    } catch (error) {
      dataRes =  DataResource.failure('something_went_wrong');
      setPersonalAssetsFinancials(dataRes);
      print('$LOG_TAG fetchPersonalAssetsFinancials Exception: ${error.toString()}');
    }
  }

  final _privateAssetsController = BehaviorSubject<DataResource<List<PrivateAssetModel>>?>();
  get privateAssetsStream => _privateAssetsController.stream;
  DataResource<List<PrivateAssetModel>>? getPrivateAssets() => _privateAssetsController.valueOrNull;
  setPrivateAssets(DataResource<List<PrivateAssetModel>>? dataRes) => _privateAssetsController.sink.add(dataRes);

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
      print('$LOG_TAG fetchPrivateAssets FormatException: ${error.message}');
    } catch (error) {
      dataRes =  DataResource.failure('something_went_wrong');
      setPrivateAssets(dataRes);
      print('$LOG_TAG fetchPrivateAssets Exception: ${error.toString()}');
    }
  }

  final _publicAssetsController = BehaviorSubject<DataResource<List<PublicAssetModel>>?>();
  get publicAssetsStream => _publicAssetsController.stream;
  DataResource<List<PublicAssetModel>>? getPublicAssets() => _publicAssetsController.valueOrNull;
  setPublicAssets(DataResource<List<PublicAssetModel>>? dataRes) => _publicAssetsController.sink.add(dataRes);

  fetchPublicAssets() async {
    DataResource<List<PublicAssetModel>> dataRes;
    try {
      setPublicAssets(DataResource.loading());
      var response = await _apiProvider.getPublicAssets();
      List<PublicAssetModel> assets = PublicAssetListModel.fromJson(response).assets;

      // assets.forEach((element) {
      //   element.initAssetMetasLists();
      // });

      dataRes = DataResource.success(assets);
      setPublicAssets(dataRes);
    } on FormatException catch (error) {
      dataRes =  DataResource.failure(error.message);
      setPublicAssets(dataRes);
      print('$LOG_TAG fetchPublicAssets FormatException: ${error.message}');
    } catch (error) {
      dataRes =  DataResource.failure('something_went_wrong');
      setPublicAssets(dataRes);
      print('$LOG_TAG fetchPublicAssets Exception: ${error.toString()}');
    }
  }


  disposeStreams(){
    _currentUserController.close();
    _userPortfolioFinancialsController.close();
    _publicAssetsController.close();
    _privateAssetsFinancialsController.close();
    _publicAssetsFinancialsController.close();
    _personalAssetsFinancialsController.close();
    _privateAssetsController.close();
  }

}