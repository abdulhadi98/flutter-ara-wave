import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

class HoldingsScreen extends BaseStateFullWidget {
  final HoldingsType holdingsType;
  HoldingsScreen({required this.holdingsType});

  @override
  _HoldingsScreenState createState() => _HoldingsScreenState();
}

class _HoldingsScreenState extends BaseStateFullWidgetState<HoldingsScreen>
    with HoldingsScreenDi {
  double get tabsHeight => height * .035;
  double get headerSliverHeight => height * .4;
  var top = 0.0;

  @override
  void initState() {
    super.initState();

    initScreenDi();

    uiController.setHoldingsType(widget.holdingsType);
    uiController.fetchAssetsFinancialsResults();
    uiController.fetchAssetsResults();
    uiController.fetchPublicAssetHistorical();
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
                    SizedBox(height: height * 0.020),
                    if (tab == HoldingsType.PERSONAL)
                      ChartCardItem(chartType: ChartsType.COLUMN),
                    if (tab != HoldingsType.PERSONAL) buildChartWidget(),
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
              return ChartCardItem(
                chartType: ChartsType.AREA,
                filter: uiController.chartFilter,
                historicalDataList: historicalSnapshot.data!.data!,
                onFilterChanged: (filter) =>
                    uiController.fetchPublicAssetHistorical(filter: filter),
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
            logoTitleKey: 'private',
            isAddProgressExist: true,
            addEditIcon: 'assets/icons/ic_add.svg',
            addEditTitleKey: 'new_asset',
            onAddEditClick: () {
              uiController.clearAddAssetInputs();
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
          onAssetAdded: () => uiController.fetchAssetsResults(),
        );

      case HoldingsType.PUBLIC:
        return AddPublicAssetHoldingDialogContent(
          onAssetAdded: () => uiController.fetchAssetsResults(),
        );

      case HoldingsType.PERSONAL:
        return AddPersonalAssetDialogContent(
          onAssetAdded: () => uiController.fetchAssetsResults(),
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
          padding: const EdgeInsets.only(right: 16),
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
          thickness: .5,
          color: Colors.white.withOpacity(.4),
        ),
      ],
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
                  holdingModel.title ?? '',
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
                ImageWidget(
                  url: holdingModel.personalAssetType?.iconUrl ?? '',
                  width: width * .04,
                  height: width * .04,
                  fit: BoxFit.contain,
                ),
                SizedBox(width: width * .02),
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
                  holdingModel.personalAssetType?.personalAssetTypeOptions.first
                          .type ??
                      '',
                  style: TextStyle(
                    fontSize: AppFonts.getMediumFontSize(context),
                    color: AppColors.gray,
                    height: 1.0,
                  ),
                ),
                Spacer(),
                Text(
                  '1',
                  style: TextStyle(
                    fontSize: AppFonts.getMediumFontSize(context),
                    color: AppColors.blue,
                    height: 1.0,
                  ),
                ),
                if (holdingModel.purchasedPrice != null)
                  SizedBox(width: width * .02),
                if (holdingModel.purchasedPrice != null)
                  Container(
                      width: width * .0018,
                      height: height * .018,
                      color: AppColors.blue),
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

  Widget buildPersonalHoldingResult() {
    return StreamBuilder<DataResource<List<PersonalAssetHoldingModel>>?>(
      stream: holdingsBloc.personalAssetHoldingsStream,
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
              return buildPersonalHoldingList(assetsSnapshot.data!.data!);
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











/////////////////////////////////////////////////
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

  Widget buildPublicHoldingList(
    items,
  ) {
    return buildHoldingList(
      itemsCount: items.length,
      itemBuilder: (context, index) =>
          buildPublicHoldingItem(context, index, items.length, items[index]),
    );
  }

  Widget buildPrivateHoldingItem(
      context, index, itemsCount, PrivateHoldingModel item) {
    return Column(
      children: [
        buildAssetItem(
            name: item.asset?.name ?? '',
            salePrice: item.asset?.salePrice.toString(),
            icon: '${UrlsContainer.baseUrl}/${item.asset?.iconUrl}',
            quantity: item.quantity.toString(),
            purchasedPrice: item.purchasedPrice,
            onClick: () {
              AssetsFinancials? financialsModel =
                  uiController.getAssetsFinancials()?.data;
              item.asset?.assetNetworth = financialsModel?.assetNetworth;
              item.asset?.assetGrowth =
                  financialsModel?.getAssetGrowthRounded();

              rootScreenController.setSharedData(item.asset);
              rootScreenController.setCurrentScreen(
                  AppMainScreens.PRIVATE_ASSET_DETAILS_SCREEN);
            }),
        ...getListDividerItems(index, itemsCount),
      ],
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
          // city: item.asset.serialNumber??'',
          quantity: item.quantity.toString(),
          purchasedPrice: item.purchasedPrice,
        ),
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
                if (icon != null) SizedBox(width: width * .02),
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
                  purchasedPrice,
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
