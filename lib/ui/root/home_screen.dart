import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:wave_flutter/di/home_screen_di.dart';
import 'package:wave_flutter/helper/app_colors.dart';
import 'package:wave_flutter/helper/app_fonts.dart';
import 'package:wave_flutter/helper/enums.dart';
import 'package:wave_flutter/helper/routes_helper.dart';
import 'package:wave_flutter/helper/utils.dart';
import 'package:wave_flutter/main.dart';
import 'package:wave_flutter/models/news_model.dart';
import 'package:wave_flutter/models/top_performing_gainers_loosers_model.dart';
import 'package:wave_flutter/models/user_model.dart';
import 'package:wave_flutter/models/user_portfolio_financials.dart';
import 'package:wave_flutter/services/data_resource.dart';
import 'package:wave_flutter/services/urls_container.dart';
import 'package:wave_flutter/storage/data_store.dart';
import 'package:wave_flutter/ui/common_widgets/base_statefull_widget.dart';
import 'package:wave_flutter/ui/common_widgets/image_widget.dart';
import 'package:wave_flutter/ui/common_widgets/show_add_asset_dialog.dart';
import 'package:wave_flutter/ui/news/news_item.dart';
import 'package:wave_flutter/ui/root/news_screen.dart';
import 'package:wave_flutter/ui/controllers/holdings_screen_controller.dart';
import 'package:wave_flutter/ui/root/holdings_screen.dart';

import '../../bloc/holdings_screen_bloc.dart';
import 'add_assets/personal/dialog_content/add_personal_asset_dialog_content.dart';
import 'add_assets/private/add_private_asset_dialog_content.dart';
import 'add_assets/public/add_public_asset_holding_dialog_content.dart';

class HomeScreen extends BaseStateFullWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends BaseStateFullWidgetState<HomeScreen>
    with HomeScreenDi {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    initScreenDi();

    homeScreenBloc.fetchMe();
    homeScreenBloc.fetchUserPortfolioFinancials();
    homeScreenBloc.fetchTopPerformingGainersLoosersAssets();
    homeScreenBloc.fetchTopNews();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          top: mediaQuery.padding.top,
          right: width * .05,
          left: width * .05,
        ),
        child: Column(
          children: [
            SizedBox(height: height * 0.02),
            buildHeaderComponents(),
            SizedBox(height: height * 0.020),
            buildGridButtons(),
            SizedBox(height: height * 0.060),
            buildTopPerformingGainersLoosersResult(),
            // SizedBox(height: height* 0.060),
            // buildGainersLosersResult(),
            SizedBox(height: height * 0.060),
            buildTopNewsResult(),
            SizedBox(height: height * 0.060),
          ],
        ),
      ),
      drawer: buildDrawerContent(),
    );
  }

  Widget buildUserProfileImage() {
    return Container(
      width: width * .09,
      height: width * .09,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.white,
        shape: BoxShape.circle,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(width * .08),
        child: Utils.buildImage(
          url: '', //TODO
          width: width * .086,
          height: width * .086,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget buildUserName() {
    return Text(
      '${homeScreenBloc.loggedUser?.firstName ?? ''} ${homeScreenBloc.loggedUser?.lastName ?? ''}',
      style: TextStyle(
        fontSize: AppFonts.getMediumFontSize(context),
        color: Colors.white,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget buildHeaderComponents() {
    return StreamBuilder<DataResource<UserPortfolioFinancials>?>(
        stream: homeScreenBloc.userPortfolioFinancialsControllerStream,
        builder: (context, userPortfolioFinancialsSnapshot) {
          return Column(
            children: [
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: height * 0.02, horizontal: width * .05),
                        decoration: BoxDecoration(
                          color: AppColors.mainColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () =>
                                  _scaffoldKey.currentState?.openDrawer(),
                              child: buildUserProfileImage(),
                            ),
                            SizedBox(
                              width: width * .05,
                            ),
                            buildUserName(),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: width * .015),
                    Container(
                      padding: EdgeInsets.symmetric(
                          vertical: height * 0.02, horizontal: width * .025),
                      decoration: BoxDecoration(
                        color: AppColors.mainColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            appLocal.trans('home'),
                            style: TextStyle(
                              fontSize: AppFonts.getMediumFontSize(context),
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: width * .025,
                          ),
                          Utils.buildImage(
                            url: 'assets/images/logo.png',
                            width: width * .06,
                            height: width * .06,
                            fit: BoxFit.contain,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: width * .015,
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                    vertical: height * 0.02, horizontal: width * .05),
                decoration: BoxDecoration(
                  color: AppColors.mainColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Padding(
                    //   padding: EdgeInsets.symmetric(horizontal: width* .03),
                    //   child:  SvgPicture.asset(
                    //     'assets/icons/ic_up_arrow.svg',
                    //     width: width* .04,
                    //     height: width* .04,
                    //     fit: BoxFit.cover,
                    //   ),
                    // ),
                    // SizedBox(width: width* .05),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${userPortfolioFinancialsSnapshot.data?.data?.formattedNetWorth ?? 0.0}',
                            style: TextStyle(
                              fontSize: AppFonts.getXXLargeFontSize(context),
                              color: Colors.white,
                              height: 1.0,
                            ),
                          ),
                          SizedBox(height: height * .015),
                          Padding(
                            padding: EdgeInsets.only(left: width * .02),
                            child: Text(
                              'Total NET Balance in USD',
                              style: TextStyle(
                                fontSize: AppFonts.getSmallFontSize(context),
                                color: Colors.white.withOpacity(.35),
                                height: 1.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: width * .06),
                    Text(
                      '${userPortfolioFinancialsSnapshot.data?.data?.formattedProfitPercentage ?? 0.0}',
                      style: TextStyle(
                        fontSize: AppFonts.getMediumFontSize(context),
                        color: AppColors.blue,
                        height: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }

  Widget buildGridButtons() {
    buttonItem(titleKey, {String? image, onClick}) {
      return GestureDetector(
        onTap: onClick,
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: height * 0.025,
          ),
          decoration: BoxDecoration(
            color: AppColors.mainColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                appLocal.trans(titleKey),
                style: TextStyle(
                  fontSize: AppFonts.getMediumFontSize(context),
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  height: 1.0,
                ),
              ),
              SizedBox(
                width: width * .06,
              ),
              if (image != null)
                SvgPicture.asset(
                  image,
                  width: width * .04,
                  height: width * .04,
                  fit: BoxFit.contain,
                ),
              if (image == null)
                Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      color: AppColors.blue, shape: BoxShape.circle),
                  child: Text(
                    Utils.getFormattedCount(12),
                    style: TextStyle(
                      fontSize: AppFonts.getXSmallFontSize(context),
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: buttonItem('my_portfolio',
                  image: 'assets/icons/ic_pie_chart.svg',
                  onClick: () => rootScreenController
                      .setCurrentScreen(AppMainScreens.MY_PORTFOLIO_SCREEN)),
            ),
            SizedBox(
              width: width * .035,
            ),
            Expanded(
              child: buttonItem('new_assets', image: 'assets/icons/ic_add.svg',
                  onClick: () {
                showAddAssetDialog(
                  context: context,
                  padding: EdgeInsets.only(
                    right: width * .1,
                    left: width * .1,
                    top: height * .15,
                  ),
                  dialogContent: Container(
                      child: Column(
                    children: [
                      SizedBox(height: height * .03),
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(vertical: height * .020),
                        decoration: BoxDecoration(
                          color: AppColors.mainColor,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text(
                          appLocal.trans('choose_asset_type'),
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: AppFonts.getNormalFontSize(context),
                            height: 1.0,
                          ),
                        ),
                      ),
                      SizedBox(height: height * .02),
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(vertical: height * .020),
                        decoration: BoxDecoration(
                          color: AppColors.mainColor,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: MaterialButton(
                          onPressed: () {
                            // showAddAssetDialog(
                            //   context: context,
                            //   padding: EdgeInsets.only(
                            //     right: width * .1,
                            //     left: width * .1,
                            //     top: height * .05, /*bottom: height* .05,*/
                            //   ),
                            //   dialogContent:
                            //       getAddAssetDialogContent(HoldingsType.PUBLIC),
                            // ); /////
                            /////
                            ///////
                            ////////
                            ///////
                            //////
                          },
                          color: AppColors.gray,
                          child: Text(
                            'Public',
                            style: TextStyle(color: AppColors.blue),
                          ),
                        ),
                      ),
                    ],
                  )), // TODO:
                );
              }),
            ),
          ],
        ),
        SizedBox(
          height: width * .035,
        ),
        buttonItem('news_update',
            image: 'assets/icons/ic_news.svg',
            onClick: () => rootScreenController
                .setCurrentScreen(AppMainScreens.NEWS_SCREEN)),
      ],
    );

    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: width * .035,
      mainAxisSpacing: width * .035,
      shrinkWrap: true,
      childAspectRatio: 2.5 / 1,
      physics: NeverScrollableScrollPhysics(),
      children: [
        buttonItem('my_portfolio',
            image: 'assets/icons/ic_pie_chart.svg',
            onClick: () => rootScreenController
                .setCurrentScreen(AppMainScreens.MY_PORTFOLIO_SCREEN)),
        buttonItem('new_assets', image: 'assets/icons/ic_add.svg'),
        buttonItem('news_update',
            image: 'assets/icons/ic_news.svg',
            onClick: () => rootScreenController
                .setCurrentScreen(AppMainScreens.NEWS_SCREEN)),
        // buttonItem('notifications', ),
      ],
    );
  }

  Widget buildTopPerformingGainersLoosersResult() {
    return StreamBuilder<DataResource<TopPerformingGainersLoosersModel>?>(
        stream: homeScreenBloc.topPerformingGainersLoosersStream,
        builder: (context, topPerformingGainersLoosersSnapshot) {
          if (topPerformingGainersLoosersSnapshot.hasData &&
              topPerformingGainersLoosersSnapshot.data != null) {
            switch (topPerformingGainersLoosersSnapshot.data!.status) {
              // case Status.LOADING:
              //   return buildTopPerformingAssetsList(isLoading: true);
              case Status.SUCCESS:
                return Column(
                  children: [
                    buildSectionTitle('top_performing_assets'),
                    SizedBox(height: height * .025),
                    buildAssetList(
                        assets: topPerformingGainersLoosersSnapshot
                            .data!.data!.topPerforming,
                        isGainers: false),
                    SizedBox(height: height * 0.060),
                    buildSectionTitle('gainers_losers'),
                    SizedBox(height: height * .025),
                    buildAssetList(
                        assets: topPerformingGainersLoosersSnapshot
                            .data!.data!.gainersLoosers,
                        isGainers: true),
                  ],
                );
              // case Status.NO_MORE_RESULTS:
              //   return buildResultList(items: coursesSnapshot.data.data);
              // case Status.NO_RESULTS:
              //   return ErrorMessageWidget(messageKey: 'no_result_found_message', image: 'assets/images/ic_not_found.png');
              // case Status.FAILURE:
              //   return ErrorMessageWidget(messageKey: coursesSnapshot.data.message, image: 'assets/images/ic_error.png');

              default:
                return Container();
            }
          } else {
            return Container();
          }
        });
  }

  Widget buildAssetList({required List<GainersLooser> assets, isGainers}) {
    gainerLooserItem(GainersLooser asset) {
      return Container(
        width: width * .34,
        padding: EdgeInsets.symmetric(horizontal: width * .02),
        decoration: BoxDecoration(
          color: AppColors.mainColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (!isGainers)
                  ImageWidget(
                    url: '${UrlsContainer.baseApiUrl}/${asset.icon}',
                    width: width * .12,
                    height: width * .12,
                  ),
                if (isGainers)
                  Text(
                    asset.title.length > 4
                        ? asset.title.substring(0, 4) + '..'
                        : asset.title,
                    style: TextStyle(
                      fontSize: AppFonts.getLargeFontSize(context),
                      color: AppColors.white,
                    ),
                  ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FittedBox(
                      child: Text(
                        asset.growthTitle,
                        style: TextStyle(
                          fontSize: AppFonts.getMediumFontSize(context),
                          color: asset.growth < 0
                              ? Colors.redAccent
                              : AppColors.blue,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: height * 0.015),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 1,
                  child: Text(
                    asset.title,
                    style: TextStyle(
                      fontSize: AppFonts.getXXSmallFontSize(context),
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 4),
                Flexible(
                  flex: 1,
                  child: FittedBox(
                    child: Text(
                      // '\$${asset.purchasePrice}',
                      '\$${Utils.getFormattedNum(double.parse(asset.purchasePrice ?? '0.0'))}',
                      style: TextStyle(
                        fontSize: AppFonts.getXSmallFontSize(context),
                        color: AppColors.blue,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return assets.isEmpty
        ? Container()
        : Container(
            height: height * .135,
            width: double.infinity,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: assets.length,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    // if(isGainers)
                    gainerLooserItem(assets[index]),
                    // if(!isGainers) assetItem(assets[index]),
                    SizedBox(
                      width: width * .025,
                    ),
                  ],
                );
              },
            ),
          );
  }

  Widget buildSectionTitle(String titleKey) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.02),
          child: Text(
            appLocal.trans(titleKey),
            style: TextStyle(
              fontSize: AppFonts.getMediumFontSize(context),
              color: AppColors.white,
              height: 1.0,
            ),
          ),
        ),
        SizedBox(height: height * .01),
        Container(
          width: double.infinity,
          height: height * .001,
          color: AppColors.white.withOpacity(.35),
        ),
      ],
    );
  }

  Widget buildTopNewsResult() {
    return StreamBuilder<DataResource<List<NewsModel>>>(
        stream: homeScreenBloc.topNewsStream,
        builder: (context, newsSnapshot) {
          if (newsSnapshot.hasData && newsSnapshot.data != null) {
            switch (newsSnapshot.data!.status) {
              // case Status.LOADING:
              //   return buildTopPerformingAssetsList(isLoading: true);
              // case Status.LOADING_MORE:
              //   return buildResultList(items: coursesSnapshot.data.data);
              case Status.SUCCESS:
                return Column(
                  children: [
                    buildSectionTitle('top_news'),
                    SizedBox(height: height * .025),
                    buildTopNewsList(
                      news: newsSnapshot.data!.data,
                    ),
                  ],
                );
              // case Status.NO_MORE_RESULTS:
              //   return buildResultList(items: coursesSnapshot.data.data);
              // case Status.NO_RESULTS:
              //   return ErrorMessageWidget(messageKey: 'no_result_found_message', image: 'assets/images/ic_not_found.png');
              // case Status.FAILURE:
              //   return ErrorMessageWidget(messageKey: coursesSnapshot.data.message, image: 'assets/images/ic_error.png');

              default:
                return Container();
            }
          } else {
            return Container();
          }
        });
  }

  Widget buildTopNewsList({List<NewsModel>? news}) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: news?.length,
      padding: EdgeInsets.zero,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Column(
          children: [
            NewsItem(newsItem: news![index]),
            SizedBox(
              height: height * .025,
            ),
          ],
        );
      },
    );
  }

  Widget buildDrawerItem(image, titleKey,
      {iconSizeFactor = .05, fontSize, iconTextPaddingFactor = .06, onClick}) {
    return GestureDetector(
      onTap: onClick,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: width * .06),
          SvgPicture.asset(
            image,
            width: width * iconSizeFactor,
            height: width * iconSizeFactor,
          ),
          SizedBox(width: width * iconTextPaddingFactor),
          Text(
            appLocal.trans(titleKey),
            style: TextStyle(
              fontSize: fontSize != null
                  ? fontSize
                  : AppFonts.getNormalFontSize(context),
              color: Colors.white,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }

  Drawer buildDrawerContent() {
    return Drawer(
      child: Container(
        color: AppColors.black,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: height * .1,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: width * .06,
                  ),
                  buildUserProfileImage(),
                  SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildUserName(),
                        Text(
                          '@${homeScreenBloc.loggedUser?.name ?? ''}',
                          style: TextStyle(
                            fontSize: AppFonts.getXSmallFontSize(context),
                            color: Colors.white.withOpacity(.75),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: SvgPicture.asset('assets/icons/ic_cross.svg',
                        width: width * .05, height: width * .05),
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    alignment: Alignment.topRight,
                  ),
                ],
              ),
              SizedBox(
                height: height * .1,
              ),
              buildDrawerItem('assets/icons/ic_user.svg', 'profile'),
              SizedBox(
                height: height * .035,
              ),
              buildDrawerItem(
                'assets/icons/ic_news.svg',
                'news_feed',
                onClick: () => rootScreenController
                    .setCurrentScreen(AppMainScreens.NEWS_SCREEN),
              ),
              SizedBox(
                height: height * .035,
              ),
              buildDrawerItem('assets/icons/ic_bar_chart.svg', 'wave_fund'),
              SizedBox(
                height: height * .1,
              ),
              buildDrawerItem('assets/icons/ic_exit.svg', 'logout',
                  onClick: () => uiController.logout(context)),
              SizedBox(
                height: height * .08,
              ),
              Row(
                children: [
                  buildDrawerItem(
                    'assets/icons/ic_verified.svg',
                    'premium_account',
                    fontSize: AppFonts.getXXSmallFontSize(context),
                    iconSizeFactor: .03,
                    iconTextPaddingFactor: .01,
                  ),
                  Spacer(),
                  buildDrawerItem(
                    'assets/icons/ic_logo.svg',
                    'wave_fund_member',
                    fontSize: AppFonts.getXXSmallFontSize(context),
                    iconSizeFactor: .035,
                    iconTextPaddingFactor: .01,
                  ),
                  SizedBox(
                    width: width * .05,
                  ),
                ],
              ),
              SizedBox(height: height * .008),
              Container(
                width: width,
                height: height * .001,
                color: AppColors.white.withOpacity(.35),
              ),
              SizedBox(
                height: height * .05,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * .06),
                child: Text(
                  appLocal.trans('settings_privacy'),
                  style: TextStyle(
                    fontSize: AppFonts.getMediumFontSize(context),
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                height: height * .025,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * .06),
                child: Text(
                  appLocal.trans('help_center'),
                  style: TextStyle(
                    fontSize: AppFonts.getMediumFontSize(context),
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                height: height * .040,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
