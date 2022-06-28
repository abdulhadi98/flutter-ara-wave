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
import 'package:http/http.dart' as http;
import 'package:wave_flutter/ui/root/add_assets/loading_indicator.dart';
import 'package:wave_flutter/ui/root/holdings_screen.dart';
import 'dart:convert';
import '../../models/add_personal_asset_holding_model.dart';
import '../common_widgets/add_asset_text_field.dart';
import '../common_widgets/show_add_asset_dialog.dart';
import 'add_assets/personal/steps/image/add_personal_asset_document_step_widget.dart';
import 'add_assets/personal/steps/text/date_picker_placeholder_widget.dart';
import 'home_screen.dart';

class PersonalAssetDetailsScreen extends BaseStateFullWidget {
  static List<String> photosList = [];
  final PersonalAssetHoldingModel assetModel;
  PersonalAssetDetailsScreen({required this.assetModel});

  @override
  _PersonalAssetDetailsScreenState createState() =>
      _PersonalAssetDetailsScreenState();
}

class _PersonalAssetDetailsScreenState
    extends BaseStateFullWidgetState<PersonalAssetDetailsScreen>
    with PersonalAssetDetailsScreenDi {
  @override
  void initState() {
    super.initState();
    getAssetDetails();
    getAssetDetailsForEdit();

    initScreenDi();
  }

  List<AddPersonalAssetOptionModel> addPersonalAssetOptionList = [];
  void getAssetDetailsForEdit() async {
    String? apiToken = HomeScreen.apiToken;
    int? assetId = HoldingsScreen.assetId;

    var request;
    var response;
    var url = Uri.parse(
      'https://wave.aratech.co/api/get-personal-assets-details-for-edit',
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
    List payload = x['data'];
    print(payload.first);
    payload.forEach((element) {
      if (element['option_value_type'] == 'date')
        setState(() {
          createdAt = element['option_value'];
        });
      addPersonalAssetOptionList.add(AddPersonalAssetOptionModel(
        id: element['option_id'],
        type: element['option_value_type'],
        value: element['option_value'] ?? Null,
        optionName: element['option_name'],
      ));
      print(addPersonalAssetOptionList.last.optionName);
    });
  }

  Widget buildGridView() {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: addPersonalAssetOptionList.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: width * .030,
        mainAxisSpacing: height * .03,
        childAspectRatio: 1.65 / .7,
      ),
      itemBuilder: (context, index) {
        return buildGridItem(addPersonalAssetOptionList[index]);
      },
    );
  }

  Widget buildGridItem(AddPersonalAssetOptionModel option) {
    print(option.optionName! +
        '  id=  ' +
        option.id.toString() +
        option.type.toString() +
        "  " +
        option.value.toString());
    switch (option.type) {
      case 'text':
        return buildTextFieldGridItem(option, TextInputType.text,
            AddPersonalAssetHoldingTypeOptionType.text);

      case 'year':
        return buildTextFieldGridItem(option, TextInputType.number,
            AddPersonalAssetHoldingTypeOptionType.text);

      case 'number':
        return buildTextFieldGridItem(option, TextInputType.number,
            AddPersonalAssetHoldingTypeOptionType.number);

      case 'money':
        return buildTextFieldGridItem(option, TextInputType.number,
            AddPersonalAssetHoldingTypeOptionType.money);

      case 'percentage':
        return buildTextFieldGridItem(option, TextInputType.number,
            AddPersonalAssetHoldingTypeOptionType.percentage);

      case 'date':
        {
          // createdAt = option.value;
          return buildDateGridItemWidget(option);
        }

      default:
        return SizedBox();
    }
  }

  onInputChanged(int optionId, String type, String value, String optionName) {
    print('before update' + addPersonalAssetOptionList.length.toString());

    addPersonalAssetOptionList[addPersonalAssetOptionList.indexWhere(
        (element) => element.id == optionId)] = AddPersonalAssetOptionModel(
      id: optionId,
      type: type,
      value: value,
      optionName: optionName,
    );

    // addPersonalAssetOptionList
    //     .removeWhere((element) => element.id.toString() == optionId.toString());
    // print('after delete' + addPersonalAssetOptionList.length.toString());
    // addPersonalAssetOptionList.add(
    //   AddPersonalAssetOptionModel(
    //     id: optionId,
    //     type: type,
    //     value: value,
    //     optionName: optionName,
    //   ),
    // );
    print('after update' + addPersonalAssetOptionList.length.toString());
    // addPersonalAssetOptionList.add(AddPersonalAssetOptionModel(
    //     id: element['option_id'],
    //     type: element['option_value_type'],
    //     value: element['option_value'],
    //     optionName: element['option_name'],
    //     code: element['code']));
  }

  bool dialogSpinner = false;
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
        'https://wave.aratech.co/api/edit-personal-asset',
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
      List<Map<dynamic, dynamic>> optionsListForApi = [];
      addPersonalAssetOptionList.forEach((element) {
        Map option = {
          "option_id": element.id,
          'option_value_type': element.type,
          'option_value': element.value,
          'option_name': element.optionName
        };
        optionsListForApi.add(option); //okok
      });
      //   print(optionsListForApi);

      request.fields['options'] = json.encode(optionsListForApi);

      // print(url);
      //  getStringOfUrls(photosUrl)! +
      //                         ',' +
      //                         getStringOfUrls(
      //                            PersonalAssetDetailsScreen.photosList )!

      if (getStringOfUrls(PersonalAssetDetailsScreen.photosList)! != '')
        urls = getStringOfUrls(photosUrl)! +
            ',' +
            getStringOfUrls(PersonalAssetDetailsScreen.photosList)!;
      else
        urls = getStringOfUrls(photosUrl)!;
      request.fields['photos'] = urls.isEmpty ? '' : urls;
      print('options: ' + optionsListForApi.toString());
      print('photos: ' + urls);

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
        //getPersonalChartValue();
        getAssetDetails();

        //    getAssetDetailsForEdit();
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
        Uri.parse('https://wave.aratech.co/api/personal-asset/$assetId'),
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

  editImages() {
    return showAddAssetDialog(
      popupHeight: height * 3,
      context: context,
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
                        child: AddPersonalAssetDocumentStepWidget(
                          onFinishedClicked: (photosUrl1) {
                            print('ONONONONONONONONONFinished' +
                                getStringOfUrls(photosUrl1!)! +
                                ',' +
                                getStringOfUrls(
                                    PersonalAssetDetailsScreen.photosList)!);
                            updateAsset(() {});
                            //      getAssetDetails();
                            //    getAssetDetailsForEdit();
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
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

  dynamic updateAssetDialog() {
    return showAddAssetDialog(
      popupHeight: height / 1.3,
      context: context,
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
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            children: [
                              SizedBox(
                                height: height * .02,
                              ),
                              buildGridView(),
                              SizedBox(
                                height: height * .02,
                              ),
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
                                          // Navigator.pop(context);

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
                                        .setSharedData(HoldingsType.PERSONAL);
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

  // var totalBalance = '';
  List<Map<String, dynamic>> detailsInfoList = [];
  List<PersonalAssetPhotos> personalAssetPhotos = [];
  String createdAt = '';
  String urls = '';
  String? getStringOfUrls(List<String> list) {
    String temp = '';
    if (list.isEmpty) return temp;
    for (int i = 0; i < list.length; i++) {
      temp += list[i];

      if (i != list.length - 1) temp += ',';
    }
    return temp;
  }

  List<String> photosUrl = [];

  void getAssetDetails() async {
    PersonalAssetDetailsScreen.photosList.clear();
    photosUrl.clear();

    personalAssetPhotos = [];
    rowInforList.clear();
    setState(() {
      spinner = true;
    });
    String? apiToken = HomeScreen.apiToken;
    int? assetId = HoldingsScreen.assetId;
    var request;
    var response;
    var url = Uri.parse(
      'https://wave.aratech.co/api/get-personal-asset-details',
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
    Map details = payload['details'];
    List photos = payload['personal_asset_photos'];
    type = details['Type'] ?? '12';
    print('xccxcxc' + type);

    photos.forEach((element) {
      var link = element['link'].toString();
      if (link != 'null' && link != '') {
        photosUrl
            .add('images/personal_assets/' + link.split('/').last.toString());
        personalAssetPhotos.add(
          PersonalAssetPhotos(
              id: element['id'],
              createdAt: DateTime.parse(element['created_at']),
              updatedAt: DateTime.parse(element['updated_at']),
              link: 'images/personal_assets/' + link.split('/').last.toString(),
              personalAssetId: element['personal_asset_id']),
        );
      }
      print('images/personal_assets/' + link.split('/').last.toString());
      // .split('/')
      // .last
      // .toString()
      // .substring(0, element['link'].split('/').last.toString().length - 2));
    });
    // print(personalAssetPhotos.first.id.toString() + 'le');
    Map pesonalAssetType = payload['personal_asset_type'];
    headQuarterCity = pesonalAssetType['name'];
    // var id = payload['id'];
    setState(() {
      purchasePrice = payload['purchased_price'].toString();
      //pll
      if (headQuarterCity == 'Real Estate')
        totalBalance = details['Market Value'].toString();
      // else if(headQuarterCity == 'Savings' ||headQuarterCity=='Digital Asset')
      //   totalBalance = details['Market Value'].toString();
      else if (headQuarterCity == 'Digital Asset')
        totalBalance =
            details['Est Market Value'] ?? details['Amount'].toString();
      else if (headQuarterCity == 'Savings')
        totalBalance = details['Account Balance'].toString() == 'null'
            ? details['Balance'].toString()
            : details['Account Balance'].toString();
      else
        totalBalance = details['Estimated Resale Value'].toString() == 'null'
            ? details['Est Resale Value'].toString()
            : details['Estimated Resale Value'].toString();
      created_at =
          DateTime.parse(payload["created_at"]).toString().substring(0, 10);
      //createdAt = created_at;

      if (headQuarterCity != 'Real Estate' ||
          headQuarterCity != 'Digital Asset')
        description = details['Description'].toString() == 'null'
            ? ''
            : details['Description'].toString();
      //print(stockExchange);

      //    rOI = payload['returnOnInvestment'].toString();
      //   assetGrowth = payload['profitPercentage'].toString();
    });

    details.removeWhere((key, value) => (key == 'Estimated Resale Value' ||
        key == 'Purchased Price' ||
        key == 'Description' ||
        key == 'Date of Purchase' ||
        key == 'Est Resale Value'));

    if (headQuarterCity == 'Real Estate') {
      details.forEach((key, value) {
        if (key == 'Loan Amount' ||
            key == 'Down Payment' ||
            key == 'Interest Rate' ||
            key == 'Amortization (Months)' ||
            key == 'Monthly Payment')
          loadRowList
              .add(rowInfo(key, Utils.getFormattedStrNum(value.toString())));
        else if (key == 'Address' ||
            key == 'Year Built' ||
            key == 'Property Class' ||
            key == 'Type')
          propertyRowLis.add(rowInfo(key, value.toString()));
        else if (key == 'Lot Size')
          propertyRowLis
              .add(rowInfo(key, Utils.getFormattedStrNum(value.toString())));
        else {
          value = double.tryParse(value.toString()) ?? value.toString();
          print(value.toString() + '   ' + value.runtimeType.toString());
          if (value.runtimeType == double) {
            rowInforList.add(rowInfo(key, Utils.getFormattedStrNum(value)));
          } else {
            rowInforList.add(rowInfo(key, value));
          }
        }
      });
    } else
      details.forEach((key, value) {
        if (key != 'Year')
          value = double.tryParse(value.toString()) ?? value.toString();
        print(value.toString() + '   ' + value.runtimeType.toString());
        if (value.runtimeType == double) {
          print('dounle');
          rowInforList.add(rowInfo(key, Utils.getFormattedStrNum(value)));
        } else {
          print('nodounle');

          rowInforList.add(rowInfo(key, value.toString()));
        }
      });
    print(details.length);

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
                child: Column(
                  children: [
                    SizedBox(height: height * 0.02),
                    buildHeader(),
                    // MaterialButton(
                    //   onPressed: () {
                    //     showEditOptionsDialog();
                    //   },
                    //   child: Text('qweqweqweqwe'),
                    //   height: 50,
                    //   color: Colors.amber,
                    // ),
                    // MaterialButton(
                    //   onPressed: () {
                    //     // addPersonalAssetOptionList.forEach((element) {
                    //     //   print(element.value);
                    //     // });
                    //     print(getStringOfUrls(photosUrl)! +
                    //         ',' +
                    //         getStringOfUrls(
                    //             PersonalAssetDetailsScreen.photosList)!);
                    //     // print(getStringOfUrls(
                    //     //     PersonalAssetDetailsScreen.photosList));

                    //     // print(addPersonalAssetOptionList);
                    //   },
                    //   child: Text('print list'),
                    //   height: 50,
                    //   color: Colors.amber,
                    // ),
                    SizedBox(height: height * 0.020),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            if (personalAssetPhotos.isNotEmpty)
                              buildGalleryList(),
                            if (personalAssetPhotos.isNotEmpty)
                              SizedBox(height: height * 0.020),
                            // ChartCardItem(chartType: ChartsType.COLUMN_ROUNDED_CORNER,),
                            // SizedBox(height: height* 0.020),
                            // buildExpandableCard(),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.03,
                                  vertical: height * 0.03),
                              // height: height / 4,
                              decoration: BoxDecoration(
                                  color: AppColors.mainColor,
                                  borderRadius: BorderRadius.circular(8)),
                              child: Column(
                                children: [
                                  rowInfo('Purchase Price',
                                      Utils.getFormattedStrNum(purchasePrice)),
                                  rowInfo('Estimated Resale Value',
                                      Utils.getFormattedStrNum(totalBalance)),
                                  rowInfo('Date of Purchase',
                                      createdAt == '' ? created_at : createdAt),
                                ],
                              ),
                            ),
                            SizedBox(height: height * 0.020),
                            Container(
                                width: width,
                                padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.03,
                                    vertical: height * 0.03),
                                // height: height / 4,
                                decoration: BoxDecoration(
                                  color: AppColors.mainColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Details',
                                      style: TextStyle(
                                        fontSize:
                                            AppFonts.getMediumFontSize(context),
                                        color: Colors.white,
                                        height: 1.0,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * 0.035,
                                    ),
                                    Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: rowInforList),
                                  ],
                                )),
                            SizedBox(height: height * 0.020),
                            if (headQuarterCity != 'Real Estate' &&
                                type != 'Cryptocurrency' &&
                                headQuarterCity != 'Savings')
                              Container(
                                width: width,
                                padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.03,
                                    vertical: height * 0.03),
                                // height: height / 4,
                                decoration: BoxDecoration(
                                  color: AppColors.mainColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Description',
                                      style: TextStyle(
                                        fontSize:
                                            AppFonts.getMediumFontSize(context),
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
                                        fontSize:
                                            AppFonts.getSmallFontSize(context),
                                        color: Colors.white,
                                        height: 1.6,

                                        //fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (headQuarterCity != 'Real Estate' &&
                                type != 'Cryptocurrency')
                              SizedBox(height: height * 0.020),

                            if (headQuarterCity == 'Real Estate')
                              Container(
                                width: width,
                                padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.03,
                                    vertical: height * 0.03),
                                // height: height / 4,
                                decoration: BoxDecoration(
                                  color: AppColors.mainColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Loan Metrics',
                                      style: TextStyle(
                                        fontSize:
                                            AppFonts.getMediumFontSize(context),
                                        color: Colors.white,
                                        height: 1.0,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * 0.025,
                                    ),
                                    Column(
                                      children: loadRowList,
                                    )
                                  ],
                                ),
                              ),
                            if (headQuarterCity == 'Real Estate')
                              SizedBox(height: height * 0.020),

                            if (headQuarterCity == 'Real Estate')
                              Container(
                                width: width,
                                padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.03,
                                    vertical: height * 0.03),
                                // height: height / 4,
                                decoration: BoxDecoration(
                                  color: AppColors.mainColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Property Metrics',
                                      style: TextStyle(
                                        fontSize:
                                            AppFonts.getMediumFontSize(context),
                                        color: Colors.white,
                                        height: 1.0,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * 0.025,
                                    ),
                                    Column(
                                      children: propertyRowLis,
                                    )
                                  ],
                                ),
                              ),
                            if (headQuarterCity == 'Real Estate')
                              SizedBox(height: height * 0.020),
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

  Padding rowInfo(leftText, rightText) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: width * .005, vertical: height * .004),
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
            height: 5,
          ),
        ],
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

  Widget buildHeader() {
    return buildHeaderComponents(
      titleWidget: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: width * .025),
          GestureDetector(
              onTap: _onWillPop,
              child: Icon(
                Icons.arrow_back_ios_rounded,
                color: AppColors.gray,
                size: width * .075,
              )),
          SizedBox(width: width * .03),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  // widget.assetModel.type == 'Collectables' ? widget.assetModel.collection??'':
                  widget.assetModel.title ?? '',
                  style: TextStyle(
                    fontSize: AppFonts.getMediumFontSize(context),
                    color: Colors.white,
                    height: 1.0,
                  ),
                ),
                Text(
                  // widget.assetModel.type == 'Collectables' ? widget.assetModel.collection??'':
                  headQuarterCity,
                  style: TextStyle(
                    fontSize: AppFonts.getXSmallFontSize(context),
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
      netWorth: Utils.getFormattedStrNum(totalBalance),
      height: height,
      width: width,
      context: context,
      appLocal: appLocal,
      logoTitleKey: 'personal',
      isAddProgressExist: true,
      addEditIcon: 'assets/icons/ic_edit.svg',
      addEditTitleKey: 'edit_asset',
      onAddEditClick: () {
        showEditOptionsDialog();
        // getAssetDetails();
      },
      totalTextKey: /*widget.assetModel.type == 'Collectables' ? 'estimated_asset_market_value' : */ 'estimated_total_asset_equity',
    );
  }

  galleryItem(List<PersonalAssetPhotos> photos, index, itemSize) {
    List<String> urls = personalAssetPhotos
        .map((e) => '${UrlsContainer.baseUrl}/${e.link}')
        .toList(); //ggg

    return GestureDetector(
      onTap: () {
        print(photos[index].link);
        RoutesHelper.navigateToGalleryScreen(
            gallery: urls, index: index, context: context);
      },
      child: Stack(
        children: [
          Positioned(
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              child: ImageWidget(
                  url: '${UrlsContainer.baseUrl}/${photos[index].link}',
                  width: itemSize,
                  height: itemSize,
                  fit: BoxFit.cover),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            // top: 0,
            child: GestureDetector(
              onTap: () {
                print(photos[index].link! + index.toString());

                print(photosUrl);

                print(photosUrl.length);
                photosUrl.removeWhere((element) {
                  if (element == photos[index].link) {
                    print('found and delete( $element)');
                  }

                  return element == photos[index].link!;
                });

                updateAsset(() {});

                print(photosUrl.length);
              },
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.white, width: .5),
                  shape: BoxShape.circle,
                  color: AppColors.mainColor,
                ),
                child: Icon(
                  Icons.delete_outline_outlined,
                  color: AppColors.gray,
                  size: width * .04,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextFieldGridItem(AddPersonalAssetOptionModel option, type,
      AddPersonalAssetHoldingTypeOptionType optionType) {
    return AddAssetTextFormField(
        initialValue: option.value,

        // controller: c,
        optioType: option.type,
        prefix: option.type == 'money'
            ? '\$'
            : option.type == 'percentage'
                ? '%'
                : '',
        keyboardType: type,
        //  keyboardType: TextInputType.text,
        // key: UniqueKey(),
        hintKey: option.optionName!,
        onChanged: (value) {
          //    print('asdasddasdasdlkjad;jasdlsajdlasdlivulsdvulasvdlus');
          // print(c.text + '11221');
          if (option.type == 'text')
            onInputChanged(
              option.id,
              option.type,
              value,
              option.optionName!,
            );
          else {
            value = value.toString().replaceAll(RegExp('[^0-9.]'), '');
            print(value);
            onInputChanged(
              option.id,
              option.type,
              value,
              option.optionName!,
            );
          }
        });
  }

  Widget buildDateGridItemWidget(AddPersonalAssetOptionModel option) {
    return DatePickerPlaceholderWidget(
      // key: UniqueKey(),
      color: Colors.white,
      hint: createdAt,
      // onDatedPicked: (date) {},

      onDatedPicked: (date) {
        setState(() {
          createdAt = date.toString();
        });
        onInputChanged(
          option.id,
          option.type,
          date.toString(),
          option.optionName!,
        );
        // uiController.onInputChanged(
        //   date,
        //   AddPersonalAssetHoldingTypeOptionType.date,
        //   option.id,
        // );
      },
    );
  }

  List<Widget> rowInforList = [];
  List<Widget> loadRowList = [];
  List<Widget> propertyRowLis = [];
  bool spinner = false;
  var created_at = '';
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
  var type = '';
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

  showEditOptionsDialog() {
    return showAddAssetDialog(
      popupHeight: height / 1.3,
      context: context,
      padding: EdgeInsets.only(
        right: width * .1,
        left: width * .1,
        top: height * .2,
      ),
      dialogContent: Container(
        child: StatefulBuilder(builder: (context, setState) {
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
                          padding:
                              EdgeInsets.symmetric(horizontal: width * .08),
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
                                  // uiHoldingsController
                                  //     .clearAddAssetInputs();
                                  editImages();
                                },
                                child: Container(
                                  height: height * .07,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: AppColors.mainColor,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Text(
                                    appLocal.trans('add_images'),
                                    style: TextStyle(
                                      color: Colors.white,
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
      ),
    );
  }

  Widget buildGalleryList() {
    return Container(
      height: (width - 2 * width * .05 - 2 * width * .02) / 3,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: personalAssetPhotos.length,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          return Row(
            children: [
              galleryItem(personalAssetPhotos, index,
                  (width - 2 * width * .05 - 2 * width * .02) / 3),
              if (index != (personalAssetPhotos.length) - 1)
                SizedBox(
                  width: width * .02,
                )
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
                  widget.assetModel.personalAssetType?.name ?? '',
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
    List<PersonalAssetTypeOptionModel>? typeOptions =
        widget.assetModel.personalAssetType?.personalAssetTypeOptions;
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
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: typeOptions?.length ?? 0,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                String title = typeOptions![index].name;
                String? value;
                if (typeOptions[index].typeEnum ==
                    AddPersonalAssetHoldingTypeOptionType.choose)
                  value = typeOptions[index]
                      .userPersonalAssetTypeOptionValue
                      ?.personalAssetTypeOptionValues
                      ?.value;
                else
                  value = typeOptions[index]
                      .userPersonalAssetTypeOptionValue
                      ?.value;

                return Column(
                  children: [
                    buildCardItem(
                      title: title,
                      value: value ?? '',
                      context: context,
                      width: width,
                    ),
                    SizedBox(
                      height: height * .008,
                    ),
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

  _onWillPop() {
    rootScreenController.setSharedData(HoldingsType.PERSONAL);
    rootScreenController.setCurrentScreen(AppMainScreens.HOLDINGS_SCREEN);
  }
}
