import 'dart:convert';

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
import 'package:xml2json/xml2json.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;

class HomeScreenBloc {
  final ApiProvider _apiProvider;
  final DataStore _dataStore;
  final GeneralBloc _generalBLoc;
  HomeScreenBloc(
      {required apiProvider, required generalBLoc, required dataStore})
      : _apiProvider = apiProvider,
        _generalBLoc = generalBLoc,
        _dataStore = dataStore;

  static const String LOG_TAG = 'HomeScreenBloc';

  UserModel? get currentUser => _dataStore.userModel;

  deleteCurrentUserData() async => await _dataStore.deleteCurrentUserData();

  get currentUserStream => _generalBLoc.currentUserStream;
  DataResource<UserModel>? getCurrentUser() => _generalBLoc.getCurrentUser();
  setCurrentUser(DataResource<UserModel>? dataRes) =>
      _generalBLoc.setCurrentUser(dataRes);
  fetchMe() => _generalBLoc.fetchMe();

  get userPortfolioFinancialsControllerStream =>
      _generalBLoc.userPortfolioFinancialsControllerStream;
  DataResource<UserPortfolioFinancials>? getUserPortfolioFinancials() =>
      _generalBLoc.getUserPortfolioFinancials();
  setUserPortfolioFinancials(DataResource<UserPortfolioFinancials>? dataRes) =>
      _generalBLoc.setUserPortfolioFinancials(dataRes);
  fetchUserPortfolioFinancials() => _generalBLoc.fetchUserPortfolioFinancials();

  final _topPerformingGainersLoosersController =
      BehaviorSubject<DataResource<TopPerformingGainersLoosersModel>?>();
  get topPerformingGainersLoosersStream =>
      _topPerformingGainersLoosersController.stream;
  DataResource<TopPerformingGainersLoosersModel>?
      getTopPerformingGainersLoosers() =>
          _topPerformingGainersLoosersController.value;
  setTopPerformingGainersLoosers(
          DataResource<TopPerformingGainersLoosersModel>? dataRes) =>
      _topPerformingGainersLoosersController.sink.add(dataRes);

  fetchTopPerformingGainersLoosersAssets() async {
    DataResource<TopPerformingGainersLoosersModel> dataRes;
    try {
      setTopPerformingGainersLoosers(DataResource.loading());
      var response = await _apiProvider.getAssetsTopPerformance(
          token: currentUser?.apiToken);
      TopPerformingGainersLoosersModel topPerformingGainersLoosersModel =
          TopPerformingGainersLoosersModel.fromJson(response);
      dataRes = DataResource.success(topPerformingGainersLoosersModel);
      setTopPerformingGainersLoosers(dataRes);
    } on FormatException catch (error) {
      dataRes = DataResource.failure(error.message);
      setTopPerformingGainersLoosers(dataRes);
      print(
          '$LOG_TAG fetchTopPerformingGainersLoosersAssets FormatException: ${error.message})');
    } catch (error) {
      dataRes = DataResource.failure('something_went_wrong');
      setTopPerformingGainersLoosers(dataRes);
      print(
          '$LOG_TAG fetchTopPerformingGainersLoosersAssets Exception: ${error.toString()})');
    }
  }

  final _topNewsController = BehaviorSubject<DataResource<List<NewsModel>>>();
  get topNewsStream => _topNewsController.stream;
  DataResource<List<NewsModel>> getTopNews() => _topNewsController.value;
  setTopNews(DataResource<List<NewsModel>> dataRes) =>
      _topNewsController.sink.add(dataRes);

  fetchNewsFromXml() async {
    DataResource<List<NewsModel>> dataRes;
    List<NewsModel> newsList = [];
    setTopNews(DataResource.loading());
    try {
      var url = Uri.parse('https://rss.app/feeds/_mgZeUOL131c18V2D.xml');
      print(url);
      http.Response res = await http.get(url);
      String data = res.body;
      //  print(data);
      var raw = xml.XmlDocument.parse(data);

      // var raw = xml.parse(data);
      var elements = raw.findAllElements('item');
      elements.forEach((element) {
        dynamic media = element.findElements('media:content');
     //   print(media);

      if (media.isEmpty)
          media = 'assets/images/app_icon_news.png';
        else
          media =
              element.findElements('media:content').first.getAttribute('url') ??
                  '';
        //first.getAttribute('url') ?? '';
        var title = element.findElements('title').single.text;
        var description = element.findElements('description').single.text;

        var formattedDescription = 'formatted';
        var url = element.findElements('link').single.text;
        var author = element.findElements('dc:creator').single.text;
        var date = DateTime.now();
        var hash = 'hash';
        dynamic createdAt = element.findElements('pubDate');
        if (createdAt.isEmpty)
          createdAt = '';
        else
          createdAt = createdAt.single.text;
        newsList.add(NewsModel(
          id: '1',
          enclosure: Enclosure(type: '1', url: media, size: '3'),
          title: title,
          description: description,
          formattedDescription: 'formatted',
          url: url,
          author: author,
          date: DateTime.now(),
          hash: 'hash',
          createdAt: createdAt,
        ));
      });
      if (newsList.isEmpty)
        dataRes = DataResource.noResults();
      else
        dataRes = DataResource.success(newsList);
      setTopNews(dataRes);
    } catch (e) {
      print(e);
      dataRes = DataResource.failure('something_went_wrong');
      setTopNews(dataRes);
    }

    // print(elements);
    // elements.map((node) {
    //   print('zzzzzzzzzzzzzzzzzzzzzzzzzz');

    //   print('zzzzzzzzzzzzzzzzzzzzzzzzzz');
    //   print(node.findElements('title').single.text);

    //   print('zzzzzzzzzzzzzzzzzzzzzzzzzz');
    // });

    // elements.map((element) {
    //   print(element.getAttribute('title'));
    // newsList.add(NewsModel(
    //     id: '1',
    //     enclosure: element.findElements('media:content').first.text == null
    //         ? null
    //         : Enclosure(
    //             type: '1', url:  element.findElements('media:content'). ['url'], size: '3'),
    //     title: element['title'] ?? 'title',
    //     description: element['description'] ?? 'description',
    // formattedDescription: 'formatted',
    // url: element['link'] ?? 'link',
    // author: element['dc:creator'] ?? 'creator',
    // date: DateTime.now(),
    // hash: 'hash',
    // createdAt: DateTime.now()));
    //  });

    //   newsList.add();
  }

  hFetchTopNews() async {
    DataResource<List<NewsModel>> dataRes;
    final Xml2Json xml2Json = Xml2Json();
    List<NewsModel> newsList = [];
    setTopNews(DataResource.loading());
    var url = Uri.parse('https://rss.app/feeds/trrL6L5yRVzomDm2.xml');
    print(url);
    http.Response res = await http.get(url);
    String data = res.body;
    xml2Json.parse(data);
    var jsonString = xml2Json.toParker();
    var decoded = jsonDecode(jsonString);
    print('zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz');
    List items = decoded['rss']['channel']['item'];
    print(items);
    items.forEach((element) {
      print(element['title']);
      // print(element['media']);

      newsList.add(NewsModel(
          id: '1',
          enclosure: element['media:content'] == null
              ? null
              : Enclosure(
                  type: '1', url: element['media:content']['url'], size: '3'),
          title: element['title'] ?? 'title',
          description: element['description'] ?? 'description',
          formattedDescription: 'formatted',
          url: element['link'] ?? 'link',
          author: element['dc:creator'] ?? 'creator',
          date: DateTime.now(),
          hash: 'hash',
          createdAt: 'asd'));
    });

    dataRes = DataResource.success(newsList);
    setTopNews(dataRes);

    // print(decoded['rss']['channel']['item']);
    print('zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz');
  }

  fetchTopNews() async {
    DataResource<List<NewsModel>> dataRes;
    final Xml2Json xml2Json = Xml2Json();

    try {
      setTopNews(DataResource.loading());
      var response = await _apiProvider.getTopNews();
      xml2Json.parse(response.toString());
      var jsonString = xml2Json.toParker();
      var data = jsonDecode(jsonString);
      print('zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz');
      print(data['rss']['channel']);

      List<NewsModel> newsList = NewsListModel.fromJson(response).news;
      dataRes = DataResource.success(newsList);
      setTopNews(dataRes);
    } on FormatException catch (error) {
      dataRes = DataResource.failure(error.message);
      setTopNews(dataRes);
      print('$LOG_TAG fetchTopNews FormatException: ${error.message}');
    } catch (error) {
      dataRes = DataResource.failure('something_went_wrong');
      setTopNews(dataRes);
      print('$LOG_TAG fetchTopNews Exception: ${error.toString()}');
    }
  }

  UserModel? get loggedUser => _dataStore.userModel;

  disposeStreams() {
    _topPerformingGainersLoosersController.close();
    _topNewsController.close();
  }
}
