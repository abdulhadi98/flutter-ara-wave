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
import '../common_widgets/image_widget.dart';
import '../common_widgets/show_add_asset_dialog.dart';
import '../common_widgets/show_date_picker.dart';
import 'add_assets/add_assets_dialog_text_field.dart';
import 'add_assets/loading_indicator.dart';
import 'add_assets/price_history/price_history_step_dialog_content.dart';

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
  dynamic assetGrowth = '';
  dynamic salePrice = ''; //market price
  dynamic purchasePrice = '';
  dynamic headQuarterCity = '';
  dynamic profitPercentage = '';
  dynamic marketValue = '';
  dynamic profit = '';

  dynamic quantity = '';

  dynamic rOI = '';
  dynamic totalA = ''; //quantity
  dynamic marketCapitaliztion = '';
  dynamic sharesOutstanding = '';
  dynamic shareClass = '';

  dynamic totalBalance = '';

  dynamic investedCapital = '';

  var country = '';

  var companyName = '';

  @override
  void initState() {
    super.initState();

    initScreenDi();
    getAssetDetails();
    getPersonalChartValue();
    //uiController.fetchResult();
  }

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

      //  response= dio.delete(
      //       'https://wave.aratech.co/api/public-asset-holding/${HoldingsScreen.assetId}',
      //       data: formData);
      http.Response response = await http.delete(
        Uri.parse(
            'https://wave.aratech.co/api/private-asset-manual-entry/$assetId'),
        body: <String, String>{
          "api_token": apiToken!,
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

  var yearOfInvestment = '';
  TextEditingController? stockExchangeController;

  TextEditingController? quantityController;
  TextEditingController? purchasedPriceController;
  TextEditingController? headQuarterCityController;
  TextEditingController? counrtyController;
  TextEditingController? shareClassController;
  TextEditingController? sharesOutstandingController;
  TextEditingController? companyNameController;
  TextEditingController? investedCapitalController;
  TextEditingController? marketValueController;

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
        'https://wave.aratech.co/api/edit-private-manual-entry',
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
      //   request.fields['public_asset_id'] =
      //      PublicAssetDetailsScreen.companyId.toString();
      request.fields['shares_purchased'] =
          quantityController!.text.replaceAll(RegExp('[^0-9.]'), '');
      request.fields['headquarter_city'] = headQuarterCityController!.text;
      request.fields['country'] = counrtyController!.text;
      request.fields['invested_capital'] =
          investedCapitalController!.text.replaceAll(RegExp('[^0-9.]'), '');
      request.fields['share_class'] = shareClassController!.text;
      request.fields['shares_outstanding'] =
          sharesOutstandingController!.text.replaceAll(RegExp('[^0-9.]'), '');
      request.fields['company_name'] = companyNameController!.text;
      request.fields['market_value'] =
          marketValueController!.text.replaceAll(RegExp('[^0-9.]'), '');

      request.fields['year_of_investment'] =
          yearOfInvestment.toString() + '-01-01'; //comeback

      request.fields['purchased_price'] =
          purchasedPriceController!.text.replaceAll(RegExp('[^0-9.]'), '');

      //x   request.fields['country'] =  ;

      response = await request.send();
      var xx = await http.Response.fromStream(response);
      var x = jsonDecode(xx.body);

      print('///////////////////////////////////////////////////');
      print(x.toString());
      print('///////////////////////////////////////////////////');
      String code = x['code'];
      //  Map publicAsset = payload['public_asset'];
      // var id = payload['id'];
      String msg = x['message'];

      if (code == '200') {
        setState(() {
          dialogSpinner = false;
        });
        Utils.showToast('Asset Updated Successfully!');
        //uiController.fetchPublicAssetHistoricalDetails();
        getPersonalChartValue();
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

  Map<String, String> editInfoList = {};

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
          borderRadius: BorderRadius.circular(8.0),
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

  DateTime purchasedAt = DateTime(2022);
  // var totalBalance = '';
  bool dialogSpinner = false;

  dynamic updateAssetDialog() {
    return showAddAssetDialog(
      context: context,
      popupHeight: height / 1.3,
      padding: EdgeInsets.only(
        right: width * .1,
        left: width * .1,
        top: height * .05,
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
                    borderRadius: BorderRadius.circular(12),
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
                            bottomRight: Radius.circular(12),
                            bottomLeft: Radius.circular(12),
                          ),
                        ),
                        height: height / 1.5,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            children: [
                              SizedBox(
                                height: height * .02,
                              ),
                              //   buildPublicAvailableCompanies(),
                              AddAssetsDialogTextField(
                                isMoney: false,
                                isNumber: false,
                                //enabled: widget.initialCompanyName == null,
                                controller: companyNameController,
                                keyboardType: TextInputType.text,
                                hint: appLocal.trans('name_of_company'),
                                height: height * .070,
                                onChanged: (val) {
                                  //    uiController.onCompanyNameTextFieldChanged(val);
                                },
                              ),
                              SizedBox(height: height * .03),
                              AddAssetsDialogTextField(
                                  isMoney: false,
                                  isNumber: false,
                                  controller: headQuarterCityController,
                                  keyboardType: TextInputType.text,
                                  hint: appLocal.trans('headquarter_city'),
                                  height: height * .070,
                                  onChanged: (val) {}
                                  //      uiController.onHeadquarterCityTextFieldChanged,
                                  ),
                              SizedBox(height: height * .03),
                              AddAssetsDialogTextField(
                                isMoney: false,
                                isNumber: false,
                                controller: counrtyController,
                                keyboardType: TextInputType.text,
                                hint: 'Country',
                                height: height * .070,
                                onChanged: (val) {},
                              ),

                              SizedBox(height: height * .03),
                              GestureDetector(
                                onTap: () async => showYearPicker(
                                    initialDate:
                                        DateTime(int.parse(yearOfInvestment)),
                                    context: context,
                                    onDatePicked: (dateTime) {
                                      setState(
                                        () {
                                          yearOfInvestment =
                                              dateTime.year.toString();
                                        },
                                      );
                                    }
                                    // uiController
                                    //     .onInitialInvestmentYearSelected(dateTime),
                                    ),
                                child: Container(
                                  height: height * .07,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: AppColors.mainColor,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Text(
                                    yearOfInvestment.toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                          AppFonts.getSmallFontSize(context),
                                      //height: 1.0,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: height * .010),
                              Divider(
                                color: AppColors.grayLight,
                                //  thickness: 1.5,
                              ),
                              SizedBox(height: height * .010),
                              AddAssetsDialogTextField(
                                isMoney: true,
                                isNumber: false,
                                controller: investedCapitalController,
                                keyboardType: TextInputType.number,
                                hint: appLocal.trans('invested'),
                                height: height * .070,
                                onChanged: (val) {},
                              ),
                              SizedBox(height: height * .02),
                              AddAssetsDialogTextField(
                                isMoney: false,
                                isNumber: true,
                                controller: quantityController,
                                keyboardType: TextInputType.number,
                                hint: '# ${appLocal.trans('shares_purchased')}',
                                height: height * .070,
                                onChanged: (val) {},
                              ),

                              SizedBox(height: height * .02),
                              AddAssetsDialogTextField(
                                isMoney: false,
                                isNumber: false,
                                controller: shareClassController,
                                keyboardType: TextInputType.text,
                                hint: appLocal.trans('share_class'),
                                height: height * .070,
                                onChanged: (val) {},
                              ),
                              SizedBox(height: height * .02),
                              AddAssetsDialogTextField(
                                isMoney: false,
                                isNumber: true,
                                controller: sharesOutstandingController,
                                keyboardType: TextInputType.number,
                                hint: appLocal
                                    .trans('company_shares_outstanding'),
                                height: height * .070,
                                onChanged: (val) {},
                              ),
                              SizedBox(height: height * .02),
                              AddAssetsDialogTextField(
                                isMoney: true,
                                isNumber: false,
                                controller: marketValueController,
                                keyboardType: TextInputType.number,
                                hint: appLocal.trans('current_market_value'),
                                height: height * .070,
                                onChanged: (val) {},
                              ),
                              SizedBox(height: height * .02),
                              AddAssetsDialogTextField(
                                isMoney: true,
                                isNumber: false,
                                controller: purchasedPriceController,
                                keyboardType: TextInputType.number,
                                hint: appLocal.trans('purchased_price'),
                                height: height * .070,
                                onChanged: (val) {},
                              ),
                              SizedBox(height: height * .02),

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
                                    Navigator.pop(context);
                                    rootScreenController
                                        .setSharedData(HoldingsType.PRIVATE);
                                    rootScreenController.setCurrentScreen(
                                        AppMainScreens.HOLDINGS_SCREEN);
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

  bool chartSpinner = false;
  List<ChartData> privateDetailsChart = [];
  List<Map<String, String>> priceHistoryList = [];

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
      yearOfInvestment =
          payload['year_of_investment'].toString().substring(0, 4);
      totalBalance = payload['totalBalance'].toString();
      profitPercentage = payload['profitPercentage'].toString();

      purchasePrice = payload['purchased_price'].toString();
      quantity = payload['shares_purchased'].toString();
      country = payload['country'];
      marketValue = payload['marketValue'].toString();
      investedCapital = payload['invested_capital'].toString();
      rOI = payload['returnOnInvestment'].toString();
      //   assetGrowth = payload['profitPercentage'].toString();
      marketCapitaliztion = payload['marketCapitalization'].toString();
      sharesOutstanding = payload['shares_outstanding'].toString();
      shareClass = payload['share_class'].toString();
      companyName = payload['company_name'];

      //    stockExchangeController = new TextEditingController(text: quantity);
      // quantityController = new TextEditingController(text: quantity);
      purchasedPriceController = new TextEditingController(
          text: Utils.getFormattedStrNum(purchasePrice));
      companyNameController = new TextEditingController(text: companyName);
      headQuarterCityController =
          new TextEditingController(text: headQuarterCity);
      counrtyController = new TextEditingController(text: country);

      //
      investedCapitalController =
          new TextEditingController(text: investedCapital);
      quantityController = new TextEditingController(text: quantity);
      shareClassController = new TextEditingController(text: shareClass);
      sharesOutstandingController =
          new TextEditingController(text: sharesOutstanding);
      marketValueController = new TextEditingController(text: marketValue);
    });

    //getPersonalChartValue();
    setState(() {
      spinner = false;
    });
  }

  Future<String> updatePriceHistory() async {
    setState(() {
      dialogSpinner = true;
    });
    // privateDetailsChart.clear();
    // priceHistoryList.clear();
    try {
      //  dynamic api = _dataStore!.getApiToken();
      // String? api = _dataStore!.userModel!.apiToken;
      // dynamic api = _dataStore!.getApiToken().then((value) => apiToken = value!);
      String? apiToken = HomeScreen.apiToken;
      var request;
      var response;
      var url = Uri.parse(
        'https://wave.aratech.co/api/edit-assets-price-history',
      );
      print('///////////' + url.toString() + '//tokennnnnn///' + apiToken!);

      request = http.MultipartRequest('POST', url);
      request.fields['api_token'] = apiToken;
      request.fields['asset_id'] = HoldingsScreen.assetId.toString();
      request.fields['asset_type'] = 'private-manual';
      print("year_price: " + jsonEncode(priceHistoryList));
      request.fields['year_price'] = jsonEncode(priceHistoryList);

      response = await request.send();
      var xx = await http.Response.fromStream(response);
      var x = jsonDecode(xx.body);

      print('///////////////////////////////////////////////////');
      print(x.toString());
      print('///////////////////////////////////////////////////');
      String code = x['code'];
      //  Map publicAsset = payload['public_asset'];
      // var id = payload['id'];
      String msg = x['message'];

      if (code == '200') {
        setState(() {
          dialogSpinner = false;
        });
        Utils.showToast('Price History Updated Successfully!');
        //uiController.fetchPublicAssetHistoricalDetails();
        getPersonalChartValue();
        //getAssetDetails();
        //  onUpdateOk();
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
      Utils.showToast('Apdating Price History, Please Try Again Later.');
      return 'error';
    }
    setState(() {
      dialogSpinner = false;
    });
    return 'ok';
  }

  void getPersonalChartValue() async {
    setState(() {
      chartSpinner = true;
    });
    privateDetailsChart.clear();
    priceHistoryList.clear();
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
      priceHistoryList.add({
        'year': acquisitionDate.year.toString(),
        'price': growth.toString()
      });

      print('personalAassetTtype = $acquisitionDate');
      print('growth = $growth');
    });
    if (priceHistoryList.isEmpty)
      setState(() {
        isValid = false;
      });
    else
      setState(() {
        isValid = true;
      });
    setState(() {
      chartSpinner = false;
    });
  }

  bool isValid = true;
  Widget buildGridView() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: width * .03,
        mainAxisSpacing: height * .023,
        childAspectRatio: 2.25 / 1,
      ),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: privateDetailsChart.length,
      itemBuilder: (context, index) {
        return AddAssetsDialogTextFormField(
          initialValue: priceHistoryList[index]['price'],
          isMoney: true,
          isNumber: false,
          keyboardType: TextInputType.number,
          hint: priceHistoryList[index]['year'],
          onChanged: (value) {
            priceHistoryList[priceHistoryList.indexWhere((element) =>
                element['year'] == priceHistoryList[index]['year'])] = {
              'year': priceHistoryList[index]['year']!,
              'price': value.replaceAll(RegExp('[^0-9.]'), '')
            };
            print(priceHistoryList[index]);
            //  uiController.onPriceValueTextFieldChanged(value, index);
          },
        );
      },
    );
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
      child: priceHistoryList.isEmpty
          ? Center(
              child: Text(
                'No Price History Added',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: AppFonts.getMediumFontSize(context),
                  //height: 1.0,
                ),
              ),
            )
          : SfCartesianChart(
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
                      rowInfo('Total Amount Invested',
                          "\$${Utils.getFormattedStrNum(purchasePrice)}"),
                      rowInfo(
                        'Return On Investment (ROI)',
                        Utils.getFormattedStrNum(profitPercentage.substring(
                                0, profitPercentage.length - 1)) +
                            '%',
                      ),
                      rowInfo('Market Capitalization',
                          '\$ ${Utils.getFormattedStrNum(marketCapitaliztion)}'),
                      rowInfo('Shares Outstanding',
                          Utils.getFormattedStrNum(sharesOutstanding)),
                      rowInfo('Shares Class', shareClass),
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
          horizontal: width * .005, vertical: height * .008),
      child: Column(
        children: [
          Row(
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
          Divider(
            color: AppColors.black.withOpacity(0.6),
            thickness: 1.5,
            height: 8,
          ),
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
                      companyName,
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
      onAddEditClick: () {
        //updateAssetDialog();
        showEditOptionsDialog();
      },
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

  showEditOptionsDialog() {
    return showAddAssetDialog(
      context: context,
      popupHeight: height / 1.3,
      padding: EdgeInsets.only(
        right: width * .1,
        left: width * .1,
        top: height * .2,
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
                    borderRadius: BorderRadius.circular(12),
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
                            bottomRight: Radius.circular(12),
                            bottomLeft: Radius.circular(12),
                          ),
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: height * .02,
                            ),
                            GestureDetector(
                              onTap: () {
                                // uiHoldingsController
                                //     .clearAddAssetInputs();
                                updateAssetDialog();
                              },
                              child: Container(
                                height: height * .07,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: AppColors.mainColor,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Text(
                                  appLocal.trans('edit_asset_info'),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize:
                                        AppFonts.getMediumFontSize(context),
                                    height: 1.0,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: height * .02,
                            ),
                            GestureDetector(
                              onTap: () {
                                if (isValid)
                                  buildPriceHistoryComponents(); //backkk
                                else
                                  Utils.showToast('No Price History Added');
                              },
                              child: Container(
                                height: height * .07,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: AppColors.mainColor,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Text(
                                  appLocal.trans('price_history'),
                                  style: TextStyle(
                                    color: isValid
                                        ? Colors.white
                                        : Colors.white.withOpacity(.25),
                                    fontSize:
                                        AppFonts.getMediumFontSize(context),
                                    height: 1.0,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: height * .020),
                          ],
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

  dynamic buildPriceHistoryComponents() {
    return showAddAssetDialog(
      context: context,
      popupHeight: height / 1.3,
      padding: EdgeInsets.only(
        right: width * .1,
        left: width * .1,
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
                    borderRadius: BorderRadius.circular(12),
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
                            bottomRight: Radius.circular(12),
                            bottomLeft: Radius.circular(12),
                          ),
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            children: [
                              SizedBox(
                                height: height * 0.02,
                              ),
                              buildGridView(),
                              SizedBox(
                                height: height * 0.03,
                              ),
                              dialogSpinner
                                  ? LoadingIndicator()
                                  : buildNextButton(
                                      context,
                                      () async {
                                        setState(() {
                                          dialogSpinner = true;
                                        });
                                        String code =
                                            await updatePriceHistory();
                                        setState(() {
                                          dialogSpinner = false;
                                        });
                                        if (code == 'ok') {
                                          Navigator.pop(context);
                                          // Navigator.pop(context);

                                          // rootScreenController
                                          //     .setSharedData(HoldingsType.PUBLIC);
                                          // rootScreenController.setCurrentScreen(
                                          //     AppMainScreens.HOLDINGS_SCREEN);
                                        }
                                      },
                                    ),
                              SizedBox(
                                height: height * 0.025,
                              ),
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

  _onWillPop() {
    rootScreenController.setSharedData(HoldingsType.PRIVATE);
    rootScreenController.setCurrentScreen(AppMainScreens.HOLDINGS_SCREEN);
  }
}
