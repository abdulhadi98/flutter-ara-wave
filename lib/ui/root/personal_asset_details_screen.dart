import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wave_flutter/di/personal_asset_details_screen_di.dart';
import 'package:wave_flutter/helper/app_colors.dart';
import 'package:wave_flutter/helper/app_fonts.dart';
import 'package:wave_flutter/helper/enums.dart';
import 'package:wave_flutter/helper/routes_helper.dart';
import 'package:wave_flutter/helper/utils.dart';
import 'package:wave_flutter/models/image_model.dart';
import 'package:wave_flutter/models/personal_asset_holding_model.dart';
import 'package:wave_flutter/models/personal_asset_model.dart';
import 'package:wave_flutter/models/personal_asset_type.dart';
import 'package:wave_flutter/services/urls_container.dart';
import 'package:wave_flutter/ui/common_widgets/base_statefull_widget.dart';
import 'package:wave_flutter/ui/common_widgets/card_item_details_screen.dart';
import 'package:wave_flutter/ui/common_widgets/chart_card_item.dart';
import 'package:wave_flutter/ui/common_widgets/home_screen_header.dart';
import 'package:wave_flutter/ui/common_widgets/image_widget.dart';

class PersonalAssetDetailsScreen extends BaseStateFullWidget {
  final PersonalAssetHoldingModel assetModel;
  PersonalAssetDetailsScreen({required this.assetModel});

  @override
  _PersonalAssetDetailsScreenState createState() => _PersonalAssetDetailsScreenState();
}

class _PersonalAssetDetailsScreenState extends BaseStateFullWidgetState<PersonalAssetDetailsScreen> with PersonalAssetDetailsScreenDi{

  @override
  void initState() {
    super.initState();

    initScreenDi();
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
          child: Column(
            children: [
              SizedBox(height: height* 0.02),
              buildHeader(),
              SizedBox(height: height* 0.020),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if(widget.assetModel.personalAssetPhotos?.isNotEmpty??false) buildGalleryList(),
                      if(widget.assetModel.personalAssetPhotos?.isNotEmpty??false) SizedBox(height: height* 0.020),
                      // ChartCardItem(chartType: ChartsType.COLUMN_ROUNDED_CORNER,),
                      // SizedBox(height: height* 0.020),
                      buildExpandableCard(),
                      SizedBox(height: height* 0.020),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget buildScreenContent(){
  //   if(widget.assetModel.type == 'Collectables'){
  //     return Column(
  //       children: [
  //         SizedBox(height: height* 0.02),
  //         buildHeader(),
  //         SizedBox(height: height* 0.020),
  //         Expanded(
  //           child: SingleChildScrollView(
  //             child: Column(
  //               children: [
  //                 buildGalleryList(),
  //                 SizedBox(height: height* 0.020),
  //                 buildUserInvestmentDetailsCard(),
  //                 SizedBox(height: height* 0.020),
  //                 ChartCardItem(chartType: ChartsType.COLUMN_ROUNDED_CORNER,),
  //                 SizedBox(height: height* 0.020),
  //                 buildStatistics5Card(),
  //                 SizedBox(height: height* 0.020),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ],
  //     );
  //   } else {
  //     return Column(
  //       children: [
  //         SizedBox(height: height* 0.02),
  //         buildHeader(),
  //         SizedBox(height: height* 0.020),
  //         Expanded(
  //           child: SingleChildScrollView(
  //             child: Column(
  //               children: [
  //                 buildGalleryList(),
  //                 SizedBox(height: height* 0.020),
  //                 buildUserInvestmentDetailsCard(),
  //                 SizedBox(height: height* 0.020),
  //                 ChartCardItem(chartType: ChartsType.COLUMN_ROUNDED_CORNER,),
  //                 SizedBox(height: height* 0.020),
  //                 buildStatistics1Card(),
  //                 SizedBox(height: height* 0.020),
  //                 ChartCardItem(chartType: ChartsType.DOUGHNUT, chartTitleKey: 'expenses',),
  //                 SizedBox(height: height* 0.020),
  //                 buildStatistics2Card(),
  //                 SizedBox(height: height* 0.020),
  //                 buildStatistics3Card(),
  //                 SizedBox(height: height* 0.020),
  //                 buildStatistics4Card(),
  //                 SizedBox(height: height* 0.020),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ],
  //     );
  //   }
  // }

  Widget buildHeader(){
    return buildHeaderComponents(
      titleWidget: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: width* .04),
          GestureDetector(
              onTap: _onWillPop,
              child: Icon(Icons.arrow_back_ios_rounded, color: AppColors.gray, size: width* .075,)),
          SizedBox(width: width* .06),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  // widget.assetModel.type == 'Collectables' ? widget.assetModel.collection??'':
                  widget.assetModel.title??'',
                  style: TextStyle(
                    fontSize: AppFonts.getMediumFontSize(context),
                    color: Colors.white,
                    height: 1.0,
                  ),
                ),
                // SizedBox(height: height* .01),
                // Text(
                //   widget.assetModel.type == 'Collectables' ? widget.assetModel.title??'':  widget.assetModel.state??'',
                //   style: TextStyle(
                //     fontSize: AppFonts.getXSmallFontSize(context),
                //     color: Colors.white,
                //     height: 1.0,
                //   ),
                // ),
              ],
            ),
          ),
          // if(widget.assetModel.type == 'Collectables') SizedBox(width: width* .04),
          // if(widget.assetModel.type == 'Collectables') Align(
          //   alignment: Alignment.topLeft,
          //   child: Row(
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     children: [
          //       SvgPicture.asset('assets/icons/ic_verified.svg', width: width* .025, height: width* .025),
          //       SizedBox(width: width* .02),
          //       Text(
          //         'NFT',
          //         style: TextStyle(
          //           fontSize: AppFonts.getXSmallFontSize(context),
          //           color: Colors.white,
          //           height: 1.0,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          // if(widget.assetModel.type == 'Collectables') SizedBox(width: width* .02),
        ],
      ),
      height: height,
      width: width,
      context: context,
      appLocal: appLocal,
      logoTitleKey: 'wave',
      isAddProgressExist: true,
      addEditIcon: 'assets/icons/ic_edit.svg',
      addEditTitleKey: 'edit_asset',
      onAddEditClick: () {},
      totalTextKey: /*widget.assetModel.type == 'Collectables' ? 'estimated_asset_market_value' : */'estimated_total_asset_equity',
    );
  }

  Widget buildGalleryList() {
    galleryItem(List<PersonalAssetPhotos> photos, index, itemSize) {
      List<String> urls = widget.assetModel.personalAssetPhotos?.map((e) => '${UrlsContainer.baseUrl}/${e.link}').toList()??[];
      return GestureDetector(
        onTap: () => RoutesHelper.navigateToGalleryScreen(gallery: urls, index: index, context: context),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          child: ImageWidget(url: '${UrlsContainer.baseUrl}/${photos[index].link}', width: itemSize, height: itemSize, fit: BoxFit.cover),
        ),
      );
    }

    return Container(
      height: (width- 2*width*.05 - 2*width*.02)/ 3,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.assetModel.personalAssetPhotos!.length,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          return Row(
            children: [
              galleryItem(widget.assetModel.personalAssetPhotos??[], index, (width- 2*width*.05 - 2*width*.02)/ 3),
              if(index != (widget.assetModel.personalAssetPhotos?.length??0)-1) SizedBox(width: width* .02,)
            ],
          );
        },
      ),
    );
  }

  Widget buildExpandableCard() {
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
                  widget.assetModel.personalAssetType?.name??'',
                  style: TextStyle(
                    fontSize: AppFonts.getSmallFontSize(context),
                    color: AppColors.white,
                    height: 1.0,
                  ),
                ),
              ],
            ),
          ),
          expanded: buildCardWidget(),
          collapsed: SizedBox(),
        ),
      ),
    );
  }

  Widget buildCardWidget() {
    List<PersonalAssetTypeOptionModel>? typeOptions = widget.assetModel.personalAssetType?.personalAssetTypeOptions;
    return Container(
        padding: EdgeInsets.only(bottom: height* .03, left: width* .04, right: width* .04,),
        alignment: Alignment.center,
        color: AppColors.mainColor,
        child: Column(
          children: [
            Divider(thickness: .75, color: Colors.black,),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: typeOptions?.length??0,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                String title = typeOptions![index].name;
                String? value;
                if(typeOptions[index].typeEnum == AddPersonalAssetHoldingTypeOptionType.choose)
                  value = typeOptions[index].userPersonalAssetTypeOptionValue?.personalAssetTypeOptionValues?.value;
                else value = typeOptions[index].userPersonalAssetTypeOptionValue?.value;

                return Column(
                  children: [
                    buildCardItem(
                      title: title,
                      value: value??'',
                      context: context,
                      width: width,
                    ),
                    SizedBox(height: height* .008,),
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
  //             SizedBox(width: width* .025),
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
  //         if(Utils.isExist(widget.assetModel.estMarketValue)) userInvestmentDetailsItem(
  //           'assets/icons/ic_bar_chart.svg',
  //           appLocal.trans('est_market_value'),
  //           '\$ ${widget.assetModel.estMarketValue}',
  //         ),
  //         if(Utils.isExist(widget.assetModel.estMarketValue)) SizedBox(height: height* .008,),
  //
  //         if(Utils.isExist(widget.assetModel.downPayment) && widget.assetModel.type != 'Collectables') userInvestmentDetailsItem(
  //           'assets/icons/ic_percentage.svg',
  //           appLocal.trans('down_payment'),
  //           '\$ ${widget.assetModel.downPayment}',
  //         ),
  //         if(Utils.isExist(widget.assetModel.downPayment) && widget.assetModel.type != 'Collectables') SizedBox(height: height* .008,),
  //
  //         if(Utils.isExist(widget.assetModel.ownership) && widget.assetModel.type == 'Collectables') userInvestmentDetailsItem(
  //           'assets/icons/ic_percentage.svg',
  //           appLocal.trans('ownership'),
  //           '${widget.assetModel.ownership} %',
  //         ),
  //         if(Utils.isExist(widget.assetModel.ownership) && widget.assetModel.type == 'Collectables') SizedBox(height: height* .008,),
  //
  //
  //         if(Utils.isExist(widget.assetModel.purchasePrice)) userInvestmentDetailsItem(
  //           'assets/icons/ic_dollar.svg',
  //           appLocal.trans('purchase_price'),
  //           '\$ ${widget.assetModel.purchasePrice}',
  //         ),
  //         if(Utils.isExist(widget.assetModel.purchasePrice)) SizedBox(height: height* .008,),
  //
  //         if(Utils.isExist(widget.assetModel.acquisitionDate) && widget.assetModel.type != 'Collectables') userInvestmentDetailsItem(
  //           'assets/icons/ic_calendar.svg',
  //           appLocal.trans('acquisition_date'),
  //           '${widget.assetModel.acquisitionDate}',
  //         ),
  //
  //         if(Utils.isExist(widget.assetModel.purchaseDate) && widget.assetModel.type == 'Collectables') userInvestmentDetailsItem(
  //           'assets/icons/ic_calendar.svg',
  //           appLocal.trans('purchase_date'),
  //           '${widget.assetModel.purchaseDate}',
  //         ),
  //       ],
  //     ),
  //   );
  // }
  //
  // Widget buildStatistics1Card(){
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
  //         if(Utils.isExist(widget.assetModel.statistics1?.loanAmount)) buildCardItem(
  //           title: appLocal.trans('loan_amount'),
  //           value: '\$ ${widget.assetModel.statistics1?.loanAmount}',
  //           context: context,
  //           width: width,
  //         ),
  //         if(Utils.isExist(widget.assetModel.statistics1?.loanAmount)) SizedBox(height: height* .008,),
  //
  //         if(Utils.isExist(widget.assetModel.statistics1?.interestRate)) buildCardItem(
  //           title: appLocal.trans('interest_rate'),
  //           value: '${widget.assetModel.statistics1?.interestRate} %',
  //           context: context,
  //           width: width,
  //         ),
  //         if(Utils.isExist(widget.assetModel.statistics1?.interestRate)) SizedBox(height: height* .008,),
  //         if(Utils.isExist(widget.assetModel.statistics1?.amortization)) buildCardItem(
  //           title: '${appLocal.trans('amortization')}',
  //           value: '${widget.assetModel.statistics1?.amortization} Years',
  //           context: context,
  //           width: width,
  //         ),
  //         if(Utils.isExist(widget.assetModel.statistics1?.amortization)) SizedBox(height: height* .008,),
  //         if(Utils.isExist(widget.assetModel.statistics1?.outstandingBalance)) buildCardItem(
  //           title: '${appLocal.trans('outstanding_balance')}',
  //           value: '\$ ${widget.assetModel.statistics1?.outstandingBalance}',
  //           context: context,
  //           width: width,
  //         ),
  //         if(Utils.isExist(widget.assetModel.statistics1?.outstandingBalance)) SizedBox(height: height* .008,),
  //         if(Utils.isExist(widget.assetModel.statistics1?.termContract)) buildCardItem(
  //           title: '${appLocal.trans('term_contract')}',
  //           value: '${widget.assetModel.statistics1?.termContract} Year Fixed',
  //           context: context,
  //           width: width,
  //         ),
  //         if(Utils.isExist(widget.assetModel.statistics1?.termContract)) SizedBox(height: height* .008,),
  //         if(Utils.isExist(widget.assetModel.statistics1?.monthlyPayments)) buildCardItem(
  //           title: '${appLocal.trans('monthly_payments')}',
  //           value: '\$ ${widget.assetModel.statistics1?.monthlyPayments}',
  //           context: context,
  //           width: width,
  //         ),
  //       ],
  //     ),
  //   );
  // }
  //
  // Widget buildStatistics2Card(){
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
  //         if(Utils.isExist(widget.assetModel.statistics2?.propertyClass)) buildCardItem(
  //           title: appLocal.trans('property_class'),
  //           value: '\$ ${widget.assetModel.statistics2?.propertyClass}',
  //           context: context,
  //           width: width,
  //         ),
  //         if(Utils.isExist(widget.assetModel.statistics2?.propertyClass)) SizedBox(height: height* .008,),
  //
  //         if(Utils.isExist(widget.assetModel.statistics2?.buildingSize)) buildCardItem(
  //           title: appLocal.trans('building_size'),
  //           value: '${widget.assetModel.statistics2?.buildingSize} sqtf',
  //           context: context,
  //           width: width,
  //         ),
  //         if(Utils.isExist(widget.assetModel.statistics2?.buildingSize)) SizedBox(height: height* .008,),
  //         if(Utils.isExist(widget.assetModel.statistics2?.lotSize)) buildCardItem(
  //           title: '${appLocal.trans('lot_size')}',
  //           value: '${widget.assetModel.statistics2?.lotSize} sqtf',
  //           context: context,
  //           width: width,
  //         ),
  //         if(Utils.isExist(widget.assetModel.statistics2?.lotSize)) SizedBox(height: height* .008,),
  //         if(Utils.isExist(widget.assetModel.statistics2?.buildingEvaluation)) buildCardItem(
  //           title: '${appLocal.trans('building_evaluation')}',
  //           value: '\$ ${widget.assetModel.statistics2?.buildingEvaluation}',
  //           context: context,
  //           width: width,
  //         ),
  //         if(Utils.isExist(widget.assetModel.statistics2?.buildingEvaluation)) SizedBox(height: height* .008,),
  //         if(Utils.isExist(widget.assetModel.statistics2?.taxAssessedValue)) buildCardItem(
  //           title: '${appLocal.trans('tax_assessed_value')}',
  //           value: '\$ ${widget.assetModel.statistics2?.taxAssessedValue}',
  //           context: context,
  //           width: width,
  //         ),
  //         if(Utils.isExist(widget.assetModel.statistics2?.taxAssessedValue)) SizedBox(height: height* .008,),
  //         if(Utils.isExist(widget.assetModel.statistics2?.annualTaxAmount)) buildCardItem(
  //           title: '${appLocal.trans('annual_tax_amount')}',
  //           value: '\$ ${widget.assetModel.statistics2?.annualTaxAmount}',
  //           context: context,
  //           width: width,
  //         ),
  //         if(Utils.isExist(widget.assetModel.statistics2?.annualTaxAmount)) SizedBox(height: height* .008,),
  //         if(Utils.isExist(widget.assetModel.statistics2?.yearBuilt)) buildCardItem(
  //           title: '${appLocal.trans('year_built')}',
  //           value: '${widget.assetModel.statistics2?.yearBuilt}',
  //           context: context,
  //           width: width,
  //         ),
  //         if(Utils.isExist(widget.assetModel.statistics2?.yearBuilt)) SizedBox(height: height* .008,),
  //         if(Utils.isExist(widget.assetModel.statistics2?.heatingCooling)) buildCardItem(
  //           title: '${appLocal.trans('heating_cooling')}',
  //           value: '${widget.assetModel.statistics2?.heatingCooling}',
  //           context: context,
  //           width: width,
  //         ),
  //         if(Utils.isExist(widget.assetModel.statistics2?.heatingCooling)) SizedBox(height: height* .008,),
  //         if(Utils.isExist(widget.assetModel.statistics2?.interior)) buildCardItem(
  //           title: '${appLocal.trans('interior')}',
  //           value: '${widget.assetModel.statistics2?.interior}',
  //           context: context,
  //           width: width,
  //         ),
  //         if(Utils.isExist(widget.assetModel.statistics2?.interior)) SizedBox(height: height* .008,),
  //         if(Utils.isExist(widget.assetModel.statistics2?.flooring)) buildCardItem(
  //           title: '${appLocal.trans('flooring')}',
  //           value: '${widget.assetModel.statistics2?.flooring}',
  //           context: context,
  //           width: width,
  //         ),
  //       ],
  //     ),
  //   );
  // }
  //
  // Widget buildStatistics3Card(){
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
  //         if(Utils.isExist(widget.assetModel.statistics3?.grossAnnualRentalIncome)) buildCardItem(
  //           title: appLocal.trans('gross_annual_rental_income'),
  //           value: '\$ ${widget.assetModel.statistics3?.grossAnnualRentalIncome} /sqft',
  //           context: context,
  //           width: width,
  //         ),
  //         if(Utils.isExist(widget.assetModel.statistics3?.grossAnnualRentalIncome)) SizedBox(height: height* .008,),
  //
  //         if(Utils.isExist(widget.assetModel.statistics3?.annualRentGrowth)) buildCardItem(
  //           title: appLocal.trans('annual_rent_growth'),
  //           value: '${widget.assetModel.statistics3?.annualRentGrowth} %',
  //           context: context,
  //           width: width,
  //         ),
  //         if(Utils.isExist(widget.assetModel.statistics3?.annualRentGrowth)) SizedBox(height: height* .008,),
  //         if(Utils.isExist(widget.assetModel.statistics3?.propertyExpenses)) buildCardItem(
  //           title: '${appLocal.trans('property_expenses')}',
  //           value: '\$ ${widget.assetModel.statistics3?.propertyExpenses} /sqft',
  //           context: context,
  //           width: width,
  //         ),
  //         if(Utils.isExist(widget.assetModel.statistics3?.propertyExpenses)) SizedBox(height: height* .008,),
  //         if(Utils.isExist(widget.assetModel.statistics3?.generalVacancyRate)) buildCardItem(
  //           title: '${appLocal.trans('general_vacancy_rate')}',
  //           value: '${widget.assetModel.statistics3?.generalVacancyRate} %',
  //           context: context,
  //           width: width,
  //         ),
  //         if(Utils.isExist(widget.assetModel.statistics3?.generalVacancyRate)) SizedBox(height: height* .008,),
  //         if(Utils.isExist(widget.assetModel.statistics3?.expenseReserve)) buildCardItem(
  //           title: '${appLocal.trans('expense_reserve')}',
  //           value: '${widget.assetModel.statistics3?.expenseReserve} %',
  //           context: context,
  //           width: width,
  //         ),
  //         if(Utils.isExist(widget.assetModel.statistics3?.expenseReserve)) SizedBox(height: height* .008,),
  //         if(Utils.isExist(widget.assetModel.statistics3?.managementCommissions)) buildCardItem(
  //           title: '${appLocal.trans('management_commissions')}',
  //           value: '\$${widget.assetModel.statistics3?.managementCommissions} /yr',
  //           context: context,
  //           width: width,
  //         ),
  //         if(Utils.isExist(widget.assetModel.statistics3?.managementCommissions)) SizedBox(height: height* .008,),
  //         if(Utils.isExist(widget.assetModel.statistics3?.annualExpenseGrowth)) buildCardItem(
  //           title: '${appLocal.trans('annual_expense_growth')}',
  //           value: '${widget.assetModel.statistics3?.annualExpenseGrowth} %',
  //           context: context,
  //           width: width,
  //         ),
  //       ],
  //     ),
  //   );
  // }
  //
  // Widget buildStatistics4Card(){
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
  //         if(Utils.isExist(widget.assetModel.statistics4?.capRate)) buildCardItem(
  //           title: appLocal.trans('cap_rate'),
  //           value: '${widget.assetModel.statistics4?.capRate} %',
  //           context: context,
  //           width: width,
  //         ),
  //         if(Utils.isExist(widget.assetModel.statistics4?.capRate)) SizedBox(height: height* .008,),
  //
  //         if(Utils.isExist(widget.assetModel.statistics4?.leveredInternalRateOfReturn)) buildCardItem(
  //           title: appLocal.trans('levered_internal_rate_of_return'),
  //           value: '${widget.assetModel.statistics4?.leveredInternalRateOfReturn} %',
  //           context: context,
  //           width: width,
  //         ),
  //         if(Utils.isExist(widget.assetModel.statistics4?.leveredInternalRateOfReturn)) SizedBox(height: height* .008,),
  //         if(Utils.isExist(widget.assetModel.statistics4?.averagedLeveredAnnualIncome)) buildCardItem(
  //           title: '${appLocal.trans('averaged_levered_annual_income')}',
  //           value: '${widget.assetModel.statistics4?.averagedLeveredAnnualIncome} %',
  //           context: context,
  //           width: width,
  //         ),
  //       ],
  //     ),
  //   );
  // }
  //
  // Widget buildStatistics5Card(){
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
  //         if(Utils.isExist(widget.assetModel.title)) buildCardItem(
  //           title: appLocal.trans('title'),
  //           value: '${widget.assetModel.title}',
  //           context: context,
  //           width: width,
  //         ),
  //         if(Utils.isExist(widget.assetModel.title)) SizedBox(height: height* .008,),
  //
  //         if(Utils.isExist(widget.assetModel.serialNumber)) buildCardItem(
  //           title: appLocal.trans('serial_number'),
  //           value: '${widget.assetModel.serialNumber}',
  //           context: context,
  //           width: width,
  //         ),
  //         if(Utils.isExist(widget.assetModel.serialNumber)) SizedBox(height: height* .008,),
  //         if(Utils.isExist(widget.assetModel.set)) buildCardItem(
  //           title: '${appLocal.trans('set')}',
  //           value: '${widget.assetModel.set}',
  //           context: context,
  //           width: width,
  //         ),
  //         if(Utils.isExist(widget.assetModel.set)) SizedBox(height: height* .008,),
  //         if(Utils.isExist(widget.assetModel.series)) buildCardItem(
  //           title: '${appLocal.trans('series')}',
  //           value: '${widget.assetModel.series}',
  //           context: context,
  //           width: width,
  //         ),
  //       ],
  //     ),
  //   );
  // }

  _onWillPop(){
    rootScreenController.setSharedData(HoldingsType.PERSONAL);
    rootScreenController.setCurrentScreen(AppMainScreens.HOLDINGS_SCREEN);
  }
}
