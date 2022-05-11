import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wave_flutter/bloc/general_bloc.dart';
import 'package:wave_flutter/models/news_model.dart';
import 'package:wave_flutter/models/top_performing_gainers_loosers_model.dart';
import 'package:wave_flutter/models/user_model.dart';
import 'package:wave_flutter/models/user_portfolio_financials.dart';
import 'package:wave_flutter/services/api_provider.dart';
import 'package:wave_flutter/services/data_resource.dart';
import 'package:wave_flutter/storage/data_store.dart';

class HomeScreenBloc{

  final ApiProvider _apiProvider;
  final DataStore _dataStore;
  final GeneralBloc _generalBLoc;
  HomeScreenBloc({required apiProvider, required generalBLoc, required dataStore}):
        _apiProvider = apiProvider, _generalBLoc = generalBLoc, _dataStore = dataStore;

  static const String LOG_TAG = 'HomeScreenBloc';

  UserModel? get currentUser => _dataStore.userModel;

  deleteCurrentUserData() async => await _dataStore.deleteCurrentUserData();

  get currentUserStream => _generalBLoc.currentUserStream;
  DataResource<UserModel>? getCurrentUser() => _generalBLoc.getCurrentUser();
  setCurrentUser(DataResource<UserModel>? dataRes) => _generalBLoc.setCurrentUser(dataRes);
  fetchMe() => _generalBLoc.fetchMe();

  get userPortfolioFinancialsControllerStream => _generalBLoc.userPortfolioFinancialsControllerStream;
  DataResource<UserPortfolioFinancials>? getUserPortfolioFinancials() => _generalBLoc.getUserPortfolioFinancials();
  setUserPortfolioFinancials(DataResource<UserPortfolioFinancials>? dataRes) => _generalBLoc.setUserPortfolioFinancials(dataRes);
  fetchUserPortfolioFinancials() => _generalBLoc.fetchUserPortfolioFinancials();

  final _topPerformingGainersLoosersController = BehaviorSubject<DataResource<TopPerformingGainersLoosersModel>?>();
  get topPerformingGainersLoosersStream => _topPerformingGainersLoosersController.stream;
  DataResource<TopPerformingGainersLoosersModel>? getTopPerformingGainersLoosers() => _topPerformingGainersLoosersController.value;
  setTopPerformingGainersLoosers(DataResource<TopPerformingGainersLoosersModel>? dataRes) => _topPerformingGainersLoosersController.sink.add(dataRes);

  fetchTopPerformingGainersLoosersAssets() async {
    DataResource<TopPerformingGainersLoosersModel> dataRes;
    try {
      setTopPerformingGainersLoosers(DataResource.loading());
      var response = await _apiProvider.getAssetsTopPerformance(token: currentUser?.apiToken);
      TopPerformingGainersLoosersModel topPerformingGainersLoosersModel = TopPerformingGainersLoosersModel.fromJson(response);
      dataRes = DataResource.success(topPerformingGainersLoosersModel);
      setTopPerformingGainersLoosers(dataRes);
    } on FormatException catch (error) {
      dataRes =  DataResource.failure(error.message);
      setTopPerformingGainersLoosers(dataRes);
      print('$LOG_TAG fetchTopPerformingGainersLoosersAssets FormatException: ${error.message})');
    } catch (error) {
      dataRes =  DataResource.failure('something_went_wrong');
      setTopPerformingGainersLoosers(dataRes);
      print('$LOG_TAG fetchTopPerformingGainersLoosersAssets Exception: ${error.toString()})');
    }
  }

  final _topNewsController = BehaviorSubject<DataResource<List<NewsModel>>>();
  get topNewsStream => _topNewsController.stream;
  DataResource<List<NewsModel>> getTopNews() => _topNewsController.value;
  setTopNews(DataResource<List<NewsModel>> dataRes) => _topNewsController.sink.add(dataRes);

  fetchTopNews() async {
    DataResource<List<NewsModel>> dataRes;
    try {
      setTopNews(DataResource.loading());
      var response = await _apiProvider.getTopNews();
      List<NewsModel> newsList = NewsListModel.fromJson(response).news;
      dataRes = DataResource.success(newsList);
      setTopNews(dataRes);
    } on FormatException catch (error) {
      dataRes =  DataResource.failure(error.message);
      setTopNews(dataRes);
      print('$LOG_TAG fetchTopNews FormatException: ${error.message}');
    } catch (error) {
      dataRes =  DataResource.failure('something_went_wrong');
      setTopNews(dataRes);
      print('$LOG_TAG fetchTopNews Exception: ${error.toString()}');
    }
  }


  UserModel? get loggedUser => _dataStore.userModel;

  disposeStreams(){
    _topPerformingGainersLoosersController.close();
    _topNewsController.close();
  }
}