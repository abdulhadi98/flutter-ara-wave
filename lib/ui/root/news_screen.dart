import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:wave_flutter/di/news_screen_di.dart';
import 'package:wave_flutter/helper/app_colors.dart';
import 'package:wave_flutter/helper/app_fonts.dart';
import 'package:wave_flutter/helper/enums.dart';
import 'package:wave_flutter/models/news_model.dart';
import 'package:wave_flutter/services/data_resource.dart';
import 'package:wave_flutter/ui/common_widgets/base_statefull_widget.dart';
import 'package:wave_flutter/ui/common_widgets/error_message_widget.dart';
import 'package:wave_flutter/ui/common_widgets/holdings_type_tab_item.dart';
import 'package:wave_flutter/ui/common_widgets/home_screen_header.dart';
import 'package:wave_flutter/ui/news/news_item.dart';

class NewsScreen extends BaseStateFullWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends BaseStateFullWidgetState<NewsScreen> with NewsScreenDi{

  @override
  void initState() {
    super.initState();

    initScreenDi();
    uiController.init(tickerProvider: this);

    newsBloc.fetchNewsPrivateWorld();
    newsBloc.fetchNewsPrivateAssets();
  }

  @override
  void dispose() {
    newsBloc.disposeStreams();
    uiController.disposeStreams();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: WillPopScope(
        onWillPop: () => rootScreenController.setCurrentScreen(AppMainScreens.HOME_SCREEN),
        child: Container(
          padding: EdgeInsets.only(top: mediaQuery.padding.top, right: width* .05, left: width* .05,),
          child: Column(
            children: [
              SizedBox(height: height* 0.02),
              buildHeader(),
              SizedBox(height: height* 0.040),
              buildNewsTypeTabs(),
              SizedBox(height: height* 0.040),
              buildNewsTabBarView(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHeader(){
    return buildHeaderComponents(
        titleWidget: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                SizedBox(width: width* .04),
                GestureDetector(
                    onTap: () => rootScreenController.setCurrentScreen(AppMainScreens.HOME_SCREEN),
                    child: Icon(Icons.arrow_back_ios_rounded, color: AppColors.gray, size: width* .075,),
                ),
                SizedBox(width: width* .06),
                StreamBuilder<String>(
                    initialData: 'private',
                    stream: uiController.screenTitleKeyStream,
                    builder: (context, titleKeySnapshot) {
                      return Text(
                        appLocal.trans(titleKeySnapshot.data!),
                        style: TextStyle(
                          fontSize: AppFonts.getMediumFontSize(context),
                          color: Colors.white,
                          height: 1.0,
                        ),
                      );
                    }
                ),
              ],
            ),
          ],
        ),
        height: height,
        width: width,
        context: context,
        appLocal: appLocal,
        logoTitleKey: 'news',
        isSecondRowVisible: false
    );
  }

  Widget buildNewsTypeTabs(){
    return StreamBuilder<NewsType>(
        initialData: NewsType.WORLD,
        stream: uiController.newsTypeStream,
        builder: (context, newsTypeSnapshot) {
          return Stack(
            children: [
              Positioned(
                bottom: .5,
                right: 0,
                left: 0,
                child: Container(
                  // width: double.infinity,
                  height: 1,
                  color: Colors.white.withOpacity(.3),
                ),
              ),
              TabBar(
                indicatorColor: AppColors.white,
                labelPadding: EdgeInsets.symmetric(vertical: height* .012,),
                tabs: [
                  buildNewsTypeTabItem('world', newsTypeSnapshot.data == NewsType.WORLD),
                  buildNewsTypeTabItem('my_assets', newsTypeSnapshot.data == NewsType.MY_ASSETS),
                ],
                controller: uiController.newsTypeTabController,
              ),
            ],
          );
        });
  }

  Widget buildNewsTypeTabItem(titleKey, isSelected,) {
    return Text(
      appLocal.trans(titleKey),
      style: TextStyle(
        fontSize: AppFonts.getMediumFontSize(context),
        color: isSelected ? Colors.white : Colors.white.withOpacity(.3),
        height: 1.0,
      ),
    );
  }

  Widget buildNewsTabBarView(){
    return Expanded(
      child: TabBarView(
        controller: uiController.newsTypeTabController,
        children: [
          buildNewsWorldComponents(),
          buildNewsAssetComponents(),
        ],
        physics: const CustomPageViewScrollPhysics(),
      ),
    );
  }

  Widget buildNewsWorldComponents(){
    return StreamBuilder<HoldingsType>(
      initialData: HoldingsType.PRIVATE,
      stream: uiController.holdingsTypeWorldStream,
      builder: (context, holdingsTypeSnapshot) {
        uiController.setScreenTitleKey(uiController.getScreenTitle(holdingsTypeSnapshot.data));

        return StreamBuilder<DataResource<List<NewsModel>>>(
          stream: newsBloc.newsWorldStream,
          builder: (context, newsSnapshot) {
            return Column(
              children: [
                buildHoldingTypeTaps(NewsType.WORLD, holdingsTypeSnapshot.data!),
                SizedBox(height: height* .030),
                buildNewsListResult(newsSnapshot),
              ],
            );
          },
        );
      },
    );
  }

  Widget buildNewsAssetComponents(){
    return StreamBuilder<HoldingsType>(
      initialData: HoldingsType.PRIVATE,
      stream: uiController.holdingsTypeAssetStream,
      builder: (context, holdingsTypeSnapshot) {
        uiController.setScreenTitleKey(uiController.getScreenTitle(holdingsTypeSnapshot.data));
        return StreamBuilder<DataResource<List<NewsModel>>>(
          stream: newsBloc.newsAssetsStream,
          builder: (context, newsSnapshot) {
            return Column(
              children: [
                buildHoldingTypeTaps(NewsType.MY_ASSETS, holdingsTypeSnapshot.data!),
                SizedBox(height: height* .030),
                buildNewsListResult(newsSnapshot),
              ],
            );
          },
        );
      },
    );
  }

  Widget buildNewsListResult(newsSnapshot){
    if (newsSnapshot.hasData && newsSnapshot.data != null) {
      switch (newsSnapshot.data!.status) {
        case Status.LOADING:
          return Expanded(child: Center(child: CircularProgressIndicator(),),);
        case Status.SUCCESS:
          return buildNewsList(news: newsSnapshot.data!.data);
        case Status.NO_RESULTS:
          return ErrorMessageWidget(messageKey: 'no_result_found_message', image: 'assets/images/ic_not_found.png');
        case Status.FAILURE:
          return ErrorMessageWidget(messageKey: newsSnapshot.data?.message??'', image: 'assets/images/ic_error.png');

        default:
          return Container();
      }
    } else {
      return Container();
    }
  }

  Widget buildHoldingTypeTaps(NewsType newsType, HoldingsType holdingsType){
    onClick(holdingType) {
      switch(newsType){
        case NewsType.WORLD:
          uiController.setHoldingsTypeWorld(holdingType, );
          fetchResults(newsType, holdingType,);
          break;

        case NewsType.MY_ASSETS:
          uiController.setHoldingsTypeAsset(holdingType);
          fetchResults(newsType, holdingType,);
          break;
      }
    }

    return Row(
      children: [
        HoldingsTypeTapItem(HoldingsType.PRIVATE, holdingsType == HoldingsType.PRIVATE,  appLocal.trans("private"), onClick),
        SizedBox(width: width* .020),
        HoldingsTypeTapItem(HoldingsType.PUBLIC, holdingsType == HoldingsType.PUBLIC,  appLocal.trans("public"), onClick),
        SizedBox(width: width* .020),
        HoldingsTypeTapItem(HoldingsType.PERSONAL, holdingsType == HoldingsType.PERSONAL,  appLocal.trans("personal"), onClick),
      ],
    );
  }

  Widget buildNewsList({List<NewsModel>? news}){
    return Expanded(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: news?.length,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          return Column(
            children: [
              NewsItem(newsItem: news![index]),
              SizedBox(height: height*.025,),
            ],
          );
        },
      ),
    );
  }

  void fetchResults(NewsType newsType, holdingType) {
    switch(holdingType){
      case HoldingsType.PRIVATE:
        newsType==NewsType.MY_ASSETS ? newsBloc.fetchNewsPrivateAssets() : newsBloc.fetchNewsPrivateWorld();
        break;

      case HoldingsType.PUBLIC:
        newsType==NewsType.MY_ASSETS ? newsBloc.fetchNewsPublicAssets() : newsBloc.fetchNewsPublicWorld();
        break;

      case HoldingsType.PERSONAL:
        newsType==NewsType.MY_ASSETS ? newsBloc.fetchNewsPersonalAssets() : newsBloc.fetchNewsPersonalWorld();
        break;
    }
  }
}

class CustomPageViewScrollPhysics extends ScrollPhysics {
  const CustomPageViewScrollPhysics({ScrollPhysics? parent}) : super(parent: parent);

  @override
  CustomPageViewScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomPageViewScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  SpringDescription get spring => const SpringDescription(
    mass: 80,
    stiffness: 100,
    damping: 6,
  );
}
