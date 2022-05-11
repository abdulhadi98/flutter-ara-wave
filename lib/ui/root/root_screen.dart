import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wave_flutter/di/root_screen_di.dart';
import 'package:wave_flutter/helper/app_colors.dart';
import 'package:wave_flutter/helper/enums.dart';
import 'package:wave_flutter/helper/utils.dart';
import 'package:wave_flutter/ui/common_widgets/base_statefull_widget.dart';
import 'package:wave_flutter/ui/root/holdings_screen.dart';
import 'package:wave_flutter/ui/root/home_screen.dart';
import 'package:wave_flutter/ui/root/news_screen.dart';
import 'package:wave_flutter/ui/root/personal_asset_details_screen.dart';
import 'package:wave_flutter/ui/root/private_asset_details_screen.dart';

import 'my_portfolio_screen.dart';

class RootScreen extends BaseStateFullWidget {
  @override
  _RootScreenState createState() => _RootScreenState();
}

class _RootScreenState extends BaseStateFullWidgetState<RootScreen> with RootScreenDi{

  @override
  void initState() {
    super.initState();

    initScreenDi();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: StreamBuilder<AppMainScreens>(
        initialData: AppMainScreens.HOME_SCREEN,
        stream: uiController.currentScreenStream,
        builder: (context, screenSnapshot) {
          return Container(
            height: height,
            width: width,
            child: Column(
              children: [
                Expanded(child: buildCurrentScreen(screenSnapshot.data)),
                buildBottomNavBar(screenSnapshot.data!),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildCurrentScreen(AppMainScreens? screen){
    switch(screen){
      case AppMainScreens.HOME_SCREEN:
        return HomeScreen();

      case AppMainScreens.MY_PORTFOLIO_SCREEN:
        return MyPortfolioScreen();

      case AppMainScreens.NEWS_SCREEN:
        return NewsScreen();

      case AppMainScreens.OPTIONS_SCREEN:
        return Center(
          child: Text(Utils.enumToString<AppMainScreens>(AppMainScreens.OPTIONS_SCREEN), style: TextStyle(color: Colors.white),),
        );

      case AppMainScreens.HOLDINGS_SCREEN:
        return HoldingsScreen(holdingsType: uiController.getSharedData());

      case AppMainScreens.PRIVATE_ASSET_DETAILS_SCREEN:
        return PrivateAssetDetailsScreen(assetModel: uiController.getSharedData());

      case AppMainScreens.PERSONAL_ASSET_DETAILS_SCREEN:
        return PersonalAssetDetailsScreen(assetModel: uiController.getSharedData());

      default:
        return Container();
    }
  }

  Widget buildBottomNavBar(AppMainScreens screen){
    return Container(
      color: AppColors.mainColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: double.infinity, height: height*.0005, color: Colors.white,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildBottomNavBarItem(screen == AppMainScreens.HOME_SCREEN, AppMainScreens.HOME_SCREEN, 'assets/icons/ic_home.svg',),
              buildBottomNavBarItem(
                screen == AppMainScreens.MY_PORTFOLIO_SCREEN
                    || screen == AppMainScreens.HOLDINGS_SCREEN
                    || screen == AppMainScreens.PRIVATE_ASSET_DETAILS_SCREEN
                    || screen == AppMainScreens.PERSONAL_ASSET_DETAILS_SCREEN,
                AppMainScreens.MY_PORTFOLIO_SCREEN,
                'assets/icons/ic_pie_chart.svg',
              ),
              buildBottomNavBarItem(screen == AppMainScreens.NEWS_SCREEN, AppMainScreens.NEWS_SCREEN, 'assets/icons/ic_news.svg',),
              buildBottomNavBarItem(
                screen == AppMainScreens.OPTIONS_SCREEN,
                AppMainScreens.OPTIONS_SCREEN,
                'assets/icons/ic_options.svg',
                size: width* .025,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildBottomNavBarItem(isSelected, AppMainScreens screen, image, {size}){
    return GestureDetector(
      onTap: () => uiController.setCurrentScreen(screen),
      child: Padding(
        padding: EdgeInsets.all(width* .025),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              image,
              fit: BoxFit.contain,
              width: size!=null ? size : width* .08,
              height: size!=null ? size : width* .08,
              color: isSelected? Colors.white : Colors.white.withOpacity(.5),
            ),
            SizedBox(height: height*.01),
            Container(
              width: width*.012,
              height: width*.012,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected? Colors.white : Colors.transparent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
