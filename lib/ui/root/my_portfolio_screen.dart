import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rxdart/streams.dart';
import 'package:wave_flutter/di/my_portfolio_screen_di.dart';
import 'package:wave_flutter/helper/app_colors.dart';
import 'package:wave_flutter/helper/app_fonts.dart';
import 'package:wave_flutter/helper/enums.dart';
import 'package:wave_flutter/helper/utils.dart';
import 'package:wave_flutter/models/assets_financials.dart';
import 'package:wave_flutter/models/user_portfolio_financials.dart';
import 'package:wave_flutter/services/data_resource.dart';
import 'package:wave_flutter/ui/common_widgets/base_statefull_widget.dart';
import 'package:wave_flutter/ui/common_widgets/chart_card_item.dart';
import 'package:wave_flutter/ui/common_widgets/chart_info_card_item.dart';
import 'package:wave_flutter/ui/common_widgets/home_screen_header.dart';


class MyPortfolioScreen extends BaseStateFullWidget {
  @override
  _MyPortfolioScreenState createState() => _MyPortfolioScreenState();
}

class _MyPortfolioScreenState extends BaseStateFullWidgetState<MyPortfolioScreen> with MyPortfolioScreenDi{

  @override
  void initState() {
    super.initState();

    initScreenDi();

    myPortfolioScreenBloc.fetchUserPortfolioFinancials();
    myPortfolioScreenBloc.fetchPrivateAssetsFinancials();
    myPortfolioScreenBloc.fetchPersonalAssetsFinancials();
    myPortfolioScreenBloc.fetchPublicAssetsFinancials();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: WillPopScope(
        onWillPop: () => rootScreenController.setCurrentScreen(AppMainScreens.HOME_SCREEN),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(top: mediaQuery.padding.top, right: width* .05, left: width* .05,),
          child: Column(
            children: [
              SizedBox(height: height* 0.02),
              buildHeader(),
              SizedBox(height: height* 0.020),
              ChartCardItem(chartType: ChartsType.AREA,),
              SizedBox(height: height* 0.020),
              buildChartInfoRow(),
              SizedBox(height: height* 0.020),
              buildHoldingAssetsItems(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHeader(){
    return StreamBuilder<DataResource<UserPortfolioFinancials>?>(
        stream: myPortfolioScreenBloc.userPortfolioFinancialsControllerStream,
        builder: (context, userPortfolioFinancialsSnapshot) {
        return buildHeaderComponents(
          titleWidget: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => rootScreenController.setCurrentScreen(AppMainScreens.HOME_SCREEN),
                child: Row(
                  children: [
                    Icon(Icons.arrow_left, color: AppColors.gray, size: width* .08,),
                    SvgPicture.asset(
                      'assets/icons/ic_home.svg',
                      fit: BoxFit.contain,
                      width: width*.065,
                      height: width*.065,
                      color: AppColors.gray,
                    ),
                  ],
                ),
              ),
              SizedBox(width: width* .04,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      appLocal.trans('portfolio_total'),
                      style: TextStyle(
                        fontSize: AppFonts.getMediumFontSize(context),
                        color: Colors.white,
                        height: 1.0,
                      ),
                    ),
                    SizedBox(height: height* .010),
                    Padding(
                      padding: EdgeInsets.only(left: width* .02),
                      child: Text(
                        'Estimated NET balance in USD',
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
            ],
          ),
          height: height,
          width: width,
          context: context,
          appLocal: appLocal,
          logoTitleKey: 'equity',
          netWorth: '${userPortfolioFinancialsSnapshot.data?.data?.formattedNetWorth??0.0}',
          growth: '${userPortfolioFinancialsSnapshot.data?.data?.formattedProfitPercentage??0.0}',
        );
      }
    );
  }

  Widget buildChartInfoRow(){
    return StreamBuilder<DataResource<UserPortfolioFinancials>?>(
        stream: myPortfolioScreenBloc.userPortfolioFinancialsControllerStream,
        builder: (context, userPortfolioFinancialsSnapshot) {
          return Row(
            children: [
              ChartInfoCardItem(title: appLocal.trans('invested'), value: '${userPortfolioFinancialsSnapshot.data?.data?.formattedInvested??0.0}'),
              SizedBox(width: width* 0.025,),
              ChartInfoCardItem(title: appLocal.trans('profit'), value: '${userPortfolioFinancialsSnapshot.data?.data?.formattedProfit??0.0}'),
              SizedBox(width: width* 0.025,),
              ChartInfoCardItem(title: '${appLocal.trans('profit')} %', value: '${userPortfolioFinancialsSnapshot.data?.data?.formattedProfitPercentage??0.0}'),
            ],
        );
      }
    );
  }

  Widget buildHoldingAssetsItems(){
    return Column(
      children: [
        buildHoldingAssetsItem(
          image: 'assets/icons/ic_contract.svg',
          titleKey: 'private_holdings',
          stream: myPortfolioScreenBloc.privateAssetsFinancialsStream,
          onClick: () => rootScreenController.setSharedData(HoldingsType.PRIVATE),
        ),
        SizedBox(height: height*.015,),
        buildHoldingAssetsItem(
          image: 'assets/icons/ic_bar_chart.svg',
          titleKey: 'public_holdings',
          stream: myPortfolioScreenBloc.publicAssetsFinancialsStream,
          onClick: () => rootScreenController.setSharedData(HoldingsType.PUBLIC),
        ),
        SizedBox(height: height*.015,),
        buildHoldingAssetsItem(
          image: 'assets/icons/ic_personal_asset.svg',
          titleKey: 'personal_holdings',
          stream: myPortfolioScreenBloc.personalAssetsFinancialsStream,
          onClick: () => rootScreenController.setSharedData(HoldingsType.PERSONAL),
        ),
        SizedBox(height: height*.015,),
      ],
    );
  }

  buildHoldingAssetsItem({
    required image,
    required String titleKey,
    required ValueStream<DataResource<AssetsFinancials>?> stream,
    required onClick,
  }) {
    return StreamBuilder<DataResource<AssetsFinancials>?>(
      stream: stream,
      builder: (context, financialsSnapshot) {
        return GestureDetector(
          onTap: () {
            onClick();
            rootScreenController.setCurrentScreen(AppMainScreens.HOLDINGS_SCREEN);
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: width* .05, vertical: height* .035),
            decoration: BoxDecoration(
              color: AppColors.mainColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  image,
                  width: width* .062,
                  height: width* .062,
                ),
                SizedBox(width: width*.05),
                Text(
                  appLocal.trans(titleKey),
                  style: TextStyle(
                    fontSize: AppFonts.getMediumFontSize(context),
                    color: Colors.white,
                  ),
                ),
                Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '${Utils.getFormattedNum(financialsSnapshot.data?.data?.assetNetworth??0.0)}',
                      // '${financialsSnapshot.data?.data?.assetNetworth??''}',
                      style: TextStyle(
                        fontSize: AppFonts.getMediumFontSize(context),
                        color: AppColors.white,
                      ),
                    ),
                    SizedBox(height: height*.020),
                    if(financialsSnapshot.data?.data!=null) Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // SvgPicture.asset(
                        //   'assets/icons/ic_up_arrow.svg',
                        //   width: width* .03,
                        //   height: width* .03,
                        //   fit: BoxFit.cover,
                        // ),
                        // SizedBox(width: width*.02),
                        Text(
                          financialsSnapshot.data?.data?.getAssetGrowthRounded()??'',
                          style: TextStyle(
                            fontSize: AppFonts.getSmallFontSize(context),
                            color: AppColors.blue,
                            height: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }
    );
  }

}

