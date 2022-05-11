import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wave_flutter/helper/enums.dart';

class NewsScreenController{

  init({required tickerProvider}){
    newsTypeTabController = TabController(length: 2, vsync: tickerProvider,);

    newsTypeTabController.addListener(() {
      switch(newsTypeTabController.index){
        case 0:
          setNewsType(NewsType.WORLD);
          setScreenTitleKey(getScreenTitle(getHoldingsTypeWorld()));
          break;

        case 1:
          setNewsType(NewsType.MY_ASSETS);
          setScreenTitleKey(getScreenTitle(getHoldingsTypeAsset()));
          break;
      }

    });

    // _holdingsTypeAssetController.stream.listen((event) {
    //   setScreenTitleKey(getScreenTitle(getHoldingsTypeAsset));
    // });

    // _holdingsTypeWorldController.stream.listen((event) {
    //   setScreenTitleKey(getScreenTitle(getHoldingsTypeWorld));
    // });
  }
  late TabController newsTypeTabController;

  final BehaviorSubject<HoldingsType> _holdingsTypeAssetController = BehaviorSubject<HoldingsType>.seeded(HoldingsType.PRIVATE);
  get holdingsTypeAssetStream => _holdingsTypeAssetController.stream;
  HoldingsType getHoldingsTypeAsset() => _holdingsTypeAssetController.value;
  setHoldingsTypeAsset(HoldingsType type) => _holdingsTypeAssetController.sink.add(type);

  final BehaviorSubject<HoldingsType> _holdingsTypeWorldController = BehaviorSubject<HoldingsType>.seeded(HoldingsType.PRIVATE);
  get holdingsTypeWorldStream => _holdingsTypeWorldController.stream;
  HoldingsType getHoldingsTypeWorld() => _holdingsTypeWorldController.value;
  setHoldingsTypeWorld(HoldingsType type) => _holdingsTypeWorldController.sink.add(type);

  final BehaviorSubject<NewsType> _newsTypeController = BehaviorSubject<NewsType>.seeded(NewsType.WORLD);
  get newsTypeStream => _newsTypeController.stream;
  NewsType getNewsType() => _newsTypeController.value;
  setNewsType(NewsType type) => _newsTypeController.sink.add(type);

  final BehaviorSubject<String> _screenTitleKeyController = BehaviorSubject<String>.seeded('private');
  get screenTitleKeyStream => _screenTitleKeyController.stream;
  String getScreenTitleKey() => _screenTitleKeyController.value;
  setScreenTitleKey(String titleKey) => _screenTitleKeyController.sink.add(titleKey);

  String getScreenTitle(type){
    switch(type){
      case HoldingsType.PRIVATE:
        return 'private_Investments';
      case HoldingsType.PUBLIC:
        return 'public_Investments';
      case HoldingsType.PERSONAL:
        return 'personal_Investments';

      default: return 'personal_Investments';
    }
  }

  disposeStreams(){
    _holdingsTypeAssetController.close();
    _newsTypeController.close();
    newsTypeTabController.dispose();
  }
}