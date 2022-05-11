import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wave_flutter/bloc/general_bloc.dart';
import 'package:wave_flutter/models/assets_financials.dart';
import 'package:wave_flutter/models/news_model.dart';
import 'package:wave_flutter/models/top_performing_gainers_loosers_model.dart';
import 'package:wave_flutter/models/user_model.dart';
import 'package:wave_flutter/models/user_portfolio_financials.dart';
import 'package:wave_flutter/services/api_provider.dart';
import 'package:wave_flutter/services/data_resource.dart';
import 'package:wave_flutter/storage/data_store.dart';

class MyPortfolioScreenBloc {

  final ApiProvider _apiProvider;
  final DataStore _dataStore;
  final GeneralBloc _generalBLoc;
  MyPortfolioScreenBloc({required apiProvider, required generalBLoc, required dataStore}):
        _apiProvider = apiProvider, _generalBLoc = generalBLoc, _dataStore = dataStore;

  static const String LOG_TAG = 'MyPortfolioScreenBloc';

  UserModel? get currentUser => _dataStore.userModel;

  get currentUserStream => _generalBLoc.currentUserStream;
  DataResource<UserModel>? getCurrentUser() => _generalBLoc.getCurrentUser();
  setCurrentUser(DataResource<UserModel>? dataRes) => _generalBLoc.setCurrentUser(dataRes);

  get userPortfolioFinancialsControllerStream => _generalBLoc.userPortfolioFinancialsControllerStream;
  DataResource<UserPortfolioFinancials>? getUserPortfolioFinancials() => _generalBLoc.getUserPortfolioFinancials();
  setUserPortfolioFinancials(DataResource<UserPortfolioFinancials>? dataRes) => _generalBLoc.setUserPortfolioFinancials(dataRes);
  fetchUserPortfolioFinancials() => _generalBLoc.fetchUserPortfolioFinancials();

  get privateAssetsFinancialsStream => _generalBLoc.privateAssetsFinancialsStream;
  DataResource<AssetsFinancials>? getPrivateAssetsFinancials() => _generalBLoc.getPrivateAssetsFinancials();
  setPrivateAssetsFinancials(DataResource<AssetsFinancials>? dataRes) => _generalBLoc.setPrivateAssetsFinancials(dataRes);
  fetchPrivateAssetsFinancials() => _generalBLoc.fetchPrivateAssetsFinancials();

  get publicAssetsFinancialsStream => _generalBLoc.publicAssetsFinancialsStream;
  DataResource<AssetsFinancials>? getPublicAssetsFinancials() => _generalBLoc.getPublicAssetsFinancials();
  setPublicAssetsFinancials(DataResource<AssetsFinancials>? dataRes) => _generalBLoc.setPublicAssetsFinancials(dataRes);
  fetchPublicAssetsFinancials() => _generalBLoc.fetchPublicAssetsFinancials();

  get personalAssetsFinancialsStream => _generalBLoc.personalAssetsFinancialsStream;
  DataResource<AssetsFinancials>? getPersonalAssetsFinancials() => _generalBLoc.getPersonalAssetsFinancials();
  setPersonalAssetsFinancials(DataResource<AssetsFinancials>? dataRes) => _generalBLoc.setPersonalAssetsFinancials(dataRes);
  fetchPersonalAssetsFinancials() => _generalBLoc.fetchPersonalAssetsFinancials();

  disposeStreams(){
  }
}