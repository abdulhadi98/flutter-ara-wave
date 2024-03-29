import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wave_flutter/di/private_asset_setails_screen_di.dart';
import 'package:wave_flutter/helper/app_colors.dart';
import 'package:wave_flutter/helper/app_fonts.dart';
import 'package:wave_flutter/helper/enums.dart';
import 'package:wave_flutter/helper/utils.dart';
import 'package:wave_flutter/models/private_asset_model.dart';
import 'package:wave_flutter/services/data_resource.dart';
import 'package:wave_flutter/ui/common_widgets/add_asset_text_field.dart';
import 'package:wave_flutter/ui/common_widgets/base_statefull_widget.dart';
import 'package:wave_flutter/ui/common_widgets/card_item_details_screen.dart';
import 'package:wave_flutter/ui/common_widgets/chart_card_item.dart';
import 'package:wave_flutter/ui/common_widgets/chart_info_card_item.dart';
import 'package:wave_flutter/ui/common_widgets/error_message_widget.dart';
import 'package:wave_flutter/ui/common_widgets/home_screen_header.dart';
import 'package:http/http.dart' as http;
import 'package:wave_flutter/ui/root/add_assets/custom_drop_down.dart';
import 'package:wave_flutter/ui/root/holdings_screen.dart';
import 'package:wave_flutter/ui/root/home_screen.dart';

import '../../di/public_assset_details_di.dart';
import '../../models/public_asset_graph_model.dart';
import '../../models/public_asset_model.dart';
import '../common_widgets/image_widget.dart';
import '../common_widgets/show_add_asset_dialog.dart';
import '../common_widgets/show_date_picker.dart';
import 'add_assets/add_asset_action_button.dart';
import 'add_assets/add_assets_dialog_text_field.dart';
import 'add_assets/loading_indicator.dart';

class PublicAssetDetailsScreen extends BaseStateFullWidget {
  static String? companyId;
  static String? companyName;

  final PublicAssetModel assetModel;
  PublicAssetDetailsScreen({required this.assetModel});

  @override
  _PublicAssetDetailsScreenState createState() => _PublicAssetDetailsScreenState();
}

class _PublicAssetDetailsScreenState extends BaseStateFullWidgetState<PublicAssetDetailsScreen> with PublicAssetDetailsScreenDi {
  @override
  void initState() {
    super.initState();
    getAssetDetails();
    initScreenDi();
    dinitScreenDi();
    uiController.fetchPublicAssetHistoricalDetails();

    //uiController.fetchResult();
  }

  bool spinner = false;

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
  var stockExchange = '';
  var primaryExchange = '';
  var description = '';
  var name = '';
  DateTime purchasedAt = DateTime(2022);
  // var totalBalance = '';
  bool dialogSpinner = false;
  Future<String> deleteAsset(onUpdateOk) async {
    setState(() {
      dialogSpinner = true;
    });
    String? message;
    try {
      String? apiToken = HomeScreen.apiToken;
      int? assetId = HoldingsScreen.assetId;

      var request;
      //  var response;
      var url = Uri.parse(
        'https://wave.aratech.co/api/public-asset-holding/${HoldingsScreen.assetId}',
      );
      print('///////////' + url.toString() + '//tokennnnnn///' + apiToken! + '//////' + assetId.toString());

      //  response= dio.delete(
      //       'https://wave.aratech.co/api/public-asset-holding/${HoldingsScreen.assetId}',
      //       data: formData);
      http.Response response = await http.delete(
        Uri.parse('https://wave.aratech.co/api/public-asset-holding/${HoldingsScreen.assetId}'),
        body: <String, String>{
          "api_token": apiToken,
        },
      );
      //  response = http.delete(url, body: {'api_token:$apiToken'});

      //  request.body = jsonEncode({"api_token": apiToken});
      //  response = await request.send();
      var x = jsonDecode(response.body);
      print(x);
      String code = x['code'];
      message = x['message'];

      print(code);
      if (code == '200') {
        setState(() {
          dialogSpinner = false;
        });
        Utils.showToast('Asset Deleted Successfully!');
        // uiController.fetchPublicAssetHistoricalDetails();

        onUpdateOk();
        return 'ok';
      } else {
        setState(() {
          dialogSpinner = false;
        });
        Utils.showToast(message!);
        return 'error';
      }
    } catch (e) {
      print(e.toString());

      setState(() {
        dialogSpinner = false;
      });
      Utils.showToast(message!);
      return 'error';
    }
    return 'ok';
  }

  Future<String> updateAsset(onUpdateOk) async {
    setState(() {
      dialogSpinner = true;
    });
    try {
      String? apiToken = HomeScreen.apiToken;
      int? assetId = HoldingsScreen.assetId;

      var request;
      var response;
      var url = Uri.parse(
        'https://wave.aratech.co/api/edit-public-asset-holding',
      );
      print('///////////' + url.toString() + '//tokennnnnn///' + apiToken! + '//////' + assetId.toString());

      request = http.MultipartRequest('POST', url);
      request.fields['api_token'] = apiToken;
      request.fields['asset_holding_id'] = assetId.toString();
      request.fields['public_asset_id'] = PublicAssetDetailsScreen.companyId.toString();
      request.fields['quantity'] = quantityController!.text.replaceAll(RegExp('[^0-9.]'), '');
      request.fields['purchased_at'] = purchasedAt.toString();
      //   request.fields['stock_exchange'] = stockExchangeController!.text;

      request.fields['purchased_price'] = purchasedPriceController!.text.replaceAll(RegExp('[^0-9.]'), '');

      response = await request.send();
      var xx = await http.Response.fromStream(response);
      var x = jsonDecode(xx.body);

      print('///////////////////////////////////////////////////');
      print(x.toString());
      print('///////////////////////////////////////////////////');
      String code = x['code'];
      String msg = x['message'];

      //  Map publicAsset = payload['public_asset'];
      // var id = payload['id'];

      if (code == '200') {
        setState(() {
          dialogSpinner = false;
        });
        Utils.showToast('Asset Updated Successfully!');
        uiController.fetchPublicAssetHistoricalDetails();
        getAssetDetails();
        onUpdateOk();
      } else {
        setState(() {
          dialogSpinner = false;
        });
        Utils.showToast(msg);
        return 'error';
      }
    } catch (e) {
      print(e.toString());

      setState(() {
        dialogSpinner = false;
      });
      Utils.showToast('Apdating Asset Failed, Please Try Again Later.');
      return 'error';
    }
    return 'ok';
  }

  Widget buildPublicAvailableCompanies() {
    return StreamBuilder<DataResource<List<PublicAssetModel>>?>(
      stream: addPublicAssetHoldingBloc.publicAssetsStream,
      builder: (context, assetsSnapshot) {
        switch (assetsSnapshot.data?.status) {
          case Status.LOADING:
            return LoadingIndicator();
          case Status.SUCCESS:
            return CustomDropDownWidget<PublicAssetModel>(
              title: name,
              menuItems: assetsSnapshot.data!.data!,
              onSelected: duiController.onPublicCompanySelected,
            );
          default:
            return Container();
        }
      },
    );
  }

  Map<String, String> editInfoList = {};
  TextEditingController? stockExchangeController;

  TextEditingController? quantityController;
  TextEditingController? purchasedPriceController;

  // TextEditingController stockExchangeontroller = TextEditingController();
  Widget buildNextButton(contextt, onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height * .06,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.mainColor,
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(width * 0.019),
        ),
        child: Stack(
          children: [
            Center(
              child: Text(
                appLocal.trans('submit'),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: AppFonts.getNormalFontSize(context),
                  height: 1.0,
                ),
              ),
            ),
            Positioned(
              top: 0.0,
              right: 48.0,
              bottom: 0.0,
              child: ImageWidget(
                url: 'assets/icons/ic_arrow_next.svg',
                width: width * .029,
                height: width * .029,
                fit: BoxFit.contain,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDeleteButton(contextt, onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height * .029,
        //color: Colors.green,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ImageWidget(
              url: 'assets/icons/delete-icon.svg',
              width: width * .029,
              height: width * .029,
              fit: BoxFit.contain,
              color: Colors.red[300],
            ),
            SizedBox(
              width: width * 0.02,
            ),
            Text(
              appLocal.trans('delete_asset'),
              style: TextStyle(
                color: Colors.red[300],
                fontSize: AppFonts.getNormalFontSize(context),
                fontWeight: FontWeight.w600,
                height: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  dynamic updateAssetDialog() {
    return showAddAssetDialog(
      popupHeight: height / 1.3,
      context: context,
      padding: EdgeInsets.only(
        right: width * .08,
        left: width * .08,
        top: height * .08,
      ),
      dialogContent: StatefulBuilder(builder: (context, setState) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Stack(
            children: [
              Positioned(
                top: width * .075 / 2,
                right: width * .075 / 2,
                left: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.mainColor,
                    borderRadius: BorderRadius.circular(width * 0.029),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: height * .025),
                      Text(
                        appLocal.trans('edit_asset'),
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: AppFonts.getLargeFontSize(context),
                          height: 1.0,
                        ),
                      ),
                      SizedBox(height: height * .020),
                      Container(
                        margin: const EdgeInsets.all(1),
                        padding: EdgeInsets.symmetric(horizontal: width * .08),
                        decoration: BoxDecoration(
                          color: AppColors.black,
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(width * 0.029),
                            bottomLeft: Radius.circular(width * 0.029),
                          ),
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            children: [
                              SizedBox(
                                height: height * .02,
                              ),
                              buildPublicAvailableCompanies(),
                              SizedBox(height: height * .020),
                              AddAssetsDialogTextField(
                                isMoney: false,
                                isNumber: true,
                                controller: quantityController,
                                keyboardType: TextInputType.text,
                                hint: '# ${appLocal.trans('of_shares')}',
                                height: height * .070,
                                onChanged: (val) {},
                              ),
                              SizedBox(height: height * .020),
                              AddAssetsDialogTextField(
                                isMoney: true,
                                isNumber: false,
                                controller: purchasedPriceController,
                                keyboardType: TextInputType.text,
                                hint: appLocal.trans('purchased_price'),
                                height: height * .070,
                                onChanged: (val) {},
                              ),
                              SizedBox(height: height * .020),
                              GestureDetector(
                                onTap: () async {
                                  DateTime? pickedDateTime = await showCustomDatePicker(
                                    initialDate: purchasedAt,
                                    context: context,
                                    locale: appLocal.locale,
                                  );
                                  setState(() {
                                    purchasedAt = pickedDateTime!;
                                  });
                                  print(purchasedAt.toString().substring(0, 10));
                                },
                                child: Container(
                                  height: height * .07,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: AppColors.mainColor,
                                    borderRadius: BorderRadius.circular(width * 0.019),
                                  ),
                                  child: Text(
                                    purchasedAt.toString().substring(0, 10),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: AppFonts.getSmallFontSize(context),
                                      //height: 1.0,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: height * .020),
                              dialogSpinner
                                  ? LoadingIndicator()
                                  : buildNextButton(
                                      context,
                                      () async {
                                        setState(() {
                                          dialogSpinner = true;
                                        });
                                        String code = await updateAsset(() {});
                                        setState(() {
                                          dialogSpinner = false;
                                        });
                                        if (code == 'ok') {
                                          Navigator.pop(context);
                                          // rootScreenController
                                          //     .setSharedData(HoldingsType.PUBLIC);
                                          // rootScreenController.setCurrentScreen(
                                          //     AppMainScreens.HOLDINGS_SCREEN);
                                        }
                                      },
                                    ),
                              SizedBox(height: height * .025),
                              buildDeleteButton(
                                context,
                                () async {
                                  setState(() {
                                    dialogSpinner = true;
                                  });
                                  String code = await deleteAsset(() {});
                                  setState(() {
                                    dialogSpinner = false;
                                  });
                                  if (code == 'ok') {
                                    Navigator.pop(context);
                                    rootScreenController.setSharedData(HoldingsType.PUBLIC);
                                    rootScreenController.setCurrentScreen(AppMainScreens.HOLDINGS_SCREEN);
                                  }
                                },
                              ),
                              SizedBox(height: height * .020),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                right: 0,
                top: 0,
                child: GestureDetector(
                  onTap: () {
                    //    uiController.clearAddAssetInputs();

                    Navigator.pop(context);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.gray, width: .5),
                      shape: BoxShape.circle,
                      color: AppColors.mainColor,
                    ),
                    child: Icon(
                      Icons.close,
                      color: AppColors.gray,
                      size: width * .055,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  void getAssetDetails() async {
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
      'https://wave.aratech.co/api/get-public-asset-holding',
    );
    print('///////////' + url.toString() + '//tokennnnnn///' + apiToken! + '//////' + assetId.toString());

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
    Map publicAsset = payload['public_asset'];
    // var id = payload['id'];
    setState(() {
      quantity = payload['quantity'].toString();
      stockExchange = payload['stock_exchange'].toString();
      stockExchangeController = new TextEditingController(text: stockExchange);
      purchasePrice = payload['purchased_price'].toString();

      quantityController = new TextEditingController(text: quantity);
      purchasedPriceController = new TextEditingController(text: purchasePrice);

      print(quantityController!.text + 'zxzxzxxz');
      purchasedAt = DateTime.parse(payload['purchased_at']);

      totalBalance = payload['netWorth'].toString();
      PublicAssetDetailsScreen.companyId = payload['public_asset_id'].toString();

      profit = payload['profit'].toString(); //check
      profitPercentage = payload['profitPercentage'].toString();
      name = publicAsset['name'].toString(); //change
      primaryExchange = publicAsset['primary_exchange'].toString(); //add
      marketCapitaliztion = publicAsset['market_cap'].toString();
      sharesOutstanding = publicAsset['shares_outstanding'].toString();
      shareClass = publicAsset['share_class'].toString();
      description = publicAsset['description'].toString();

      headQuarterCity = publicAsset['stock_symbol'];

      marketValue = publicAsset['purchase_price'];

      //    rOI = payload['returnOnInvestment'].toString();
      //   assetGrowth = payload['profitPercentage'].toString();
    });

    setState(() {
      spinner = false;
    });
  }

  void getChart() async {
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
      'https://wave.aratech.co/api/get-public-asset-holding',
    );
    print('///////////' + url.toString() + '//tokennnnnn///' + apiToken! + '//////' + assetId.toString());

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
    Map publicAsset = payload['public_asset'];
    // var id = payload['id'];
    setState(() {
      quantity = payload['quantity'].toString();
      stockExchange = payload['stock_exchange'].toString(); //popopo
      totalBalance = payload['netWorth'].toString();
      purchasePrice = payload['purchased_price'].toString();
      profit = payload['profit'].toString(); //check
      profitPercentage = payload['profitPercentage'].toString();
      name = publicAsset['name'].toString(); //change
      primaryExchange = publicAsset['primary_exchange'].toString(); //add
      marketCapitaliztion = publicAsset['market_cap'].toString();
      sharesOutstanding = publicAsset['shares_outstanding'].toString();
      shareClass = publicAsset['share_class'].toString();
      description = publicAsset['description'].toString();

      headQuarterCity = publicAsset['stock_symbol'];

      marketValue = publicAsset['purchase_price'];

      //    rOI = payload['returnOnInvestment'].toString();
      //   assetGrowth = payload['profitPercentage'].toString();
    });

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
        child: spinner
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                padding: EdgeInsets.only(
                  top: mediaQuery.padding.top,
                  right: width * .05,
                  left: width * .05,
                ),
                child: buildScreenContent(),
              ),
      ),
    );
  }

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
                Container(
                  child: StreamBuilder<DataResource<List<PublicAssetGraphModel>>?>(
                    stream: holdingsBloc.publicAssetGraphStream,
                    builder: (context, historicalSnapshot) {
                      if (historicalSnapshot.hasData && historicalSnapshot.data != null) {
                        switch (historicalSnapshot.data!.status) {
                          case Status.LOADING:
                            return Container(
                              height: height * .255,
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          case Status.SUCCESS:
                            return ChartCardItem(
                              chartType: ChartsType.AREA,
                              filter: uiController.chartFilter,
                              historicalDataList: historicalSnapshot.data!.data!,
                              onFilterChanged: (filter) => uiController.fetchPublicAssetHistoricalDetails(filter: filter),
                            );
                          case Status.NO_RESULTS:
                            return ErrorMessageWidget(messageKey: 'no_result_found_message', image: 'assets/images/ic_not_found.png');
                          case Status.FAILURE:
                            return ErrorMessageWidget(messageKey: historicalSnapshot.data?.message ?? '', image: 'assets/images/ic_error.png');

                          default:
                            return Container();
                        }
                      } else {
                        return Container();
                      }
                    },
                  ),
                ),
                // ChartCardItem(chartType: ChartsType.AREA),
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
                      title: appLocal.trans('Market Value'),
                      value: "\$${Utils.getFormattedStrNum(marketValue)}",
                      //   bottomLabel: appLocal.trans('current_share_price'),
                    ),
                    SizedBox(
                      width: width * 0.025,
                    ),
                    ChartInfoCardItem(
                      title: appLocal.trans('Profit'),
                      value: '\$${Utils.getFormattedStrNum(profitPercentage.substring(0, profitPercentage.length - 1))}',
                      //   bottomLabel: widget.assetModel.assetGrowth ?? '312'),
                    )
                  ],
                ),
                // SizedBox(height: height* 0.020),
                // buildUserInvestmentDetailsCard(),
                SizedBox(height: height * 0.020),
                //   buildCardList(asset.assetMetasMap),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.03, vertical: height * 0.03),
                  // height: height / 4,
                  decoration: BoxDecoration(color: AppColors.mainColor, borderRadius: BorderRadius.circular(width * 0.019)),
                  child: Column(
                    children: [
                      rowInfo('Shares Owned', Utils.getFormattedStrNum(quantity)),
                      Divider(
                        color: AppColors.black.withOpacity(0.6),
                        thickness: 1.5,
                        height: 10,
                      ),
                      rowInfo('Total Amount Invested', "\$${Utils.getFormattedStrNum(purchasePrice)}"),
                      Divider(
                        color: AppColors.black.withOpacity(0.6),
                        thickness: 1.5,
                        height: 10,
                      ),
                      rowInfo(
                        'Return On Investment (ROI)',
                        Utils.getFormattedStrNum(profitPercentage.substring(0, profitPercentage.length - 1)) + '%',
                      ),
                      Divider(
                        color: AppColors.black.withOpacity(0.6),
                        thickness: 1.5,
                        height: 10,
                      ),
                      rowInfo('Market Capitalization', '\$ ${Utils.getFormattedStrNum(marketCapitaliztion)}'),
                      Divider(
                        color: AppColors.black.withOpacity(0.6),
                        thickness: 1.5,
                        height: 10,
                      ),
                      rowInfo('Shares Outstanding', Utils.getFormattedStrNum(sharesOutstanding)),
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
                Container(
                  width: width,
                  padding: EdgeInsets.symmetric(horizontal: width * 0.03, vertical: height * 0.03),
                  // height: height / 4,
                  decoration: BoxDecoration(
                    color: AppColors.mainColor,
                    borderRadius: BorderRadius.circular(width * 0.019),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Description',
                        style: TextStyle(
                          fontSize: AppFonts.getMediumFontSize(context),
                          color: Colors.white,
                          height: 1.0,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(
                        height: height * 0.025,
                      ),
                      Text(
                        description,
                        style: TextStyle(
                          wordSpacing: 2,
                          fontSize: AppFonts.getSmallFontSize(context),
                          color: Colors.white,
                          height: 1.6,

                          //fontWeight: FontWeight.w800,
                        ),
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
      padding: EdgeInsets.symmetric(horizontal: width * .005, vertical: height * .01),
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
            child: Container(
              child: Row(
                children: [
                  SizedBox(width: width * .015),
                  Icon(
                    Icons.arrow_back_ios_rounded,
                    color: AppColors.grayXLight,
                    size: width * .075,
                  ),
                  SizedBox(width: width * .02),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontSize: AppFonts.getMediumFontSize(context),
                          color: Colors.white,
                          height: 1.0,
                        ),
                      ),
                      SizedBox(height: height * .01),
                      Row(
                        children: [
                          Text(
                            headQuarterCity,
                            style: TextStyle(
                              fontSize: AppFonts.getXSmallFontSize(context),
                              color: Colors.white,
                              height: 1.0,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: width * 0.013),
                            child: Container(
                              width: width * 0.003,
                              height: height * 0.012,
                              color: AppColors.white,
                            ),
                          ),
                          Text(
                            primaryExchange,
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
                ],
              ),
            ),
          ),
        ],
      ),
      height: height,
      width: width,
      context: context,
      appLocal: appLocal,
      logoTitleKey: 'public',
      isAddProgressExist: true,
      addEditIcon: 'assets/icons/ic_edit.svg',
      addEditTitleKey: 'edit_asset',
      onAddEditClick: () {
        updateAssetDialog();
      },
      totalTextKey: 'estimated_total_asset_equity',
      netWorth: '${Utils.getFormattedStrNum(totalBalance)}', //netWorth from api
      growth: Utils.getFormattedStrNum(profitPercentage.substring(0, profitPercentage.length - 1)) + '%',
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
              borderRadius: BorderRadius.circular(width * 0.019),
            ),
            child: DropdownButton<String>(
              value: yearSnapshot.data,
              isExpanded: false,
              icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.blue),
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
        });
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
          buildExpandableCard(
            title: assetMetasMap.keys.elementAt(index),
            map: assetMetasMap.values.toList()[index],
          ),
          SizedBox(height: height * 0.0125),
        ],
      ),
    );
  } //xxx

  Widget buildExpandableCard({required title, required Map<String, List<PrivateAssetMeta>> map}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(width * 0.019),
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
              borderRadius: BorderRadius.circular(width * 0.019 /*topLeft: Radius.circular(8), topRight: Radius.circular(8),*/),
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

  Widget buildCardWidget({required title, required Map<String, List<PrivateAssetMeta>> map}) {
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
                uiiController.incomeAnalysisYearsStream,
                (newValue) => uiiController.setIncomeAnalysisYears(newValue),
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
                List<PrivateAssetMeta> items = map.values.toList().elementAt(index);
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
    rootScreenController.setSharedData(HoldingsType.PUBLIC);
    rootScreenController.setCurrentScreen(AppMainScreens.HOLDINGS_SCREEN);
  }
}
