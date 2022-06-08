import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:wave_flutter/di/private_asset_setails_screen_di.dart';
import 'package:wave_flutter/helper/app_colors.dart';
import 'package:wave_flutter/helper/app_fonts.dart';
import 'package:wave_flutter/helper/enums.dart';
import 'package:wave_flutter/main.dart';
import 'package:wave_flutter/models/private_asset_model.dart';
import 'package:wave_flutter/services/data_resource.dart';
import 'package:wave_flutter/ui/common_widgets/base_statefull_widget.dart';
import 'package:wave_flutter/ui/common_widgets/card_item_details_screen.dart';
import 'package:wave_flutter/ui/common_widgets/chart_card_item.dart';
import 'package:wave_flutter/ui/common_widgets/chart_info_card_item.dart';
import 'package:wave_flutter/ui/common_widgets/error_message_widget.dart';
import 'package:wave_flutter/ui/common_widgets/home_screen_header.dart';
import 'package:http/http.dart' as http;
import 'package:wave_flutter/ui/root/holdings_screen.dart';
import 'package:wave_flutter/ui/root/home_screen.dart';

import '../../helper/utils.dart';

class PrivateManualDetailsScreen extends BaseStateFullWidget {
  final PrivateAssetModel assetModel;
  PrivateManualDetailsScreen({required this.assetModel});

  @override
  _PrivateAssetDetailsScreenState createState() =>
      _PrivateAssetDetailsScreenState();
}

class _PrivateAssetDetailsScreenState
    extends BaseStateFullWidgetState<PrivateManualDetailsScreen>
    with PrivateAssetDetailsScreenDi {
  var assetGrowth = '';
  var salePrice = ''; //market price
  var purchasePrice = '';
  var headQuarterCity = '';
  var profitPercentage = '';
  var marketValue = '';
  var profit = '';

  var quantity = '';

  var rOI = '';
  var totalA = ''; //quantity
  var marketCapitaliztion = '';
  var sharesOutstanding = '';
  var shareClass = '';

  var totalBalance = '';

  @override
  void initState() {
    super.initState();

    initScreenDi();
    getAssetDetails();
    getPersonalChartValue();
    //uiController.fetchResult();
  }

  void iniPage() async {
    setState(() {
      spinner = true;
    });
    await getAssetDetails().then((_) {
      getPersonalChartValue();
    });

    setState(() {
      spinner = false;
    });
  }

  bool chartSpinner = false;
  List<ChartData> privateDetailsChart = [];
  void getPersonalChartValue() async {
    setState(() {
      chartSpinner = true;
    });
    privateDetailsChart.clear();
    print('xxxxx');
    //  dynamic api = _dataStore!.getApiToken();
    // String? api = _dataStore!.userModel!.apiToken;
    // dynamic api = _dataStore!.getApiToken().then((value) => apiToken = value!);
    String? apiToken = HomeScreen.apiToken;
    var request;
    var response;
    var url = Uri.parse(
      'https://wave.aratech.co/api/get-asset-price-history',
    );
    print('///////////' + url.toString() + '//tokennnnnn///' + apiToken!);

    request = http.MultipartRequest('POST', url);
    request.fields['api_token'] = apiToken;
    request.fields['asset_id'] = HoldingsScreen.assetId.toString();
    request.fields['type'] = 'private-manual';

    response = await request.send();
    var xx = await http.Response.fromStream(response);
    var x = jsonDecode(xx.body);

    print('///////////////////////////////////////////////////');
    print(x.toString());
    print('///////////////////////////////////////////////////');
    List payload = x['data'];

    ChartData? other;
    payload.forEach((element) {
      var t = element['year'].toString();
      if (t.length >= 10)
        t = t.substring(0, 10);
      else if (t.length < 5) t = t + '-01-01';
      //  String temp = t.length >= 10 ? t.substring(0, 10) : t;
      DateTime acquisitionDate = DateTime.parse(t);
      print('$acquisitionDate' + '');

      var growth = element['price'].toInt();
      // int intGrowth = growth.toInt();
      // print('$growth' + 'aloalo');
      // if (growth == 0) growth = 0.01;
      privateDetailsChart.add(ChartData(acquisitionDate, growth));

      print('personalAassetTtype = $acquisitionDate');
      print('growth = $growth');
    });
    setState(() {
      chartSpinner = false;
    });
  }

  Widget protfolioWidget() {
    return Container(
      width: double.infinity,
      // height: height* .40,
      padding: EdgeInsets.symmetric(vertical: height * .01),
      decoration: BoxDecoration(
        color: AppColors.mainColor,
        borderRadius: BorderRadius.circular(8),
      ),
      height: height * .24,
      child: SfCartesianChart(
        // primaryXAxis: DateTimeAxis(),
        // margin: EdgeInsets.symmetric(horizontal: width* .025, vertical: height* .025),
        series: <CartesianSeries<ChartData, DateTime>>[
          // Renders area chart
          AreaSeries<ChartData, DateTime>(
            dataSource: privateDetailsChart,
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
        margin: EdgeInsets.only(right: width * 0.04, top: width * 0.01),
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
          labelAlignment: LabelAlignment.center,

          majorTickLines: MajorTickLines(width: 0),
          autoScrollingMode: AutoScrollingMode.end,
        ),
        primaryYAxis: NumericAxis(
          numberFormat: NumberFormat.compactSimpleCurrency(),
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

  bool spinner = false;
  Future getAssetDetails() async {
    setState(() {
      spinner = true;
    });

    //  protfolioChartData.clear();
    print('xxxxx');
    //  dynamic api = _dataStore!.getApiToken();
    // String? api = _dataStore!.userModel!.apiToken;
    // dynamic api = _dataStore!.getApiToken().then((value) => apiToken = value!);
    String? apiToken = HomeScreen.apiToken;
    int? assetId = HoldingsScreen.assetId;

    var request;
    var response;
    var url = Uri.parse(
      'https://wave.aratech.co/api/get-private-manual-details',
    );
    print('///////////' +
        url.toString() +
        '//tokennnnnn///' +
        apiToken! +
        '//////' +
        assetId.toString());

    request = http.MultipartRequest('POST', url);
    request.fields['api_token'] = apiToken;
    request.fields['asset_id'] = assetId.toString();

    response = await request.send();
    var xx = await http.Response.fromStream(response);
    var x = jsonDecode(xx.body);

    print('///////////////////////////////////////////////////');
    print(x.toString());
    print('///////////////////////////////////////////////////');
    Map payload = x['data'];
    // var id = payload['id'];
    setState(() {
      headQuarterCity = payload['headquarter_city'];
      totalBalance = payload['totalBalance'].toString();
      profitPercentage = payload['profitPercentage'].toString();

      purchasePrice = payload['purchased_price'].toString();
      quantity = payload['shares_purchased'].toString();

      marketValue = payload['marketValue'].toString();

      rOI = payload['returnOnInvestment'].toString();
      //   assetGrowth = payload['profitPercentage'].toString();
      marketCapitaliztion = payload['marketCapitalization'].toString();
      sharesOutstanding = payload['shares_outstanding'].toString();
      shareClass = payload['share_class'].toString();
    });

    //getPersonalChartValue();
    setState(() {
      spinner = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: AppColors.black,
      body: WillPopScope(
        onWillPop: () => _onWillPop(),
        child: Container(
          padding: EdgeInsets.only(
            top: mediaQuery.padding.top,
            right: width * .05,
            left: width * .05,
          ),
          child: spinner
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : buildScreenContent(),
        ),
      ),
    );
  }

  // Widget buildAssetResults() {
  //   return StreamBuilder<DataResource<List<PrivateAssetModel>>?>(
  //       stream: privateAssetDetailsScreenBloc.privateAssetsStream,
  //       builder: (context, assetsSnapshot) {
  //         if (assetsSnapshot.hasData && assetsSnapshot.data != null) {
  //           switch (assetsSnapshot.data!.status) {
  //             case Status.LOADING:
  //               return Expanded(
  //                 child: Center(
  //                   child: CircularProgressIndicator(),
  //                 ),
  //               );
  //             case Status.SUCCESS:
  //               return buildScreenContent(assetsSnapshot.data!.data!.first);
  //             case Status.NO_RESULTS:
  //               return ErrorMessageWidget(
  //                   messageKey: 'no_result_found_message',
  //                   image: 'assets/images/ic_not_found.png');
  //             case Status.FAILURE:
  //               return ErrorMessageWidget(
  //                   messageKey: assetsSnapshot.data?.message ?? '',
  //                   image: 'assets/images/ic_error.png');

  //             default:
  //               return Container();
  //           }
  //         } else {
  //           return Container();
  //         }
  //       });
  // }

  Widget buildScreenContent() {
    return Column(
      children: [
        SizedBox(height: height * 0.02),
        buildHeader(),
        SizedBox(height: height * 0.020),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                chartSpinner ? CircularProgressIndicator() : protfolioWidget(),
                SizedBox(height: height * 0.020),
                Row(
                  children: [
                    ChartInfoCardItem(
                      title: 'Purchased Price', //translate
                      value: "\$${Utils.getFormattedStrNum(purchasePrice)}",
                      //   bottomLabel: appLocal.trans('average_cost')
                    ),
                    SizedBox(
                      width: width * 0.025,
                    ),
                    ChartInfoCardItem(
                      title: appLocal.trans('market_price'),
                      value: "\$${Utils.getFormattedStrNum(marketValue)}",
                      //   bottomLabel: appLocal.trans('current_share_price'),
                    ),
                    SizedBox(
                      width: width * 0.025,
                    ),
                    ChartInfoCardItem(
                      title: appLocal.trans('Profit %'),
                      value: Utils.getFormattedStrNum(profitPercentage
                              .substring(0, profitPercentage.length - 1)) +
                          '%',
                      //   bottomLabel: widget.assetModel.assetGrowth ?? '312'),
                    )
                  ],
                ),
                // SizedBox(height: height* 0.020),
                // buildUserInvestmentDetailsCard(),
                SizedBox(height: height * 0.020),
                //   buildCardList(asset.assetMetasMap),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: width * 0.03, vertical: height * 0.03),
                  // height: height / 4,
                  decoration: BoxDecoration(
                      color: AppColors.mainColor,
                      borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    children: [
                      rowInfo(
                          'Shares Owned', Utils.getFormattedStrNum(quantity)),
                      Divider(
                        color: AppColors.black.withOpacity(0.6),
                        thickness: 1.5,
                        height: 10,
                      ),
                      rowInfo('Total Amount Invested',
                          "\$${Utils.getFormattedStrNum(purchasePrice)}"),
                      Divider(
                        color: AppColors.black.withOpacity(0.6),
                        thickness: 1.5,
                        height: 10,
                      ),
                      rowInfo(
                        'Return On Investment (ROI)',
                        Utils.getFormattedStrNum(profitPercentage.substring(
                                0, profitPercentage.length - 1)) +
                            '%',
                      ),
                      Divider(
                        color: AppColors.black.withOpacity(0.6),
                        thickness: 1.5,
                        height: 10,
                      ),
                      rowInfo('Market Capitalization',
                          '\$ ${Utils.getFormattedStrNum(marketCapitaliztion)}'),
                      Divider(
                        color: AppColors.black.withOpacity(0.6),
                        thickness: 1.5,
                        height: 10,
                      ),
                      rowInfo('Shares Outstanding',
                          Utils.getFormattedStrNum(sharesOutstanding)),
                      Divider(
                        color: AppColors.black.withOpacity(0.6),
                        thickness: 1.5,
                        height: 10,
                      ),
                      rowInfo('Shares Class', shareClass),
                      Divider(
                        color: AppColors.black.withOpacity(0.6),
                        thickness: 1.5,
                        height: 10,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: height * 0.020),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Padding rowInfo(leftText, rightText) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: width * .005, vertical: height * .01),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            leftText,
            style: TextStyle(
              fontSize: AppFonts.getSmallFontSize(context),
              color: Colors.white,
              height: 1.0,
            ),
          ),
          Text(
            rightText,
            style: TextStyle(
              fontSize: AppFonts.getSmallFontSize(context),
              color: Colors.white,
              height: 1.0,
            ),
          )
        ],
      ),
    );
  }

  Widget buildHeader() {
    return buildHeaderComponents(
      titleWidget: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: _onWillPop,
            child: Row(
              children: [
                SizedBox(width: width * .04),
                Icon(
                  Icons.arrow_back_ios_rounded,
                  color: AppColors.gray,
                  size: width * .075,
                ),
                SizedBox(width: width * .06),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.assetModel.name ?? '',
                      style: TextStyle(
                        fontSize: AppFonts.getMediumFontSize(context),
                        color: Colors.white,
                        height: 1.0,
                      ),
                    ),
                    SizedBox(height: height * .01),
                    Text(
                      headQuarterCity,
                      style: TextStyle(
                        fontSize: AppFonts.getXSmallFontSize(context),
                        color: Colors.white,
                        height: 1.0,
                      ),
                    ),
                  ],
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
      logoTitleKey: 'private',
      isAddProgressExist: true,
      addEditIcon: 'assets/icons/ic_edit.svg',
      addEditTitleKey: 'edit_asset',
      onAddEditClick: () {},
      totalTextKey: 'estimated_total_asset_equity',
      netWorth: '${Utils.getFormattedStrNum(totalBalance)}',
      growth: Utils.getFormattedStrNum(
              profitPercentage.substring(0, profitPercentage.length - 1)) +
          '%',
    );
  }

  Widget buildDialogDropDownMenu(stream, onChanged) {
    return StreamBuilder<String?>(
        initialData: '2020',
        stream: stream,
        builder: (context, yearSnapshot) {
          return Container(
            height: height * .02,
            // padding: EdgeInsets.only(right: width* .04),
            alignment: Alignment.centerRight,
            decoration: BoxDecoration(
              color: AppColors.mainColor,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: DropdownButton<String>(
              value: yearSnapshot.data,
              isExpanded: false,
              icon:
                  const Icon(Icons.keyboard_arrow_down, color: AppColors.blue),
              iconSize: width * .04,
              elevation: 0,
              underline: SizedBox(),
              style: const TextStyle(
                color: Colors.white,
              ),
              onChanged: (String? newValue) {
                if (newValue != null) onChanged(newValue);
              },
              dropdownColor: AppColors.black,
              items: ['2020', '2019', '2018', '2017', '2016', '2015']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Center(
                    child: Text(
                      value,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          height: 1.0,
                          fontSize: AppFonts.getSmallFontSize(context)),
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        });
  }

  Widget buildCardList(
      Map<String, Map<String, List<PrivateAssetMeta>>> assetMetasMap) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: assetMetasMap.length,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) => Column(
        children: [
          buildExpandableCard(
            title: assetMetasMap.keys.elementAt(index),
            map: assetMetasMap.values.toList()[index],
          ),
          SizedBox(height: height * 0.0125),
        ],
      ),
    );
  } //xxx

  Widget buildExpandableCard(
      {required title, required Map<String, List<PrivateAssetMeta>> map}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Container(
        color: AppColors.mainColor,
        child: ExpandablePanel(
          theme: ExpandableThemeData(
            // hasIcon: false,
            collapseIcon: Icons.remove_circle_outline_rounded,
            expandIcon: Icons.add_circle_outline_rounded,
            iconColor: AppColors.blue,
          ),
          header: Container(
            // height: height*.4,
            width: double.infinity,
            padding: EdgeInsets.only(
              top: height * .0185,
              right: width * .04,
              left: width * .04,
              bottom: height * .0185,
            ),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                  8.0 /*topLeft: Radius.circular(8), topRight: Radius.circular(8),*/),
              color: AppColors.mainColor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: AppFonts.getSmallFontSize(context),
                    color: AppColors.white,
                    height: 1.0,
                  ),
                ),
              ],
            ),
          ),
          expanded: buildCardWidget(
            title: title,
            map: map,
          ),
          collapsed: SizedBox(),
        ),
      ),
    );
  }

  Widget buildCardWidget(
      {required title, required Map<String, List<PrivateAssetMeta>> map}) {
    return Container(
        padding: EdgeInsets.only(
          bottom: height * .03,
          left: width * .04,
          right: width * .04,
        ),
        alignment: Alignment.center,
        color: AppColors.mainColor,
        child: Column(
          children: [
            Divider(
              thickness: .75,
              color: Colors.black,
            ),
            SizedBox(height: height * .04),
            Align(
              alignment: Alignment.centerRight,
              child: buildDialogDropDownMenu(
                uiController.incomeAnalysisYearsStream,
                (newValue) => uiController.setIncomeAnalysisYears(newValue),
              ),
            ),
            Divider(
              thickness: .75,
              color: Colors.black,
            ),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: map.length,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                List<PrivateAssetMeta> items =
                    map.values.toList().elementAt(index);
                String title = map.keys.toList().elementAt(index);
                return Column(
                  children: [
                    SizedBox(
                      height: height * .04,
                    ),
                    buildCardItemTitle(
                      title,
                    ),
                    Divider(
                      thickness: .75,
                      color: Colors.black,
                    ),
                    SizedBox(
                      height: height * .008,
                    ),
                    ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: items.length,
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          PrivateAssetMeta item = items[index];
                          return Column(
                            children: [
                              buildCardItem(
                                title: item.label,
                                value: item.value,
                                context: context,
                                width: width,
                              ),
                              SizedBox(
                                height: height * .008,
                              ),
                            ],
                          );
                        }),
                  ],
                );
              },
            ),
          ],
        ));
  }

  Widget buildCardItemTitle(titleKey) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          titleKey,
          style: TextStyle(
            fontSize: AppFonts.getSmallFontSize(context),
            color: AppColors.white,
            fontWeight: FontWeight.w700,
            height: 1.0,
          ),
        ),
        SizedBox(width: width * .06),
        SvgPicture.asset(
          'assets/icons/ic_triangle.svg',
          height: width * .025,
          width: width * .025,
        ),
      ],
    );
  }

  _onWillPop() {
    rootScreenController.setSharedData(HoldingsType.PRIVATE);
    rootScreenController.setCurrentScreen(AppMainScreens.HOLDINGS_SCREEN);
  }
}
