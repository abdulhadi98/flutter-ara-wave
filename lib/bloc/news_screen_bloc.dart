import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wave_flutter/models/news_model.dart';
import 'package:wave_flutter/models/personal_asset_model.dart';
import 'package:wave_flutter/models/user_model.dart';
import 'package:wave_flutter/services/api_provider.dart';
import 'package:wave_flutter/services/data_resource.dart';
import 'package:wave_flutter/storage/data_store.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;

class NewsScreenBloc {
  final ApiProvider _apiProvider;
  final DataStore _dataStore;
  NewsScreenBloc({required apiProvider, required dataStore})
      : _apiProvider = apiProvider,
        _dataStore = dataStore;

  static const String LOG_TAG = 'NewsScreenBloc';

  final _newsAssetsController =
      BehaviorSubject<DataResource<List<NewsModel>>>();
  get newsAssetsStream => _newsAssetsController.stream;
  DataResource<List<NewsModel>> getNewsAssets() => _newsAssetsController.value;
  setNewsAssets(DataResource<List<NewsModel>> dataRes) =>
      _newsAssetsController.sink.add(dataRes);

  fetchAssetsNewsFromXml() async {
    DataResource<List<NewsModel>> dataRes;
    List<NewsModel> newsList = [];
    setNewsAssets(DataResource.loading());
    var url = Uri.parse('https://rss.app/feeds/tHl0ppMop8sAho4v.xml');
    print(url);
    http.Response res = await http.get(url);
    String data = res.body;
    var raw = xml.XmlDocument.parse(data);

    // var raw = xml.parse(data);
    var elements = raw.findAllElements('item');
    elements.forEach((element) {
      var media =
          element.findElements('media:content').first.getAttribute('url');
      var title = element.findElements('title').single.text;
      var description = element.findElements('title').single.text;

      var formattedDescription = 'formatted';
      var url = element.findElements('link').single.text;
      var author = element.findElements('dc:creator').single.text;
      var date = DateTime.now();
      var hash = 'hash';
      var createdAt = element.findElements('pubDate').single.text;
      newsList.add(NewsModel(
        id: '1',
        enclosure: Enclosure(type: '1', url: media!, size: '3'),
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

    dataRes = DataResource.success(newsList);
    setNewsAssets(dataRes);
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

  _fetchAssetsNews() async {
    DataResource<List<NewsModel>> dataRes;
    List<NewsModel> newsList = [];
    setNewsAssets(DataResource.loading());
    var url = Uri.parse('https://rss.app/feeds/tHl0ppMop8sAho4v.xml');
    print(url);
    http.Response res = await http.get(url);
    String data = res.body;
    var raw = xml.XmlDocument.parse(data);

    // var raw = xml.parse(data);
    var elements = raw.findAllElements('item');
    elements.forEach((element) {
      var media =
          element.findElements('media:content').first.getAttribute('url');
      var title = element.findElements('title').single.text;
      var description = element.findElements('title').single.text;

      var formattedDescription = 'formatted';
      var url = element.findElements('link').single.text;
      var author = element.findElements('dc:creator').single.text;
      var date = DateTime.now();
      var hash = 'hash';
      var createdAt = element.findElements('pubDate').single.text;
      newsList.add(NewsModel(
        id: '1',
        enclosure: Enclosure(type: '1', url: media!, size: '3'),
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

    dataRes = DataResource.success(newsList);
    setNewsAssets(dataRes);
    // DataResource<List<NewsModel>> dataRes;
    // try {
    //   setNewsAssets(DataResource.loading());
    //   var response = await _apiProvider.getMyAssetsNews();
    //   List<NewsModel> newsList = NewsListModel.fromJson(response).news;
    //   dataRes = DataResource.success(newsList);
    //   setNewsAssets(dataRes);
    // } on FormatException catch (error) {
    //   dataRes = DataResource.failure(error.message);
    //   setNewsAssets(dataRes);
    //   print('$LOG_TAG _fetchAssetsNews FormatException: ${error.message}');
    // } catch (error) {
    //   dataRes = DataResource.failure('something_went_wrong');
    //   setNewsAssets(dataRes);
    //   print('$LOG_TAG _fetchAssetsNews Exception: ${error.toString()}');
    // }
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
  setNewsWorld(DataResource<List<NewsModel>> dataRes) =>
      _newsWorldController.sink.add(dataRes);

  _fetchWorldNews() async {
    DataResource<List<NewsModel>> dataRes;
    List<NewsModel> newsList = [];
    setNewsAssets(DataResource.loading());
    var url = Uri.parse('https://rss.app/feeds/HU7be1PomjovZjnw.xml');
    print(url);
    http.Response res = await http.get(url);
    String data = res.body;
    var raw = xml.XmlDocument.parse(data);

    // var raw = xml.parse(data);
    var elements = raw.findAllElements('item');
    elements.forEach((element) {
      var media =
          element.findElements('media:content').first.getAttribute('url');
      var title = element.findElements('title').single.text;
      var description = element.findElements('title').single.text;

      var formattedDescription = 'formatted';
      var url = element.findElements('link').single.text;
      var author = element.findElements('dc:creator').single.text;
      var date = DateTime.now();
      var hash = 'hash';
      var createdAt = element.findElements('pubDate').single.text;
      newsList.add(NewsModel(
        id: '1',
        enclosure: Enclosure(type: '1', url: media!, size: '3'),
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

    dataRes = DataResource.success(newsList);
    setNewsWorld(dataRes);

    // DataResource<List<NewsModel>> dataRes;
    // try {
    //   setNewsWorld(DataResource.loading());
    //   var response = await _apiProvider.getWorldNews();

    //   List<NewsModel> newsList = NewsListModel.fromJson(response).news;
    //   dataRes = DataResource.success(newsList);
    //   setNewsWorld(dataRes);
    // } on FormatException catch (error) {
    //   dataRes = DataResource.failure(error.message);
    //   setNewsWorld(dataRes);
    //   print('$LOG_TAG _fetchWorldNews FormatException: ${error.message}');
    // } catch (error) {
    //   dataRes = DataResource.failure('something_went_wrong');
    //   setNewsWorld(dataRes);
    //   print('$LOG_TAG _fetchWorldNews Exception: ${error.toString()}');
    // }
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

  disposeStreams() {
    _newsWorldController.close();
    _newsAssetsController.close();
  }
}
