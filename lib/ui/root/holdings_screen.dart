import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:wave_flutter/di/holdings_screen_di.dart';
import 'package:wave_flutter/helper/app_colors.dart';
import 'package:wave_flutter/helper/app_fonts.dart';
import 'package:wave_flutter/helper/enums.dart';
import 'package:wave_flutter/helper/utils.dart';
import 'package:wave_flutter/models/public_asset_graph_model.dart';
import 'package:wave_flutter/models/assets_financials.dart';
import 'package:wave_flutter/models/mocks.dart';
import 'package:wave_flutter/models/personal_asset_holding_model.dart';
import 'package:wave_flutter/models/personal_asset_model.dart';
import 'package:wave_flutter/models/holding_list_model.dart';
import 'package:wave_flutter/models/private_asset_holding_model.dart';
import 'package:wave_flutter/models/asset_list_model.dart';
import 'package:wave_flutter/models/public_asset_holding_model.dart';
import 'package:wave_flutter/services/data_resource.dart';
import 'package:wave_flutter/services/urls_container.dart';
import 'package:wave_flutter/storage/data_store.dart';
import 'package:wave_flutter/ui/common_widgets/add_asset_dialog_content.dart';
import 'package:wave_flutter/ui/common_widgets/base_statefull_widget.dart';
import 'package:wave_flutter/ui/common_widgets/chart_card_item.dart';
import 'package:wave_flutter/ui/common_widgets/error_message_widget.dart';
import 'package:wave_flutter/ui/common_widgets/holdings_type_tab_item.dart';
import 'package:wave_flutter/ui/common_widgets/home_screen_header.dart';
import 'package:intl/intl.dart';
import 'package:wave_flutter/ui/common_widgets/image_widget.dart';
import 'package:wave_flutter/ui/common_widgets/show_add_asset_dialog.dart';
import 'package:wave_flutter/ui/root/add_assets/personal/dialog_content/add_personal_asset_dialog_content.dart';
import 'package:wave_flutter/ui/root/add_assets/private/add_private_asset_dialog_content.dart';
import 'package:wave_flutter/ui/root/add_assets/public/add_public_asset_holding_dialog_content.dart';
import 'package:wave_flutter/ui/root/home_screen.dart';
import 'package:http/http.dart' as http;

class HoldingsScreen extends BaseStateFullWidget {
  final HoldingsType holdingsType;
  static int? assetId;
  static dynamic typeId = 0;
  static dynamic optionValueId = 0;

  static String? stockEx;
  HoldingsScreen({required this.holdingsType});

  @override
  _HoldingsScreenState createState() => _HoldingsScreenState();
}

class _HoldingsScreenState extends BaseStateFullWidgetState<HoldingsScreen>
    with HoldingsScreenDi {
  bool emptyPrivateChart = false;

  double get tabsHeight => height * .035;
  double get headerSliverHeight => height * .4;
  var top = 0.0;
  Xclass xclass = Xclass(dataStore: DataStore(), chartData: xList);

  @override
  void initState() {
    super.initState();

    initScreenDi();
    getPrivateChartValue();
    uiController.setHoldingsType(widget.holdingsType);
    uiController.fetchAssetsFinancialsResults();
    uiController.fetchAssetsResults();
    uiController.fetchPublicAssetHistorical();
    loadingStatus();
  }

  bool privateChartSpinner = false;
  List<ChartData> privateChartData = [];

  void getPrivateChartValue() async {
    setState(() {
      privateChartSpinner = true;
      emptyPrivateChart = false;
    });
    privateChartData.clear();
    print('xxxxx');
    //  dynamic api = _dataStore!.getApiToken();
    // String? api = _dataStore!.userModel!.apiToken;
    // dynamic api = _dataStore!.getApiToken().then((value) => apiToken = value!);
    String? apiToken = HomeScreen.apiToken;
    var request;
    var response;
    var url = Uri.parse(
      'https://wave.aratech.co/api/get-private-assets-chart',
    );
    print('///////////' + url.toString() + '//tokennnnnn///' + apiToken!);

    request = http.MultipartRequest('POST', url);
    request.fields['api_token'] = apiToken;
    response = await request.send();
    var xx = await http.Response.fromStream(response);
    var x = jsonDecode(xx.body);

    print('///////////////////////////////////////////////////');
    print(x.toString() + 'sdsdsd');
    print('///////////////////////////////////////////////////');
    try {
      Map<dynamic, dynamic> payload = x['data'];
      payload.forEach((element, val) {
        var t = element;
        if (t.length >= 10)
          t = t.substring(0, 10);
        else if (t.length < 5) t = t + '-01-01';
        //  String temp = t.length >= 10 ? t.substring(0, 10) : t;
        DateTime acquisitionDate = DateTime.parse(t);
        print('$acquisitionDate' + '');

        int growth = val.toInt();
        // int intGrowth = growth.toInt();
        // print('$growth' + 'aloalo');
        // if (growth == 0) growth = 0.01;
        privateChartData.add(ChartData(acquisitionDate, growth));

        print('personalAassetTtype = $acquisitionDate');
        print('growth = $growth');
      });
    } catch (e) {
      print(e);
      setState(() {
        emptyPrivateChart = true;
        privateChartSpinner = false;
      });
    }

    ChartData? other;

    setState(() {
      privateChartSpinner = false;
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
            dataSource: privateChartData,
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

  bool loading = false;
  loadingStatus() async {
    setState(() {
      loading = true;
    });
    await xclass.getPersonalChartValue();
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: WillPopScope(
        onWillPop: () => rootScreenController
            .setCurrentScreen(AppMainScreens.MY_PORTFOLIO_SCREEN),
        child: StreamBuilder<HoldingsType>(
            initialData: HoldingsType.PRIVATE,
            stream: uiController.holdingsTypeStream,
            builder: (context, typeSnapshot) {
              return NestedScrollView(
                physics: ClampingScrollPhysics(),
                headerSliverBuilder: (context, bool innerBoxIsScrolled) {
                  return [
                    buildSettingsAndTabsSliver(
                        context, typeSnapshot.data!, innerBoxIsScrolled),
                  ];
                },
                body: Builder(
                  builder: (context) {
                    final ScrollController? innerScrollController =
                        PrimaryScrollController.of(context);
                    return Container(
                      padding: EdgeInsets.only(
                        top: tabsHeight + 48,
                        right: width * .05,
                        left: width * .05,
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: height * 0.03),
                          buildSeparatorItem(),
                          buildHoldingResults(
                            typeSnapshot.data!,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            }),
      ),
    );
  }

  buildSettingsAndTabsSliver(context, HoldingsType tab, innerBoxIsScrolled) {
    double expandedHeaderHeight = height * .55;

    return SliverOverlapAbsorber(
      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
      sliver: SliverAppBar(
        primary: true,
        floating: true,
        pinned: true,
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.black,
        elevation: 2.0,
        collapsedHeight: tabsHeight,
        toolbarHeight: tabsHeight,
        expandedHeight: expandedHeaderHeight,
        forceElevated: innerBoxIsScrolled,
        // title: Text(chatTitle),
        flexibleSpace: LayoutBuilder(
          builder: (context, constraints) {
            top = constraints.biggest.height;
            bool isCollapsed = top.toInt() ==
                (tabsHeight + mediaQuery.padding.top + tabsHeight).toInt();

            return FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: Padding(
                padding: EdgeInsets.only(
                  top: mediaQuery.padding.top,
                  right: width * .05,
                  left: width * .05,
                ),
                child: Column(
                  children: [
                    SizedBox(height: height * 0.020),
                    buildHeader(tab),
                    // MaterialButton(
                    //   onPressed: () {},
                    //   height: 50,
                    //   color: Colors.red,
                    // ),
                    SizedBox(height: height * 0.020),
                    if (tab == HoldingsType.PERSONAL)
                      loading
                          ? Container(
                              height: height * .22,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(),
                                ],
                              ),
                            )
                          : ChartCardItem(
                              chartType: ChartsType.COLUMN,
                            ),
                    if (tab == HoldingsType.PUBLIC) buildChartWidget(),
                    if (tab == HoldingsType.PRIVATE)
                      privateChartSpinner
                          ? Container(
                              height: height * .22,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(),
                                ],
                              ),
                            )
                          : emptyPrivateChart
                              ? Container(
                                  height: height * .22,
                                  child: Center(
                                    child: Text(
                                      'Try to add some assets',
                                      style: TextStyle(
                                        fontSize:
                                            AppFonts.getMediumFontSize(context),
                                        color: Colors.white,
                                        height: 1.0,
                                      ),
                                    ),
                                  ),
                                )
                              : protfolioWidget(),

                    // (tab != HoldingsType.PERSONAL && loading == false)
                    //     ? buildChartWidget()
                    //     : Center(
                    //         child: CircularProgressIndicator(
                    //             color: Colors.transparent),
                    //       ),
                    SizedBox(height: height * 0.020),
                  ],
                ),
              ),
            );
          },
        ),
        bottom: buildHoldingTypeTaps(tab),
      ),
    );
  }

  Widget buildChartWidget() {
    return StreamBuilder<DataResource<List<PublicAssetGraphModel>>?>(
      stream: holdingsBloc.publicAssetGraphStream,
      builder: (context, historicalSnapshot) {
        if (historicalSnapshot.hasData && historicalSnapshot.data != null) {
          switch (historicalSnapshot.data!.status) {
            case Status.LOADING:
              return Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            case Status.SUCCESS:
              return Container(
                height: height * .25,
                child: ChartCardItem(
                  chartType: ChartsType.AREA,
                  filter: uiController.chartFilter,
                  historicalDataList: historicalSnapshot.data!.data!,
                  onFilterChanged: (filter) =>
                      uiController.fetchPublicAssetHistorical(filter: filter),
                ),
              );
            case Status.NO_RESULTS:
              return ErrorMessageWidget(
                  messageKey: 'no_result_found_message',
                  image: 'assets/images/ic_not_found.png');
            case Status.FAILURE:
              return ErrorMessageWidget(
                  messageKey: historicalSnapshot.data?.message ?? '',
                  image: 'assets/images/ic_error.png');

            default:
              return Container();
          }
        } else {
          return Container();
        }
      },
    );
  }

  Widget buildHeader(HoldingsType type) {
    print('zxzxzx ${type.toString().split('.').last.toLowerCase()}');
    return StreamBuilder<DataResource<AssetsFinancials>?>(
        stream: uiController.assetsFinancialsStream,
        builder: (context, financialsSnapshot) {
          return buildHeaderComponents(
            titleWidget: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => rootScreenController
                      .setCurrentScreen(AppMainScreens.MY_PORTFOLIO_SCREEN),
                  child: Row(
                    children: [
                      SizedBox(width: width * .04),
                      Icon(
                        Icons.arrow_back_ios_rounded,
                        color: AppColors.gray,
                        size: width * .075,
                      ),
                      SizedBox(width: width * .06),
                      Text(
                        uiController.getScreenTitle(appLocal),
                        style: TextStyle(
                          fontSize: AppFonts.getMediumFontSize(context),
                          color: Colors.white,
                          height: 1.0,
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
            logoTitleKey: type.toString().split('.').last.toLowerCase(),
            isAddProgressExist: true,
            addEditIcon: 'assets/icons/ic_add.svg',
            addEditTitleKey: 'new_asset',
            onAddEditClick: () {
              uiController.clearAddAssetInputs();
              print('HoldingsScreen.typeId = -4');
              HoldingsScreen.typeId = -4;
              showAddAssetDialog(
                context: context,
                padding: EdgeInsets.only(
                  right: width * .1,
                  left: width * .1,
                  top: height * .05, /*bottom: height* .05,*/
                ),
                dialogContent: getAddAssetDialogContent(type),
              );
            },
            netWorth: financialsSnapshot.data?.data?.formattedNetWorth ?? '',
            growth: financialsSnapshot.data?.data?.getAssetGrowthRounded(),
          );
        });
  }

  Widget getAddAssetDialogContent(type) {
    switch (type) {
      case HoldingsType.PRIVATE:
        return AddPrivateAssetDialogContent(
          onAssetAdded: () {
            uiController.fetchAssetsResults();
            getPrivateChartValue();
          },
        );

      case HoldingsType.PUBLIC:
        return AddPublicAssetHoldingDialogContent(
          onAssetAdded: () => uiController.fetchAssetsResults(),
        );

      case HoldingsType.PERSONAL:
        return AddPersonalAssetDialogContent(
          onAssetAdded: () async {
            uiController.fetchAssetsResults();
            setState(() {
              loading = true;
            });
            await xclass.getPersonalChartValue();
            setState(() {
              loading = false;
            });
          }, //rechart
        );

      default:
        return Container();
    }
  }

  PreferredSize buildHoldingTypeTaps(HoldingsType type) {
    onClick(holdingType) {
      uiController.setHoldingsType(holdingType);
      uiController.fetchAssetsFinancialsResults();
      uiController.fetchAssetsResults();
      getPrivateChartValue();
    }

    return PreferredSize(
      preferredSize: Size(
        width,
        tabsHeight,
      ),
      child: Row(
        children: [
          SizedBox(width: width * 0.050),
          HoldingsTypeTapItem(HoldingsType.PRIVATE,
              type == HoldingsType.PRIVATE, appLocal.trans("private"), onClick),
          SizedBox(width: width * .020),
          HoldingsTypeTapItem(HoldingsType.PUBLIC, type == HoldingsType.PUBLIC,
              appLocal.trans("public"), (holdingType) {
            onClick(holdingType);
            uiController.fetchPublicAssetHistorical();
          }),
          SizedBox(width: width * .020),
          HoldingsTypeTapItem(
              HoldingsType.PERSONAL,
              type == HoldingsType.PERSONAL,
              appLocal.trans("personal"),
              onClick),
          SizedBox(width: width * 0.050),
        ],
      ),
    );
  }

  Widget buildSeparatorItem() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: EdgeInsets.only(right: width * 0.013),
          child: Text(
            appLocal.trans('equity'),
            style: TextStyle(
              color: Colors.white,
              fontSize: AppFonts.getXSmallFontSize(context),
              height: 1.0,
            ),
          ),
        ),
        Divider(
          height: 3,
          thickness: .7,
          color: Colors.white.withOpacity(.4),
        ),
      ],
    );
  }

  Widget buildPersonalHoldingResult() {
    return StreamBuilder<DataResource<List<PersonalAssetHoldingModel>>?>(
      stream: holdingsBloc.personalAssetHoldingsStream,
      builder: (context, assetsSnapshot) {
        if (assetsSnapshot.hasData && assetsSnapshot.data != null) {
          // print('aass'+assetsSnapshot.data!.data!.isEmpty.toString());
          //  print('aewe' + assetsSnapshot.data!.data.toString());
          switch (assetsSnapshot.data!.status) {
            case Status.LOADING:
              return Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            case Status.SUCCESS:
              {
                print(assetsSnapshot.data!.data!.first.id);
                return buildPersonalHoldingList(assetsSnapshot.data!.data!);
              }
            case Status.NO_RESULTS:
              return ErrorMessageWidget(
                  messageKey: 'no_result_found_message',
                  image: 'assets/images/ic_not_found.png');
            case Status.FAILURE:
              {
                // print('cya' + assetsSnapshot.data!.data!.length.toString());

                return ErrorMessageWidget(
                    messageKey: assetsSnapshot.data?.message ?? '',
                    image: 'assets/images/ic_error.png');
              }

            default:
              return Container();
          }
        } else {
          return Container();
        }
      },
    );
  }

  Widget buildPersonalHoldingList(items) {
    return buildHoldingList(
      itemsCount: items.length,
      itemBuilder: (context, index) =>
          buildPersonalHoldingItem(context, index, items.length, items[index]),
    );
  }

  Widget buildPersonalHoldingItem(context, index, itemsCount, item) {
    return Column(
      children: [
        buildPersonalAssetItem(
          item,
        ),
        ...getListDividerItems(index, itemsCount),
      ],
    );
  }

  Widget buildPersonalAssetItem(
    PersonalAssetHoldingModel holdingModel,
  ) {
    return InkWell(
      onTap: () {
        HoldingsScreen.assetId = holdingModel.id;
        print(HoldingsScreen.assetId.toString());
        // rootScreenController.setSharedData(holdingModel.personalAssetType);
        rootScreenController.setSharedData(holdingModel);
        rootScreenController
            .setCurrentScreen(AppMainScreens.PERSONAL_ASSET_DETAILS_SCREEN);
      },
      child: Container(
        padding: EdgeInsets.only(
            right: width * .01, top: height * .01, bottom: height * .01),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  holdingModel.title ??
                      holdingModel.personalAssetType?.personalAssetTypeOptions
                          .first.name ??
                      '',
                  style: TextStyle(
                    fontSize: AppFonts.getNormalFontSize(context),
                    color: Colors.white,
                  ),
                ),
                Text(
                  holdingModel.purchasedPrice ?? '',
                  style: TextStyle(
                    fontSize: AppFonts.getNormalFontSize(context),
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: height * .02),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ImageWidget(
                //   url: holdingModel.personalAssetType?.iconUrl ?? '',
                //   width: width * .04,
                //   height: width * .04,
                //   fit: BoxFit.contain,
                // ),
                // SizedBox(width: width * .02),
                Text(
                  holdingModel.personalAssetType?.personalAssetTypeOptions.first
                          .name ??
                      '',
                  style: TextStyle(
                    fontSize: AppFonts.getMediumFontSize(context),
                    color: AppColors.gray,
                    height: 1.0,
                  ),
                ),
                SizedBox(width: width * .02),
                Container(
                  width: width * .0018,
                  height: height * .018,
                  color: AppColors.gray,
                ),
                SizedBox(width: width * .02),
                Text(
                  holdingModel.subType ?? 'null',
                  style: TextStyle(
                    fontSize: AppFonts.getMediumFontSize(context),
                    color: AppColors.gray,
                    height: 1.0,
                  ),
                ),
                Spacer(),

                if (holdingModel.purchasedPrice != null)
                  SizedBox(width: width * .02),

                if (holdingModel.purchasedPrice != null)
                  SizedBox(width: width * .02),
                if (holdingModel.purchasedPrice != null)
                  Text(
                    holdingModel.purchasedPrice ?? '',
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
      ),
    );
  }

  Widget buildHoldingResults(type) {
    switch (type) {
      case HoldingsType.PRIVATE:
        return buildPrivateHoldingResult(
          HoldingsType.PRIVATE,
        );

      case HoldingsType.PUBLIC:
        return buildPrivateHoldingResult(
          HoldingsType.PUBLIC,
        );

      case HoldingsType.PERSONAL:
        return buildPersonalHoldingResult();

      default:
        return Container();
    }
  }

  Widget buildPrivateHoldingResult(
    type,
  ) {
    return StreamBuilder<DataResource<List<HoldingModel>>>(
      stream: holdingsBloc.assetHoldingsStream,
      builder: (context, assetsSnapshot) {
        if (assetsSnapshot.hasData && assetsSnapshot.data != null) {
          switch (assetsSnapshot.data!.status) {
            case Status.LOADING:
              return Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            case Status.SUCCESS:
              if (type == HoldingsType.PRIVATE)
                return buildPrivateHoldingList(
                  assetsSnapshot.data!.data!,
                );
              else
                return buildPublicHoldingList(
                  assetsSnapshot.data!.data!,
                );
            case Status.NO_RESULTS:
              return ErrorMessageWidget(
                  messageKey: 'no_result_found_message',
                  image: 'assets/images/ic_not_found.png');
            case Status.FAILURE:
              return ErrorMessageWidget(
                  messageKey: assetsSnapshot.data?.message ?? '',
                  image: 'assets/images/ic_error.png');

            default:
              return Container();
          }
        } else {
          return Container();
        }
      },
    );
  }

  Widget buildHoldingList({
    required int itemsCount,
    required itemBuilder,
  }) {
    return Expanded(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: itemsCount,
        padding: EdgeInsets.zero,
        itemBuilder: itemBuilder,
      ),
    );
  }

  List<Widget> getListDividerItems(index, itemsCount) => [
        if (index != itemsCount - 1)
          Divider(
            thickness: .5,
            color: Colors.white.withOpacity(.4),
          ),
        if (index == itemsCount - 1)
          SizedBox(
            height: height * .025,
          ),
      ];

  Widget buildPrivateHoldingList(
    items,
  ) {
    return buildHoldingList(
      itemsCount: items.length,
      itemBuilder: (BuildContext context, int index) =>
          buildPrivateHoldingItem(context, index, items.length, items[index]),
    );
  }

  Widget buildPrivateHoldingItem(
      context, index, itemsCount, PrivateHoldingModel item) {
    return Column(
      children: [
        buildAssetItem(
            name: item.asset?.name ?? '',
            city: item.country,
            country: item.headquarterCity,
            salePrice: item.asset?.salePrice.toString(),
            icon:
                'https://wave.aratech.co/images/private_assets/${item.asset?.icon}',
            quantity: item.quantity.toString(),
            purchasedPrice:
                double.parse(item.purchasedPrice).toStringAsFixed(3).toString(),
            onClick: () {
              HoldingsScreen.assetId = item.id;
              print('zzzzzzz' +
                  item.id.toString() +
                  '  ' +
                  '${item.asset!.assetType!.kind}');

              if (item.asset!.assetType!.kind == 'holding') {
                rootScreenController.setSharedData(item.asset);
                rootScreenController.setCurrentScreen(
                    AppMainScreens.PRIVATE_ASSET_DETAILS_SCREEN);
              } else {
                rootScreenController.setSharedData(item.asset);
                rootScreenController.setCurrentScreen(
                    AppMainScreens.PERSONAL_ASSET_MANUAL_DETAILS_SCREEN);
              }
            }),
        ...getListDividerItems(index, itemsCount),
      ],
    );
  }

  Widget buildPublicHoldingList(
    items,
  ) {
    return buildHoldingList(
      itemsCount: items.length,
      itemBuilder: (context, index) =>
          buildPublicHoldingItem(context, index, items.length, items[index]),
    );
  }

  Widget buildPublicHoldingItem(
      context, index, itemsCount, PublicHoldingModel item) {
    return Column(
      children: [
        buildAssetItem(
            name: item.asset.name ?? '',
            salePrice: item.asset.salePrice.toString(),
            country: item.asset.stockSymbol ?? '',
            city: item.stockEx ?? '',
            quantity: item.quantity.toString(),
            purchasedPrice:
                double.parse(item.purchasedPrice).toStringAsFixed(2).toString(),
            onClick: () {
              HoldingsScreen.assetId = item.id;

              HoldingsScreen.stockEx = item.asset.stockSymbol;
              print('zzzzzzz' +
                  item.id.toString() +
                  '  ' +
                  item.asset.stockSymbol!);

              rootScreenController.setSharedData(item.asset);
              rootScreenController
                  .setCurrentScreen(AppMainScreens.PUBLIC_ASSET_DETAILS_SCREEN);
            }),
        ...getListDividerItems(index, itemsCount),
      ],
    );
  }

  Widget buildAssetItem({
    onClick,
    name,
    salePrice,
    icon,
    country,
    city,
    quantity,
    purchasedPrice,
  }) {
    return InkWell(
      onTap: onClick,
      child: Container(
        padding: EdgeInsets.only(
            right: width * .01, top: height * .01, bottom: height * .01),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: AppFonts.getNormalFontSize(context),
                    color: Colors.white,
                  ),
                ),
                Text(
                  //privateValue
                  Utils.getFormattedNum(
                      double.parse(purchasedPrice.toString()) *
                          int.parse(quantity.toString())),
                  style: TextStyle(
                    fontSize: AppFonts.getNormalFontSize(context),
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: height * .02),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (icon != null)
                  ImageWidget(
                    url: icon,
                    width: width * .04,
                    height: width * .04,
                  ),
                if (icon != null &&
                    icon != 'https://wave.aratech.co/images/private_assets/123')
                  SizedBox(width: width * .02),
                // if (icon == '123') SizedBox(width: width * .02),
                Text(
                  country ?? '',
                  style: TextStyle(
                    fontSize: AppFonts.getMediumFontSize(context),
                    color: AppColors.gray,
                    height: 1.0,
                  ),
                ),
                SizedBox(width: width * .02),
                if (city != null)
                  Container(
                    width: width * .0018,
                    height: height * .018,
                    color: AppColors.gray,
                  ),
                if (city != null) SizedBox(width: width * .02),
                if (city != null)
                  Text(
                    city ?? '',
                    style: TextStyle(
                      fontSize: AppFonts.getMediumFontSize(context),
                      color: AppColors.gray,
                      height: 1.0,
                    ),
                  ),
                Spacer(),
                Text(
                  quantity,
                  style: TextStyle(
                    fontSize: AppFonts.getMediumFontSize(context),
                    color: AppColors.blue,
                    height: 1.0,
                  ),
                ),
                SizedBox(width: width * .02),
                Container(
                    width: width * .0018,
                    height: height * .018,
                    color: AppColors.blue),
                SizedBox(width: width * .02),
                Text(
                  '\$' + purchasedPrice,
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
      ),
    );
  }
}
