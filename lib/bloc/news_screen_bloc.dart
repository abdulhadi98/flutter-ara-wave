import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wave_flutter/models/news_model.dart';
import 'package:wave_flutter/models/personal_asset_model.dart';
import 'package:wave_flutter/models/user_model.dart';
import 'package:wave_flutter/services/api_provider.dart';
import 'package:wave_flutter/services/data_resource.dart';
import 'package:wave_flutter/storage/data_store.dart';

class NewsScreenBloc{

  final ApiProvider _apiProvider;
  final DataStore _dataStore;
  NewsScreenBloc({required apiProvider, required dataStore}):
        _apiProvider = apiProvider, _dataStore = dataStore;

  static const String LOG_TAG = 'NewsScreenBloc';

  final _newsAssetsController = BehaviorSubject<DataResource<List<NewsModel>>>();
  get newsAssetsStream => _newsAssetsController.stream;
  DataResource<List<NewsModel>> getNewsAssets() => _newsAssetsController.value;
  setNewsAssets(DataResource<List<NewsModel>> dataRes) => _newsAssetsController.sink.add(dataRes);

  _fetchAssetsNews() async {
    DataResource<List<NewsModel>> dataRes;
    try {
      setNewsAssets(DataResource.loading());
      var response = await _apiProvider.getMyAssetsNews();
      List<NewsModel> newsList = NewsListModel.fromJson(response).news;
      dataRes = DataResource.success(newsList);
      setNewsAssets(dataRes);
    } on FormatException catch (error) {
      dataRes =  DataResource.failure(error.message);
      setNewsAssets(dataRes);
      print('$LOG_TAG _fetchAssetsNews FormatException: ${error.message}');
    } catch (error) {
      dataRes =  DataResource.failure('something_went_wrong');
      setNewsAssets(dataRes);
      print('$LOG_TAG _fetchAssetsNews Exception: ${error.toString()}');
    }
  }

  fetchNewsPrivateAssets() async {
    _fetchAssetsNews();
  }
  fetchNewsPublicAssets() async {
    _fetchAssetsNews();
  }
  fetchNewsPersonalAssets() async {
    _fetchAssetsNews();
  }

  final _newsWorldController = BehaviorSubject<DataResource<List<NewsModel>>>();
  get newsWorldStream => _newsWorldController.stream;
  DataResource<List<NewsModel>> getNewsWorld() => _newsWorldController.value;
  setNewsWorld(DataResource<List<NewsModel>> dataRes) => _newsWorldController.sink.add(dataRes);

  _fetchWorldNews() async {
    DataResource<List<NewsModel>> dataRes;
    try {
      setNewsWorld(DataResource.loading());
      var response = await _apiProvider.getWorldNews();
      List<NewsModel> newsList = NewsListModel.fromJson(response).news;
      dataRes = DataResource.success(newsList);
      setNewsWorld(dataRes);
    } on FormatException catch (error) {
      dataRes =  DataResource.failure(error.message);
      setNewsWorld(dataRes);
      print('$LOG_TAG _fetchWorldNews FormatException: ${error.message}');
    } catch (error) {
      dataRes =  DataResource.failure('something_went_wrong');
      setNewsWorld(dataRes);
      print('$LOG_TAG _fetchWorldNews Exception: ${error.toString()}');
    }
  }

  fetchNewsPrivateWorld() async {
    _fetchWorldNews();
  }
  fetchNewsPublicWorld() async {
   _fetchWorldNews();
  }
  fetchNewsPersonalWorld() async {
    _fetchWorldNews();
  }


  disposeStreams(){
    _newsWorldController.close();
    _newsAssetsController.close();
  }
}