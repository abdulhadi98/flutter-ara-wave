import 'dart:convert';

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

import '../ui/root/home_screen.dart';

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

  _fetchAssetsNewsPrivate() async {
    DataResource<List<NewsModel>> dataRes;
    List<NewsModel> newsList = [];
    setNewsAssets(DataResource.loading());

    var url = Uri.parse('https://rss.app/feeds/_0DW7pkozaKuS0nHk.xml');
    print(url);
    try {
      http.Response res = await http.get(url);
      String data = res.body;
      //  print(data);
      var raw = xml.XmlDocument.parse(data);

      // var raw = xml.parse(data);
      var elements = raw.findAllElements('item');
      elements.forEach((element) {
        dynamic media = element.findElements('media:content');
        //    print(media);

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

        print(createdAt);
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
      setNewsAssets(dataRes);
    } catch (e) {
      print(e);
      dataRes = DataResource.failure('something_went_wrong');
      setNewsAssets(dataRes);
    }
  }

  _fetchAssetsNewsPublic() async {
    DataResource<List<NewsModel>> dataRes;
    List<NewsModel> newsList = [];
    setNewsAssets(DataResource.loading());
    try {
      var url = Uri.parse('https://rss.app/feeds/_oqmXFF0Mtb59fOtg.xml');
      print(url);
      http.Response res = await http.get(url);
      String data = res.body;
      //  print(data);
      var raw = xml.XmlDocument.parse(data);

      // var raw = xml.parse(data);
      var elements = raw.findAllElements('item');
      elements.forEach((element) {
        dynamic media = element.findElements('media:content');
        //  print(media);
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
      setNewsAssets(dataRes);
    } catch (e) {
      print(e);
      dataRes = DataResource.failure('something_went_wrong');
      setNewsAssets(dataRes);
    }
  }

  _fetchAssetsNewsPersonal() async {
    DataResource<List<NewsModel>> dataRes;
    List<NewsModel> newsList = [];
    setNewsAssets(DataResource.loading());

    List<String> newsFeedList = [];
    String? apiToken = HomeScreen.apiToken;
    var request;
    var response;
    var url = Uri.parse(
      'https://wave.aratech.co/api/get-my-assets-news',
    );
    print('///////////' + url.toString() + '//tokennnnnn///' + apiToken!);

    request = http.MultipartRequest('POST', url);
    request.fields['api_token'] = apiToken;
    try {
      response = await request.send();
      var xx = await http.Response.fromStream(response);
      var x = jsonDecode(xx.body);

      print('///////////////////////////////////////////////////');
      print(x.toString());
      print('///////////////////////////////////////////////////');

      Map<dynamic, dynamic> payload = x['data'];
      List<dynamic> newsLinks = payload['personal'];
      print(newsLinks);
      if (newsLinks.isNotEmpty)
        newsLinks.forEach((element) async {
          var url = Uri.parse(element.toString());

          print(url);
          http.Response res = await http.get(url);
          String data = res.body;
          //  print(data);
          var raw = xml.XmlDocument.parse(data);

          // var raw = xml.parse(data);
          var elements = raw.findAllElements('item');
          elements.forEach((element) {
            dynamic media = element.findElements('media:content');
            // print(media);

            if (media.isEmpty)
              media = '';
            else
              media = element
                      .findElements('media:content')
                      .first
                      .getAttribute('url') ??
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

          dataRes = DataResource.success(newsList);
          setNewsAssets(dataRes);
        });
      else {
        dataRes = DataResource.noResults();
        setNewsAssets(dataRes);
      }
    } catch (e) {
      print(e);
      dataRes = DataResource.failure('something_went_wrong');
      setNewsAssets(dataRes);
    }
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
    _fetchAssetsNewsPrivate();
  }

  fetchNewsPublicAssets() async {
    _fetchAssetsNewsPublic();
  }

  fetchNewsPersonalAssets() async {
    _fetchAssetsNewsPersonal();
  }

  //////////////////////////////////spr
  final _newsWorldController = BehaviorSubject<DataResource<List<NewsModel>>>();
  get newsWorldStream => _newsWorldController.stream;
  DataResource<List<NewsModel>> getNewsWorld() => _newsWorldController.value;
  setNewsWorld(DataResource<List<NewsModel>> dataRes) =>
      _newsWorldController.sink.add(dataRes);

  _fetchWorldNewspPrivate() async {
    DataResource<List<NewsModel>> dataRes;
    List<NewsModel> newsList = [];
    setNewsWorld(DataResource.loading());
    try {
      var url = Uri.parse('https://rss.app/feeds/_ILCMJ8FEHa0dArK0.xml');
      print(url);
      http.Response res = await http.get(url);
      String data = res.body;
      //  print(data);
      var raw = xml.XmlDocument.parse(data);

      // var raw = xml.parse(data);
      var elements = raw.findAllElements('item');
      elements.forEach((element) {
        dynamic media = element.findElements('media:content');
        // print(media);

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
      setNewsWorld(dataRes);
    } catch (e) {
      print(e);
      dataRes = DataResource.failure('something_went_wrong');
      setNewsWorld(dataRes);
    }
  }

  _fetchWorldNewspPublic() async {
    DataResource<List<NewsModel>> dataRes;
    List<NewsModel> newsList = [];
    setNewsWorld(DataResource.loading());
    try {
      var url = Uri.parse('https://rss.app/feeds/_JOQu14fBv9nPTP5v.xml');
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
      setNewsWorld(dataRes);
    } catch (e) {
      print(e);
      dataRes = DataResource.failure('something_went_wrong');
      setNewsWorld(dataRes);
    }
  }

  _fetchWorldNewspPersonal() async {
    DataResource<List<NewsModel>> dataRes;
    List<NewsModel> newsList = [];
    setNewsWorld(DataResource.loading());
    try {
      var url = Uri.parse('https://rss.app/feeds/_97yQ7fMQXX23mjvt.xml');
      print(url);
      http.Response res = await http.get(url);
      String data = res.body;
      //  print(data);
      var raw = xml.XmlDocument.parse(data);

      // var raw = xml.parse(data);
      var elements = raw.findAllElements('item');
      elements.forEach((element) {
        dynamic media = element.findElements('media:content');
        // print(media);

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
      setNewsWorld(dataRes);
    } catch (e) {
      print(e);
      dataRes = DataResource.failure('something_went_wrong');
      setNewsWorld(dataRes);
    }
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
    _fetchWorldNewspPrivate();
  }

  fetchNewsPublicWorld() async {
    _fetchWorldNewspPublic();
  }

  fetchNewsPersonalWorld() async {
    _fetchWorldNewspPersonal();
  }

  disposeStreams() {
    _newsWorldController.close();
    _newsAssetsController.close();
  }
}
