import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rxdart/streams.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
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
import 'package:wave_flutter/ui/root/home_screen.dart';
import 'package:http/http.dart' as http;

class MyPortfolioScreen extends BaseStateFullWidget {
  @override
  _MyPortfolioScreenState createState() => _MyPortfolioScreenState();
}

class _MyPortfolioScreenState
    extends BaseStateFullWidgetState<MyPortfolioScreen>
    with MyPortfolioScreenDi {
  @override
  void initState() {
    super.initState();

    initScreenDi();
    getPersonalChartValue();
    myPortfolioScreenBloc.fetchUserPortfolioFinancials();
    myPortfolioScreenBloc.fetchPrivateAssetsFinancials();
    myPortfolioScreenBloc.fetchPersonalAssetsFinancials();
    myPortfolioScreenBloc.fetchPublicAssetsFinancials();
  }

  List<ChartData> protfolioChartData = [];

  bool spinner = false;

  void getPersonalChartValue() async {
    setState(() {
      spinner = true;
    });
    protfolioChartData.clear();
    print('xxxxx');
    //  dynamic api = _dataStore!.getApiToken();
    // String? api = _dataStore!.userModel!.apiToken;
    // dynamic api = _dataStore!.getApiToken().then((value) => apiToken = value!);
    String? apiToken = HomeScreen.apiToken;
    var request;
    var response;
    var url = Uri.parse(
      'https://wave.aratech.co/api/get-assets-chart-main-portfolio-data',
    );
    print('///////////' + url.toString() + '//tokennnnnn///' + apiToken!);

    request = http.MultipartRequest('POST', url);
    request.fields['api_token'] = apiToken;
    response = await request.send();
    var xx = await http.Response.fromStream(response);
    var x = jsonDecode(xx.body);

    print('///////////////////////////////////////////////////');
    print(x.toString());
    print('///////////////////////////////////////////////////');
    List payload = x['data'];

    ChartData? other;
    payload.forEach((element) {
      var t = element['acquisition_date'].toString();
      if (t.length >= 10)
        t = t.substring(0, 10);
      else if (t.length < 5) t = t + '-01-01';
      //  String temp = t.length >= 10 ? t.substring(0, 10) : t;
      DateTime acquisitionDate = DateTime.parse(t);
      print('$acquisitionDate' + '');

      int growth = element['price'].toInt();
      // int intGrowth = growth.toInt();
      // print('$growth' + 'aloalo');
      // if (growth == 0) growth = 0.01;
      protfolioChartData.add(ChartData(acquisitionDate, growth));

      print('personalAassetTtype = $acquisitionDate');
      print('growth = $growth');
    });
    setState(() {
      spinner = false;
    });
  }

  Widget protfolioWidget() {
    return Container(
      height: height * .22,
      child: SfCartesianChart(
        // primaryXAxis: DateTimeAxis(),
        // margin: EdgeInsets.symmetric(horizontal: width* .025, vertical: height* .025),
        series: <CartesianSeries<ChartData, DateTime>>[
          // Renders area chart
          AreaSeries<ChartData, DateTime>(
            dataSource: protfolioChartData,
            xValueMapper: (ChartData data, _) => data.x,
            yValueMapper: (ChartData data, _) => data.y,
            borderDrawMode: BorderDrawMode.excludeBottom,
            borderColor: AppColors.blue,
            borderWidth: 1,
            gradient: LinearGradient(
              end: Alignment.topCenter,
              begin: Alignment.bottomCenter,
              tileMode: TileMode.clamp,
              colors: [
                AppColors.blue.withOpacity(.01),
                AppColors.blue.withOpacity(.25),
                AppColors.blue.withOpacity(.5),
              ],
              stops: [
                0.0,
                0.5,
                1.0,
              ],
            ),
          )
        ],
        zoomPanBehavior: ZoomPanBehavior(
          // enablePinching: true,
          enablePanning: true,
          zoomMode: ZoomMode.x,
        ),
        plotAreaBorderWidth: 0.0,
        // primaryXAxis: NumericAxis(
        //   majorGridLines: MajorGridLines(width: 0),
        //   axisLine: AxisLine(
        //     width: 0.0,
        //   ),
        //   tickPosition: TickPosition.outside,
        //   majorTickLines: MajorTickLines(width: 0),
        //     visibleMinimum: chartData[chartData.length-chartData.length~/2].year,
        //     visibleMaximum: chartData[chartData.length-chartData.length~/2].year,
        // ),
        primaryXAxis: DateTimeAxis(
          // // intervalType: _getChartIntervalType(filter),
          // visibleMinimum: chartData.length > 1
          //     ? chartData[chartData.length - (chartData.length ~/ 2)].x
          //     : (chartData[chartData.length - 1].x),
          // visibleMaximum: chartData[chartData.length - 1].x,
          majorGridLines: MajorGridLines(width: 0),
          axisLine: AxisLine(
            width: 0.0,
          ),
          tickPosition: TickPosition.outside,
          majorTickLines: MajorTickLines(width: 0),
          autoScrollingMode: AutoScrollingMode.end,
        ),
        primaryYAxis: NumericAxis(
          edgeLabelPlacement: EdgeLabelPlacement.shift,
          labelFormat: '{value}',
          // numberFormat: NumberFormat.simpleCurrency(decimalDigits: 0),
          majorGridLines: MajorGridLines(width: .03),
          axisLine: AxisLine(
            width: 0.0,
          ),
          majorTickLines: MajorTickLines(width: 0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: WillPopScope(
        onWillPop: () =>
            rootScreenController.setCurrentScreen(AppMainScreens.HOME_SCREEN),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            top: mediaQuery.padding.top,
            right: width * .05,
            left: width * .05,
          ),
          child: Column(
            children: [
              SizedBox(height: height * 0.0167),
              buildHeader(),
              SizedBox(height: height * 0.0167),
              // ChartCardItem(
              //   chartType: ChartsType.AREA,
              // ),
              // MaterialButton(
              //   onPressed: () {
              //     getPersonalChartValue();
              //   },
              //   child: Text('aaaaaaaa'),
              //   height: height / 4,
              //   color: Colors.red,
              // ),
              spinner
                  ? Container(
                      height: height * .20,
                      width: height * .20,
                      child: Center(
                        child: Container(
                            height: height * .04,
                            width: height * .04,
                            child: CircularProgressIndicator()),
                      ),
                    )
                  : protfolioWidget(),
              SizedBox(height: height * 0.0167),
              buildChartInfoRow(),

              SizedBox(height: height * 0.0167),
              buildHoldingAssetsItems(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHeader() {
    return StreamBuilder<DataResource<UserPortfolioFinancials>?>(
        stream: myPortfolioScreenBloc.userPortfolioFinancialsControllerStream,
        builder: (context, userPortfolioFinancialsSnapshot) {
          return buildHeaderComponents(
            titleWidget: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => rootScreenController
                      .setCurrentScreen(AppMainScreens.HOME_SCREEN),
                  child: Row(
                    children: [
                      Icon(
                        Icons.arrow_left,
                        color: AppColors.gray,
                        size: width * .08,
                      ),
                      SvgPicture.asset(
                        'assets/icons/ic_home.svg',
                        fit: BoxFit.contain,
                        width: width * .065,
                        height: width * .065,
                        color: AppColors.gray,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: width * .04,
                ),
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
                      SizedBox(height: height * .010),
                      Padding(
                        padding: EdgeInsets.only(left: width * .02),
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
            netWorth:
                '${userPortfolioFinancialsSnapshot.data?.data?.formattedNetWorth ?? 0.0}',
            growth:
                '${userPortfolioFinancialsSnapshot.data?.data?.formattedProfitPercentage ?? 0.0}',
          );
        });
  }

  Widget buildChartInfoRow() {
    return StreamBuilder<DataResource<UserPortfolioFinancials>?>(
        stream: myPortfolioScreenBloc.userPortfolioFinancialsControllerStream,
        builder: (context, userPortfolioFinancialsSnapshot) {
          return Row(
            children: [
              ChartInfoCardItem(
                  title: appLocal.trans('invested'),
                  value:
                      '${userPortfolioFinancialsSnapshot.data?.data?.formattedInvested ?? 0.0}'),
              SizedBox(
                width: width * 0.025,
              ),
              ChartInfoCardItem(
                  title: appLocal.trans('profit'),
                  value:
                      '${userPortfolioFinancialsSnapshot.data?.data?.formattedProfit ?? 0.0}'),
              SizedBox(
                width: width * 0.025,
              ),
              ChartInfoCardItem(
                  title: '${appLocal.trans('profit')} %',
                  value:
                      '${userPortfolioFinancialsSnapshot.data?.data?.formattedProfitPercentage ?? 0.0}'),
            ],
          );
        });
  }

  Widget buildHoldingAssetsItems() {
    return Column(
      children: [
        buildHoldingAssetsItem(
          titleKey: 'private_holdings',
          stream: myPortfolioScreenBloc.privateAssetsFinancialsStream,
          onClick: () =>
              rootScreenController.setSharedData(HoldingsType.PRIVATE),
        ),
        SizedBox(
          height: height * .015,
        ),
        buildHoldingAssetsItem(
          titleKey: 'public_holdings',
          stream: myPortfolioScreenBloc.publicAssetsFinancialsStream,
          onClick: () =>
              rootScreenController.setSharedData(HoldingsType.PUBLIC),
        ),
        SizedBox(
          height: height * .015,
        ),
        buildHoldingAssetsItem(
          titleKey: 'personal_holdings',
          stream: myPortfolioScreenBloc.personalAssetsFinancialsStream,
          onClick: () =>
              rootScreenController.setSharedData(HoldingsType.PERSONAL),
        ),
        SizedBox(
          height: height * .015,
        ),
      ],
    );
  }

  buildHoldingAssetsItem({
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
              rootScreenController
                  .setCurrentScreen(AppMainScreens.HOLDINGS_SCREEN);
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                bottom: height * .01,
                top: height * .01,
                right: width * .02,
                left: width * .025,
              ),
              decoration: BoxDecoration(
                color: AppColors.mainColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    appLocal.trans(titleKey),
                    style: TextStyle(
                      fontSize: AppFonts.getMediumFontSize(context),
                      color: Colors.white,
                    ),
                  ),
                  Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        Utils.getFormattedNum(financialsSnapshot
                                        .data?.data?.assetNetworth ??
                                    0.0) ==
                                '.00'
                            ? ''
                            : '${Utils.getFormattedNum(financialsSnapshot.data?.data?.assetNetworth ?? 0.0)}',
                        // '${financialsSnapshot.data?.data?.assetNetworth??''}',
                        style: TextStyle(
                          fontSize: AppFonts.getMediumFontSize(context),
                          color: AppColors.white,
                        ),
                      ),
                      SizedBox(height: height * .020),
                      if (financialsSnapshot.data?.data != null)
                        Row(
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
                              financialsSnapshot.data?.data
                                          ?.getAssetGrowthRounded() ==
                                      '+.00%'
                                  ? ''
                                  : financialsSnapshot.data?.data
                                          ?.getAssetGrowthRounded() ??
                                      '',
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
        });
  }
}
