import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wave_flutter/di/private_asset_setails_screen_di.dart';
import 'package:wave_flutter/helper/app_colors.dart';
import 'package:wave_flutter/helper/app_fonts.dart';
import 'package:wave_flutter/helper/enums.dart';
import 'package:wave_flutter/models/private_asset_model.dart';
import 'package:wave_flutter/services/data_resource.dart';
import 'package:wave_flutter/ui/common_widgets/base_statefull_widget.dart';
import 'package:wave_flutter/ui/common_widgets/card_item_details_screen.dart';
import 'package:wave_flutter/ui/common_widgets/chart_card_item.dart';
import 'package:wave_flutter/ui/common_widgets/chart_info_card_item.dart';
import 'package:wave_flutter/ui/common_widgets/error_message_widget.dart';
import 'package:wave_flutter/ui/common_widgets/home_screen_header.dart';

class PrivateAssetDetailsScreen extends BaseStateFullWidget {
  final PrivateAssetModel assetModel;
  PrivateAssetDetailsScreen({required this.assetModel});

  @override
  _PrivateAssetDetailsScreenState createState() => _PrivateAssetDetailsScreenState();
}

class _PrivateAssetDetailsScreenState extends BaseStateFullWidgetState<PrivateAssetDetailsScreen> with PrivateAssetDetailsScreenDi{

  @override
  void initState() {
    super.initState();

    initScreenDi();
    uiController.fetchResult();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: AppColors.black,
      body: WillPopScope(
        onWillPop: () => _onWillPop(),
        child: Container(
          padding: EdgeInsets.only(top: mediaQuery.padding.top, right: width* .05, left: width* .05,),
          child: buildAssetResults(),
        ),
      ),
    );
  }

  Widget buildAssetResults(){
    // switch(widget.assetModel.type){
    //   case 0:
    //     return Column(
    //       children: [
    //         SizedBox(height: height* 0.02),
    //         buildHeader(),
    //         SizedBox(height: height* 0.020),
    //         ChartCardItem(chartType: ChartsType.AREA),
    //         SizedBox(height: height* 0.020),
    //         Row(
    //           children: [
    //             ChartInfoCardItem(itemHeight: height* .12, title: appLocal.trans('invested'), value: "\$23",),
    //             SizedBox(width: width* 0.025,),
    //             ChartInfoCardItem(itemHeight: height* .12, title: appLocal.trans('est_profit'), value: "\$80",),
    //             SizedBox(width: width* 0.025,),
    //             ChartInfoCardItem(itemHeight: height* .12, title: '${appLocal.trans('profit')} %', value: "+ \$114k",),
    //           ],
    //         ),
    //         SizedBox(height: height* 0.020),
    //         buildSeparatorItem(),
    //         buildInvestmentList(),
    //       ],
    //     );
    //
    //   case 1:
    //
    //
    //   default: return Container();
    // }

    return StreamBuilder<DataResource<List<PrivateAssetModel>>?>(
      stream: privateAssetDetailsScreenBloc.privateAssetsStream,
      builder: (context, assetsSnapshot) {
        if (assetsSnapshot.hasData && assetsSnapshot.data != null) {
          switch (assetsSnapshot.data!.status) {
            case Status.LOADING:
              return Expanded(child: Center(child: CircularProgressIndicator(),),);
            case Status.SUCCESS:
              return buildScreenContent(assetsSnapshot.data!.data!.first);
            case Status.NO_RESULTS:
              return ErrorMessageWidget(messageKey: 'no_result_found_message', image: 'assets/images/ic_not_found.png');
            case Status.FAILURE:
              return ErrorMessageWidget(messageKey: assetsSnapshot.data?.message??'', image: 'assets/images/ic_error.png');

            default:
              return Container();
          }
        } else {
          return Container();
        }
      }
    );
  }

  Widget buildScreenContent(PrivateAssetModel asset) {
    return Column(
      children: [
        SizedBox(height: height* 0.02),
        buildHeader(),
        SizedBox(height: height* 0.020),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                ChartCardItem(chartType: ChartsType.AREA),
                SizedBox(height: height* 0.020),
                Row(
                  children: [
                    ChartInfoCardItem(title: appLocal.trans('purchased_price'), value: "\$${asset.purchasePrice}", bottomLabel: appLocal.trans('average_cost')),
                    SizedBox(width: width* 0.025,),
                    ChartInfoCardItem(title: appLocal.trans('market_price'), value: "\$${asset.salePrice}", bottomLabel: appLocal.trans('current_share_price')),
                    SizedBox(width: width* 0.025,),
                    ChartInfoCardItem(title: appLocal.trans('profit_loss'), value: widget.assetModel.assetGrowth, bottomLabel: widget.assetModel.assetGrowth),
                  ],
                ),
                // SizedBox(height: height* 0.020),
                // buildUserInvestmentDetailsCard(),
                SizedBox(height: height* 0.020),
                buildCardList(asset.assetMetasMap),


                // ChartCardItem(chartType: ChartsType.COLUMN_ROUNDED_CORNER, chartTitleKey: 'projected_flow_cash'),
                // ChartCardItem(chartType: ChartsType.COLUMN_ROUNDED_CORNER, chartTitleKey: 'projected_net_profit_margin'),
                // ChartCardItem(chartType: ChartsType.RANGE_COLUMN, chartTitleKey: 'market_value_vs_intrinsic_value'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildHeader(){
    return buildHeaderComponents(
        titleWidget: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _onWillPop,
              child: Row(
                children: [
                  SizedBox(width: width* .04),
                  Icon(Icons.arrow_back_ios_rounded, color: AppColors.gray, size: width* .075,),
                  SizedBox(width: width* .06),
                  Column(
                    children: [
                      Text(
                        widget.assetModel.name??'',
                        style: TextStyle(
                          fontSize: AppFonts.getMediumFontSize(context),
                          color: Colors.white,
                          height: 1.0,
                        ),
                      ),
                      SizedBox(height: height* .01),
                      Text(
                        '',
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
      netWorth: '${widget.assetModel.assetNetworth??0}',
      growth: widget.assetModel.assetGrowth,
    );
  }

  // Widget buildInvestmentList(){
  //   assetItem(Investment investment){
  //     return InkWell(
  //       onTap: () {},
  //       child: Container(
  //         padding: EdgeInsets.only(right: width* .02, top: height* .01, bottom: height* .01),
  //         child: IntrinsicHeight(
  //           child: Row(
  //             crossAxisAlignment: CrossAxisAlignment.stretch,
  //             children: [
  //               Flexible(
  //                 flex: 3,
  //                 fit: FlexFit.tight,
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Text(
  //                       investment.title,
  //                       style: TextStyle(
  //                         fontSize: AppFonts.getMediumFontSize(context),
  //                         color: Colors.white,
  //                       ),
  //                     ),
  //                     SizedBox(height: height* .012),
  //                     Row(
  //                       crossAxisAlignment: CrossAxisAlignment.end,
  //                       children: [
  //                         SvgPicture.asset(
  //                           investment.icon.url,
  //                           width: width* .045,
  //                           height: width* .045,
  //                           fit: BoxFit.contain,
  //                           // color: AppColors.gray,
  //                         ),
  //                         SizedBox(width: width* .02),
  //                         Text(
  //                           investment.state,
  //                           style: TextStyle(
  //                             fontSize: AppFonts.getXSmallFontSize(context),
  //                             color: AppColors.gray,
  //                             height: 1.0,
  //                           ),
  //                         ),
  //                         SizedBox(width: width* .02),
  //                         Container(
  //                           width: width* .0018,
  //                           height: height* .018,
  //                           color: AppColors.gray,
  //                         ),
  //                         SizedBox(width: width* .02),
  //                         Text(
  //                           investment.country,
  //                           style: TextStyle(
  //                             fontSize: AppFonts.getXSmallFontSize(context),
  //                             color: AppColors.gray,
  //                             height: 1.0,
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //               SizedBox(width: width*.04),
  //               Flexible(
  //                 flex: 1,
  //                 fit: FlexFit.tight,
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.end,
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     FittedBox(
  //                       child: Text(
  //                         investment.total.toString(),
  //                         style: TextStyle(
  //                           fontSize: AppFonts.getSmallFontSize(context),
  //                           color: Colors.white,
  //                         ),
  //                       ),
  //                     ),
  //                     // SizedBox(height: height* .012),
  //                     Row(
  //                       crossAxisAlignment: CrossAxisAlignment.end,
  //                       mainAxisAlignment: MainAxisAlignment.end,
  //                       children: [
  //                         SvgPicture.asset(
  //                           'assets/icons/ic_up_arrow.svg',
  //                           width: width* .025,
  //                           height: width* .025,
  //                           fit: BoxFit.cover,
  //                         ),
  //                         SizedBox(width: width*.02),
  //                         Text(
  //                           '${investment.incrementPercentage}%',
  //                           style: TextStyle(
  //                             fontSize: AppFonts.getXSmallFontSize(context),
  //                             color: AppColors.blue,
  //                             height: 1.0,
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //               SizedBox(width: width*.04),
  //               Flexible(
  //                 flex: 1,
  //                 fit: FlexFit.tight,
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.end,
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     FittedBox(
  //                       child: Text(
  //                         investment.currency.toString(),
  //                         style: TextStyle(
  //                           fontSize: AppFonts.getSmallFontSize(context),
  //                           color: Colors.white,
  //                         ),
  //                       ),
  //                     ),
  //                     // SizedBox(height: height* .012),
  //                     Text(
  //                       '${investment.percentage}%',
  //                       style: TextStyle(
  //                         fontSize: AppFonts.getSmallFontSize(context),
  //                         color: AppColors.blue,
  //                         height: 1.0,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     );
  //   }
  //
  //   return Expanded(
  //     child: ListView.builder(
  //       scrollDirection: Axis.vertical,
  //       itemCount: widget.assetModel.investments?.length,
  //       padding: EdgeInsets.zero,
  //       itemBuilder: (context, index) {
  //         return Column(
  //           children: [
  //             assetItem(widget.assetModel.investments![index]),
  //             if(index != widget.assetModel.investments!.length-1) Divider(thickness: .5, color: Colors.white.withOpacity(.4),),
  //             if(index == widget.assetModel.investments!.length-1) SizedBox(height: height* .025,)
  //           ],
  //         );
  //       },
  //     ),
  //   );
  // }
  //
  // Widget buildUserInvestmentDetailsCard() {
  //   userInvestmentDetailsItem(icon, title, value){
  //     return Column(
  //       children: [
  //         Row(
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           children: [
  //             SvgPicture.asset(
  //               icon,
  //               width: width* .045,
  //               height: width* .045,
  //               fit: BoxFit.contain,
  //               // color: AppColors.gray,
  //             ),
  //             SizedBox(width: width* .025),
  //             Text(
  //               title,
  //               style: TextStyle(
  //                 fontSize: AppFonts.getSmallFontSize(context),
  //                 color: AppColors.white,
  //                 height: 1.0,
  //               ),
  //             ),
  //             Spacer(),
  //             Text(
  //               value,
  //               style: TextStyle(
  //                 fontSize: AppFonts.getSmallFontSize(context),
  //                 color: AppColors.white,
  //                 height: 1.0,
  //               ),
  //             ),
  //             SizedBox(width: width* .05),
  //           ],
  //         ),
  //         Divider(thickness: .75, color: Colors.black,),
  //       ],
  //     );
  //   }
  //
  //   return Container(
  //     width: double.infinity,
  //     padding: EdgeInsets.symmetric(vertical: height* .03, horizontal: width* .04),
  //     alignment: Alignment.center,
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(8),
  //       color: AppColors.mainColor,
  //     ),
  //     child: Column(
  //       children: [
  //         if(Utils.isExist(widget.assetModel.sharesOwned)) userInvestmentDetailsItem(
  //             'assets/icons/ic_coins.svg',
  //             appLocal.trans('shared_owned'),
  //             '${widget.assetModel.sharesOwned} ${appLocal.trans('shares')}',
  //         ),
  //         if(Utils.isExist(widget.assetModel.sharesOwned)) SizedBox(height: height* .008,),
  //         if(Utils.isExist(widget.assetModel.totalAmountInvested)) userInvestmentDetailsItem(
  //           'assets/icons/ic_price_tag.svg',
  //           appLocal.trans('total_amount_invested'),
  //           '\$ ${widget.assetModel.totalAmountInvested}}',
  //         ),
  //         if(Utils.isExist(widget.assetModel.totalAmountInvested)) SizedBox(height: height* .008,),
  //         if(Utils.isExist(widget.assetModel.dividendYield)) userInvestmentDetailsItem(
  //           'assets/icons/ic_percentage.svg',
  //           appLocal.trans('dividend_yield'),
  //           '${widget.assetModel.dividendYield} % - APY',
  //         ),
  //         if(Utils.isExist(widget.assetModel.dividendYield)) SizedBox(height: height* .008,),
  //         if(Utils.isExist(widget.assetModel.marketCapitalization)) userInvestmentDetailsItem(
  //           'assets/icons/ic_bar_chart.svg',
  //           appLocal.trans('market_capitalization'),
  //           '\$${widget.assetModel.marketCapitalization}',
  //         ),
  //         if(Utils.isExist(widget.assetModel.marketCapitalization)) SizedBox(height: height* .008,),
  //         if(Utils.isExist(widget.assetModel.sharesOutstanding)) userInvestmentDetailsItem(
  //           'assets/icons/ic_double_coins.svg',
  //           appLocal.trans('shares_outstanding'),
  //           '${widget.assetModel.sharesOutstanding}',
  //         ),
  //         if(Utils.isExist(widget.assetModel.sharesOutstanding)) SizedBox(height: height* .008,),
  //         if(Utils.isExist(widget.assetModel.shareClass)) userInvestmentDetailsItem(
  //           'assets/icons/ic_contract_law.svg',
  //           appLocal.trans('share_class'),
  //           '${widget.assetModel.shareClass}}',
  //         ),
  //         // if(Utils.isExist(widget.assetModel.shareClass)) SizedBox(height: height* .008,),
  //       ],
  //     ),
  //   );
  // }

  Widget buildDialogDropDownMenu(stream, onChanged){
    return StreamBuilder<String?>(
      initialData: '2020',
        stream: stream,
        builder: (context, yearSnapshot) {
          return Container(
            height: height* .02,
            // padding: EdgeInsets.only(right: width* .04),
            alignment: Alignment.centerRight,
            decoration: BoxDecoration(
              color: AppColors.mainColor,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: DropdownButton<String>(
              value: yearSnapshot.data,
              isExpanded: false,
              icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.blue),
              iconSize: width* .04,
              elevation: 0,
              underline: SizedBox(),
              style: const TextStyle(color: Colors.white,),
              onChanged: (String? newValue) {
                if(newValue!=null) onChanged(newValue);
              },
              dropdownColor: AppColors.black,
              items: ['2020', '2019', '2018', '2017', '2016', '2015'].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Center(
                    child: Text(
                      value,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(height: 1.0, fontSize: AppFonts.getSmallFontSize(context)),
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        }
    );
  }

  Widget buildCardList(Map<String, Map<String, List<PrivateAssetMeta>>> assetMetasMap) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: assetMetasMap.length,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) => Column(
        children: [
          buildExpandableCard(title: assetMetasMap.keys.elementAt(index), map: assetMetasMap.values.toList()[index],),
          SizedBox(height: height* 0.0125),
        ],
      ),
    );
  }

  Widget buildExpandableCard({required title, required Map<String, List<PrivateAssetMeta>> map}) {
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
            padding: EdgeInsets.only(top: height* .0185, right: width* .04, left: width* .04, bottom: height* .0185,),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0/*topLeft: Radius.circular(8), topRight: Radius.circular(8),*/),
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
          expanded: buildCardWidget(title: title, map: map,),
          collapsed: SizedBox(),
        ),
      ),
    );
  }

  Widget buildCardWidget({required title, required Map<String, List<PrivateAssetMeta>> map}) {
    return Container(
      padding: EdgeInsets.only(bottom: height* .03, left: width* .04, right: width* .04,),
      alignment: Alignment.center,
        color: AppColors.mainColor,
      child: Column(
        children: [
          Divider(thickness: .75, color: Colors.black,),
          SizedBox(height: height*.04),
          Align(
            alignment: Alignment.centerRight,
            child: buildDialogDropDownMenu(
              uiController.incomeAnalysisYearsStream, (newValue) => uiController.setIncomeAnalysisYears(newValue),
            ),
          ),
          Divider(thickness: .75, color: Colors.black,),
          ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: map.length,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                List<PrivateAssetMeta> items = map.values.toList().elementAt(index);
                String title = map.keys.toList().elementAt(index);
                return Column(
                  children: [
                    SizedBox(height: height* .04,),
                    buildCardItemTitle(title,),
                    Divider(thickness: .75, color: Colors.black,),
                    SizedBox(height: height* .008,),
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
                              SizedBox(height: height* .008,),
                            ],
                          );
                        }
                    ),
                  ],
                );
              },
          ),
        ],
      )
    );
  }

  Widget buildCardItemTitle(titleKey){
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
        SizedBox(width: width* .06),
        SvgPicture.asset(
          'assets/icons/ic_triangle.svg',
          height: width* .025,
          width: width* .025,
        ),
      ],
    );
  }

  _onWillPop(){
    rootScreenController.setSharedData(HoldingsType.PRIVATE);
    rootScreenController.setCurrentScreen(AppMainScreens.HOLDINGS_SCREEN);
  }
}
