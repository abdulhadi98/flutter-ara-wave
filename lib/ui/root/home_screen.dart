import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:wave_flutter/di/home_screen_di.dart';
import 'package:wave_flutter/helper/app_colors.dart';
import 'package:wave_flutter/helper/app_fonts.dart';
import 'package:wave_flutter/helper/enums.dart';
import 'package:wave_flutter/helper/routes_helper.dart';
import 'package:wave_flutter/helper/utils.dart';
import 'package:wave_flutter/main.dart';
import 'package:wave_flutter/models/news_model.dart';
import 'package:wave_flutter/models/top_performing_gainers_loosers_model.dart';
import 'package:wave_flutter/models/user_model.dart';
import 'package:wave_flutter/models/user_portfolio_financials.dart';
import 'package:wave_flutter/services/data_resource.dart';
import 'package:wave_flutter/services/urls_container.dart';
import 'package:wave_flutter/storage/data_store.dart';
import 'package:wave_flutter/ui/common_widgets/base_statefull_widget.dart';
import 'package:wave_flutter/ui/common_widgets/image_widget.dart';
import 'package:wave_flutter/ui/common_widgets/show_add_asset_dialog.dart';
import 'package:wave_flutter/ui/intro/splash_screen.dart';
import 'package:wave_flutter/ui/news/news_item.dart';
import 'package:wave_flutter/ui/root/news_screen.dart';
import 'package:wave_flutter/ui/controllers/holdings_screen_controller.dart';
import 'package:wave_flutter/ui/root/holdings_screen.dart';

import '../../bloc/holdings_screen_bloc.dart';
import '../../helper/app_constant.dart';
import '../auth/login_screen.dart';
import '../common_widgets/chart_card_item.dart';
import 'add_assets/personal/dialog_content/add_personal_asset_dialog_content.dart';
import 'add_assets/private/add_private_asset_dialog_content.dart';
import 'add_assets/public/add_public_asset_holding_dialog_content.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends BaseStateFullWidget {
  static String? apiToken;
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends BaseStateFullWidgetState<HomeScreen> with HomeScreenDi {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DataStore? _dataStore = DataStore();

  @override
  void initState() {
    super.initState();

    initScreenDi();

    homeScreenBloc.fetchMe();
    homeScreenBloc.fetchUserPortfolioFinancials();
    homeScreenBloc.fetchTopPerformingGainersLoosersAssets();
    homeScreenBloc.fetchNewsFromXml();
    _dataStore!.getApiToken();
    Future(() {
      checkUser();
    });
  }

  // var response = await _apiProvider.getUser(token: currentUser?.apiToken);
  // deleteAccount() async {
  //   var request;
  //   var response;
  //   var url = Uri.parse(
  //     'https://wave.aratech.co/api/remove-account',
  //   );
  //   //print('///////////' + url.toString() + '//tokennnnnn///' + apiToken!);
  //   UserModel? dataS = await GetIt.I<DataStore>().getUser();
  //   var apiToken = dataS!.apiToken;

  //   print(apiToken);

  //   request = http.MultipartRequest('POST', url);
  //   request.fields['api_token'] = apiToken;
  //   response = await request.send();
  //   var xx = await http.Response.fromStream(response);
  //   var x = jsonDecode(xx.body);
  //   String code = x['code'].toString();
  //   // String msg = x[''];
  //   if (code == '404') {
  //     await GetIt.instance<DataStore>().deleteCurrentUserData();
  //     Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => SplashScreen()), (Route<dynamic> route) => false);
  //   }
  // }

  deleteAccount() async {
    dynamic response;
    UserModel? dataS = await GetIt.I<DataStore>().getUser();
    var apiToken = dataS!.apiToken;

    print(apiToken);

    // setStatus(Status.LOADING);
    try {
      response = await http.delete(
        Uri.parse(
          'https://wave.aratech.co/api/remove-account',
        ),
        body: {'api_token': apiToken},
      );
      //   print(";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;" + returnsOrderId.toString());

      dynamic body = jsonDecode(response.body);
      print(body);

      String code = body['code'].toString();
      if (code == '200') {
        await GetIt.instance<DataStore>().deleteCurrentUserData();
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => SplashScreen()), (Route<dynamic> route) => false);
      } else
        Navigator.pop(context);
      String message = body['message'];
      print(code);

      // setStatus(Status.DATA);
      return code;
    } catch (e) {
      print(e);
      // setStatus(Status.ERROR);
      return 'error';
    }
  }

  showDeleteDialog() {
    showAddAssetDialog(
        popupHeight: height / 1.3,
        context: context,
        padding: EdgeInsets.only(
          right: width * .1,
          left: width * .1,
          top: height * .05,
        ),
        dialogContent: Stack(
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
                      appLocal.trans('are_you_sure'),
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
                              height: height * .05,
                            ),
                            Text(
                              appLocal.trans('remove_account_msg'),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                letterSpacing: 1,
                                height: 1.5,
                                fontSize: AppFonts.getLargeFontSize(context),
                                color: AppColors.white,
                              ),
                            ),
                            SizedBox(
                              height: height * .02,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(
                                  height: height * .02,
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    await deleteAccount();
                                  },
                                  child: Container(
                                    height: height * .07,
                                    width: width * .25,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: AppColors.mainColor,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Text(
                                      "Yes",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: AppFonts.getMediumFontSize(context),
                                        height: 1.0,
                                        //  decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: width * .02,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    height: height * .07,
                                    width: width * .25,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: AppColors.mainColor,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Text(
                                      "No",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: AppFonts.getMediumFontSize(context),
                                        height: 1.0,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: height * .13,
                                ),
                              ],
                            ),
                          ],
                        )),
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
                  Navigator.of(context).pop();
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
        )
        // TODO:
        );
  }

  Future<String> deleteAsset(onUpdateOk) async {
    setState(() {
      spinner = true;
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
        Uri.parse('https://wave.aratech.co/api/remove-account'),
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
          spinner = false;
        });
        Utils.showToast('Account Deleted Successfully!');
        // uiController.fetchPublicAssetHistoricalDetails();

        onUpdateOk();
        return 'ok';
      } else {
        setState(() {
          spinner = false;
        });
        Utils.showToast(message!);
        return 'error';
      }
    } catch (e) {
      print(e.toString());

      setState(() {
        spinner = false;
      });
      Utils.showToast(message!);
      return 'error';
    }
    return 'ok';
  }

  bool spinner = false;
  checkUser() async {
    var request;
    var response;
    var url = Uri.parse(
      'https://wave.aratech.co/api/get-user',
    );
    //print('///////////' + url.toString() + '//tokennnnnn///' + apiToken!);
    UserModel? dataS = await GetIt.I<DataStore>().getUser();
    var apiToken = dataS!.apiToken;

    print(apiToken);

    request = http.MultipartRequest('POST', url);
    request.fields['api_token'] = apiToken;
    response = await request.send();
    var xx = await http.Response.fromStream(response);
    var x = jsonDecode(xx.body);
    String code = x['code'].toString();
    // String msg = x[''];
    if (code == '404') {
      await GetIt.instance<DataStore>().deleteCurrentUserData();
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => SplashScreen()), (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          top: mediaQuery.padding.top,
          right: width * .05,
          left: width * .05,
        ),
        child: Column(
          children: [
            // MaterialButton(
            //   onPressed: () {
            //     homeScreenBloc.fetchNewsFromXml();
            //   },
            //   child: Text('aaaaaaaa'),
            //   height: height / 4,
            //   color: Colors.red,
            // ),
            SizedBox(height: height * 0.02),
            buildHeaderComponents(),
            SizedBox(height: height * 0.020),
            buildGridButtons(),
            buildTopPerformingGainersLoosersResult(),
            // SizedBox(height: height* 0.060),
            // buildGainersLosersResult(),
            buildTopNewsResult(),
            SizedBox(height: height * 0.060),
          ],
        ),
      ),
      drawer: buildDrawerContent(),
    );
  }

  Widget buildUserProfileImage() {
    return Container(
      width: width * .09,
      height: width * .09,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.white,
        shape: BoxShape.circle,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(width * .086),
        child: Utils.buildImage(
          url: 'assets/icons/placeholder.png', //TODO
          width: width * .086,
          height: width * .086,

          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget buildUserName() {
    return Text(
      '${homeScreenBloc.loggedUser?.firstName ?? ''} ${homeScreenBloc.loggedUser?.lastName ?? ''}',
      style: TextStyle(
        fontSize: AppFonts.getMediumFontSize(context),
        color: Colors.white,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget buildHeaderComponents() {
    return StreamBuilder<DataResource<UserPortfolioFinancials>?>(
        stream: homeScreenBloc.userPortfolioFinancialsControllerStream,
        builder: (context, userPortfolioFinancialsSnapshot) {
          return Column(
            children: [
              IntrinsicHeight(
                child: Container(
                  height: height * 0.079,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: height * 0.02, horizontal: width * .03),
                          decoration: BoxDecoration(
                            color: AppColors.mainColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () => _scaffoldKey.currentState?.openDrawer(),
                                child: ClipRRect(
                                  // borderRadius:
                                  //     BorderRadius.circular(width * .08),
                                  child: Image.asset(
                                    'assets/icons/placeholder.png', //TODO
                                    width: width * .08,
                                    height: width * .08,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: width * .05,
                              ),
                              buildUserName(),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: width * .015),
                      Container(
                        width: width * .26,
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(vertical: height * 0.02, horizontal: width * .025),
                        decoration: BoxDecoration(
                          color: AppColors.mainColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Utils.buildImage(
                          url: 'assets/images/logo.png',
                          width: width * .1,
                          height: width * .1,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: width * .015,
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(top: height * 0.02, bottom: height * 0.02, left: width * .033, right: width * .023),
                decoration: BoxDecoration(
                  color: AppColors.mainColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Padding(
                    //   padding: EdgeInsets.symmetric(horizontal: width* .03),
                    //   child:  SvgPicture.asset(
                    //     'assets/icons/ic_up_arrow.svg',
                    //     width: width* .04,
                    //     height: width* .04,
                    //     fit: BoxFit.cover,
                    //   ),
                    // ),
                    // SizedBox(width: width* .05),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          //  top: height * 0.02,
                          left: width * .017,
                          //    right: width * .01,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                userPortfolioFinancialsSnapshot.data?.data?.formattedNetWorth == null
                                    ? SizedBox()
                                    : userPortfolioFinancialsSnapshot.data!.data!.formattedProfitPercentage.contains('+') ||
                                            (!userPortfolioFinancialsSnapshot.data!.data!.formattedProfitPercentage.contains('+') &&
                                                !userPortfolioFinancialsSnapshot.data!.data!.formattedProfitPercentage.contains('-'))
                                        ? Icon(
                                            Icons.keyboard_double_arrow_up,
                                            color: AppColors.blue,
                                            size: width * .07,
                                          )
                                        : Icon(
                                            Icons.keyboard_double_arrow_down,
                                            color: Colors.red,
                                            size: width * .07,
                                          ),
                                Padding(
                                  padding: EdgeInsets.only(left: width * 0.007),
                                  child: Text(
                                    '${userPortfolioFinancialsSnapshot.data?.data?.formattedNetWorth ?? 0.0}',
                                    style: TextStyle(
                                      fontSize: AppFonts.getXXLargeFontSize(context),
                                      color: Colors.white,
                                      height: 1.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: height * .015),
                            Padding(
                              padding: EdgeInsets.only(left: width * 0.02),
                              child: Text(
                                'Total NET Balance in USD',
                                style: TextStyle(
                                  fontSize: AppFonts.getSmallFontSize(context),
                                  color: Colors.white.withOpacity(.8),
                                  height: 1.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: width * .06),
                    Padding(
                      padding: EdgeInsets.only(
                        //  top: height * 0.02,

                        right: width * .01,
                      ),
                      child: Text(
                        '${userPortfolioFinancialsSnapshot.data?.data?.formattedProfitPercentage ?? 0.0}',
                        style: TextStyle(
                          fontSize: AppFonts.getMediumFontSize(context),
                          color: AppColors.blue,
                          height: 1.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }

  Widget buildGridButtons() {
    buttonItem(titleKey, {String? image, onClick}) {
      return GestureDetector(
        onTap: onClick,
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: height * 0.025,
          ),
          decoration: BoxDecoration(
            color: AppColors.mainColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                appLocal.trans(titleKey),
                style: TextStyle(
                  fontSize: AppFonts.getMediumFontSize(context),
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  height: 1.0,
                ),
              ),
              SizedBox(
                width: width * .06,
              ),
              if (image != null)
                SvgPicture.asset(
                  image,
                  width: width * .04,
                  height: width * .04,
                  fit: BoxFit.contain,
                ),
              if (image == null)
                Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(color: AppColors.blue, shape: BoxShape.circle),
                  child: Text(
                    Utils.getFormattedCount(12),
                    style: TextStyle(
                      fontSize: AppFonts.getXSmallFontSize(context),
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: buttonItem('my_portfolio', image: 'assets/icons/ic_pie_chart.svg', onClick: () => rootScreenController.setCurrentScreen(AppMainScreens.MY_PORTFOLIO_SCREEN)),
            ),
            SizedBox(
              width: width * .035,
            ),
            Expanded(
              child: buttonItem('new_assets', image: 'assets/icons/add_asset_icon.svg', onClick: () {
                print('HoldingsScreen.typeId = -4');
                HoldingsScreen.typeId = -4;
                showAddAssetDialog(
                    popupHeight: height / 1.3,
                    context: context,
                    padding: EdgeInsets.only(
                      right: width * .1,
                      left: width * .1,
                      top: height * .05,
                    ),
                    dialogContent: Stack(
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
                                  appLocal.trans('new_asset'),
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
                                            uiHoldingsController.clearAddAssetInputs();

                                            showAddAssetDialog(
                                                popupHeight: height / 1.3,
                                                context: context,
                                                padding: EdgeInsets.only(
                                                  right: width * .1,
                                                  left: width * .1,
                                                  top: height * .05,
                                                ),
                                                dialogContent: AddPrivateAssetDialogContent(
                                                  onAssetAdded: () {
                                                    HoldingsScreen.typeId = -4;
                                                    Navigator.pop(context);
                                                  },
                                                ));
                                          },
                                          child: Container(
                                            height: height * .07,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: AppColors.mainColor,
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                            child: Text(
                                              appLocal.trans('private_asset'),
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: AppFonts.getMediumFontSize(context),
                                                height: 1.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: height * .02,
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            showAddAssetDialog(
                                                context: context,
                                                popupHeight: height / 1.3,
                                                padding: EdgeInsets.only(
                                                  right: width * .1,
                                                  left: width * .1,
                                                  top: height * .05,
                                                ),
                                                dialogContent: AddPublicAssetHoldingDialogContent(
                                                  onAssetAdded: () {
                                                    print('qweqw');
                                                    Navigator.pop(context);
                                                  },
                                                ));
                                          },
                                          child: Container(
                                            height: height * .07,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: AppColors.mainColor,
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                            child: Text(
                                              appLocal.trans('public_asset'),
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: AppFonts.getMediumFontSize(context),
                                                height: 1.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: height * .02,
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            showAddAssetDialog(
                                                popupHeight: height / 1.3,
                                                context: context,
                                                padding: EdgeInsets.only(
                                                  right: width * .1,
                                                  left: width * .1,
                                                  top: height * .05,
                                                ),
                                                dialogContent: AddPersonalAssetDialogContent(
                                                  onAssetAdded: () {
                                                    Navigator.pop(context);

                                                    print('qweqw');
                                                  },
                                                ));
                                          },
                                          child: Container(
                                            height: height * .07,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: AppColors.mainColor,
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                            child: Text(
                                              appLocal.trans('personal_asset'),
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: AppFonts.getMediumFontSize(context),
                                                height: 1.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: height * .02,
                                        ),
                                      ],
                                    )),
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
                              Navigator.of(context).pop();
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
                    )
                    // AddPublicAssetHoldingDialogContent(
                    //   onAssetAdded: () {
                    //     print('qweqw');
                    //   },
                    // )
                    // Container(
                    //     child: Column(
                    //   children: [
                    //     SizedBox(height: height * .03),
                    //     Container(
                    //       alignment: Alignment.center,
                    //       padding: EdgeInsets.symmetric(vertical: height * .020),
                    //       decoration: BoxDecoration(
                    //         color: AppColors.mainColor,
                    //         borderRadius: BorderRadius.circular(8.0),
                    //       ),
                    //       child: Text(
                    //         appLocal.trans('choose_asset_type'),
                    //         style: TextStyle(
                    //           color: AppColors.white,
                    //           fontSize: AppFonts.getNormalFontSize(context),
                    //           height: 1.0,
                    //         ),
                    //       ),
                    //     ),
                    //     SizedBox(height: height * .02),
                    //     Container(
                    //       alignment: Alignment.center,
                    //       padding: EdgeInsets.symmetric(vertical: height * .020),
                    //       decoration: BoxDecoration(
                    //         color: AppColors.mainColor,
                    //         borderRadius: BorderRadius.circular(8.0),
                    //       ),
                    //       child: MaterialButton(
                    //         onPressed: () {

                    //           /////
                    //           ///////
                    //           ////////
                    //           ///////
                    //           //////
                    //         },
                    //         color: AppColors.gray,
                    //         child: Text(
                    //           'Public',
                    //           style: TextStyle(color: AppColors.blue),
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // )), // TODO:
                    );
              }),
            ),
          ],
        ),
        SizedBox(
          height: width * .035,
        ),
        buttonItem('news_update', image: 'assets/icons/ic_news.svg', onClick: () => rootScreenController.setCurrentScreen(AppMainScreens.NEWS_SCREEN)),
      ],
    );

    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: width * .035,
      mainAxisSpacing: width * .035,
      shrinkWrap: true,
      childAspectRatio: 2.5 / 1,
      physics: NeverScrollableScrollPhysics(),
      children: [
        buttonItem('my_portfolio', image: 'assets/icons/ic_pie_chart.svg', onClick: () => rootScreenController.setCurrentScreen(AppMainScreens.MY_PORTFOLIO_SCREEN)),
        buttonItem('new_assets', image: 'assets/icons/ic_add.svg'),
        buttonItem('news_update', image: 'assets/icons/ic_news.svg', onClick: () => rootScreenController.setCurrentScreen(AppMainScreens.NEWS_SCREEN)),
        // buttonItem('notifications', ),
      ],
    );
  }

  Widget buildTopPerformingGainersLoosersResult() {
    return StreamBuilder<DataResource<TopPerformingGainersLoosersModel>?>(
        stream: homeScreenBloc.topPerformingGainersLoosersStream,
        builder: (context, topPerformingGainersLoosersSnapshot) {
          if (topPerformingGainersLoosersSnapshot.hasData && topPerformingGainersLoosersSnapshot.data != null) {
            switch (topPerformingGainersLoosersSnapshot.data!.status) {
              // case Status.LOADING:
              //   return buildTopPerformingAssetsList(isLoading: true);
              case Status.SUCCESS:
                return Column(
                  children: [
                    topPerformingGainersLoosersSnapshot.data!.data!.topPerforming.isNotEmpty
                        ? Column(
                            children: [
                              SizedBox(height: height * 0.03),
                              buildSectionTitle('top_performing_assets'),
                              SizedBox(height: height * .025),
                              buildAssetList(
                                assets: topPerformingGainersLoosersSnapshot.data!.data!.topPerforming,
                                isGainers: false,
                              )
                            ],
                          )
                        : Container(),
                    SizedBox(height: height * 0.030),
                    topPerformingGainersLoosersSnapshot.data!.data!.gainersLoosers.isNotEmpty
                        ? Column(
                            children: [
                              buildSectionTitle('gainers_losers'),
                              SizedBox(height: height * .025),
                              buildAssetList(assets: topPerformingGainersLoosersSnapshot.data!.data!.gainersLoosers, isGainers: true),
                              SizedBox(height: height * 0.025),
                            ],
                          )
                        : Container(),
                  ],
                );
              // case Status.NO_MORE_RESULTS:
              //   return buildResultList(items: coursesSnapshot.data.data);
              // case Status.NO_RESULTS:
              //   return ErrorMessageWidget(messageKey: 'no_result_found_message', image: 'assets/images/ic_not_found.png');
              // case Status.FAILURE:
              //   return ErrorMessageWidget(messageKey: coursesSnapshot.data.message, image: 'assets/images/ic_error.png');

              default:
                return Container();
            }
          } else {
            return Container();
          }
        });
  }

  Widget buildAssetList({required List<GainersLooser> assets, isGainers}) {
    gainerLooserItem(GainersLooser asset) {
      return Container(
        width: width * .37,
        padding: EdgeInsets.symmetric(horizontal: width * .01),
        decoration: BoxDecoration(
          color: AppColors.mainColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //Text(asset.type!),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (!isGainers)
                  ImageWidget(
                    url: asset.type == 'public'
                        ? '${UrlsContainer.baseUrl}/${UrlsContainer.imagesUrl}/public_assets/${asset.icon}'
                        : asset.type == 'personal'
                            ? '${UrlsContainer.baseUrl}/${UrlsContainer.imagesUrl}/personal_assets/${asset.icon}'
                            : '${UrlsContainer.baseUrl}/${UrlsContainer.imagesUrl}/private_assets/${asset.icon}',
                    width: width * .12,
                    height: width * .12,
                  ),
                if (isGainers)
                  Text(
                    asset.title.length > 5 ? asset.title.substring(0, 5) + '..' : asset.title,
                    style: TextStyle(
                      fontSize: AppFonts.getLargeFontSize(context),
                      color: AppColors.white,
                    ),
                  ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FittedBox(
                      child: Text(
                        asset.growthTitle,
                        style: TextStyle(
                          fontSize: AppFonts.getMediumFontSize(context),
                          color: asset.growth < 0 ? Colors.redAccent : AppColors.blue,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: height * 0.015),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 1,
                  child: Text(
                    asset.title,
                    style: TextStyle(
                      fontSize: AppFonts.getSmallFontSize(context),
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 4),
                Flexible(
                  flex: 1,
                  child: FittedBox(
                    child: Text(
                      // '\$${asset.purchasePrice}',
                      '\$${Utils.getFormattedNum(double.parse(asset.purchasePrice ?? '0.0'))}',
                      style: TextStyle(
                        fontSize: AppFonts.getSmallFontSize(context),
                        color: AppColors.blue,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return assets.isEmpty
        ? Container()
        : Container(
            height: height * .135,
            width: double.infinity,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: assets.length,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    // if(isGainers)
                    gainerLooserItem(assets[index]),
                    // if(!isGainers) assetItem(assets[index]),
                    SizedBox(
                      width: width * .025,
                    ),
                  ],
                );
              },
            ),
          );
  }

  Widget buildSectionTitle(String titleKey) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.02),
          child: Text(
            appLocal.trans(titleKey),
            style: TextStyle(
              fontSize: AppFonts.getMediumFontSize(context),
              color: AppColors.white,
              height: 1.0,
            ),
          ),
        ),
        SizedBox(height: height * .01),
        Container(
          width: double.infinity,
          height: height * .001,
          color: AppColors.white.withOpacity(.35),
        ),
      ],
    );
  }

  Widget buildTopNewsResult() {
    return StreamBuilder<DataResource<List<NewsModel>>>(
        stream: homeScreenBloc.topNewsStream,
        builder: (context, newsSnapshot) {
          if (newsSnapshot.hasData && newsSnapshot.data != null) {
            switch (newsSnapshot.data!.status) {
              // case Status.LOADING:
              //   return buildTopPerformingAssetsList(isLoading: true);
              // case Status.LOADING_MORE:
              //   return buildResultList(items: coursesSnapshot.data.data);
              case Status.SUCCESS:
                return Column(
                  children: [
                    buildSectionTitle('top_news'),
                    SizedBox(height: height * .025),
                    buildTopNewsList(
                      news: newsSnapshot.data!.data,
                    ),
                  ],
                );
              // case Status.NO_MORE_RESULTS:
              //   return buildResultList(items: coursesSnapshot.data.data);
              // case Status.NO_RESULTS:
              //   return ErrorMessageWidget(messageKey: 'no_result_found_message', image: 'assets/images/ic_not_found.png');
              // case Status.FAILURE:
              //   return ErrorMessageWidget(messageKey: coursesSnapshot.data.message, image: 'assets/images/ic_error.png');

              default:
                return Container();
            }
          } else {
            return Container();
          }
        });
  }

  Widget buildTopNewsList({List<NewsModel>? news}) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: news?.length,
      padding: EdgeInsets.zero,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Column(
          children: [
            NewsItem(newsItem: news![index]),
            SizedBox(
              height: height * .025,
            ),
          ],
        );
      },
    );
  }

  Widget buildDrawerItem(image, titleKey, {iconSizeFactor = .05, fontSize, iconTextPaddingFactor = .06, onClick}) {
    return GestureDetector(
      onTap: onClick,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: width * .03),
          SvgPicture.asset(
            image,
            width: width * iconSizeFactor,
            height: width * iconSizeFactor,
          ),
          SizedBox(width: width * iconTextPaddingFactor),
          Text(
            appLocal.trans(titleKey),
            style: TextStyle(
              fontSize: fontSize != null ? fontSize : AppFonts.getNormalFontSize(context),
              color: Colors.white,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDrawerItemIcon(icon, titleKey, {iconSizeFactor = .05, fontSize, iconTextPaddingFactor = .06, onClick}) {
    return GestureDetector(
      onTap: onClick,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: width * .03),
          Icon(
            Icons.person_off_outlined,
            color: Colors.white,
            size: width * .063,
          ),
          SizedBox(width: width * 0.039),
          Text(
            appLocal.trans(titleKey),
            style: TextStyle(
              fontSize: fontSize != null ? fontSize : AppFonts.getNormalFontSize(context),
              color: Colors.white,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }

  Drawer buildDrawerContent() {
    return Drawer(
      child: Container(
        color: AppColors.black,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: height * .07,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: width * .025,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(width * .08),
                    child: Image.asset(
                      'assets/icons/placeholder.png', //TODO
                      width: width * .08,
                      height: width * .08,
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildUserName(),
                        Text(
                          '@${homeScreenBloc.loggedUser?.name ?? ''}',
                          style: TextStyle(
                            fontSize: AppFonts.getXSmallFontSize(context),
                            color: Colors.white.withOpacity(.75),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  // IconButton(
                  //   onPressed: () => Navigator.pop(context),
                  //   icon: SvgPicture.asset('assets/icons/ic_cross.svg',
                  //       width: width * .035, height: width * .035),
                  //   alignment: Alignment.topRight,
                  // ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * .03),
                    child: InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Icon(
                          Icons.close_outlined,
                          color: AppColors.white,
                          size: height * .033,
                        )),
                  )
                ],
              ),
              SizedBox(
                height: height * .07,
              ),
              // buildDrawerItem('assets/icons/ic_user.svg', 'profile',
              //     onClick: () {
              //   Utils.showToast('Coming Soon');
              // }),
              // SizedBox(
              //   height: height * .035,
              // ),
              buildDrawerItem(
                'assets/icons/ic_news.svg',
                'news_feed',
                onClick: () => rootScreenController.setCurrentScreen(AppMainScreens.NEWS_SCREEN),
              ),
              SizedBox(
                height: height * .035,
              ),
              // buildDrawerItem('assets/icons/ic_bar_chart.svg', 'wave_fund',
              //     onClick: () {
              //   Utils.showToast('Coming Soon');
              // }),
              // SizedBox(
              //   height: height * .1,
              // ),
              buildDrawerItemIcon('assets/icons/ic_exit.svg', 'delete_account', onClick: () async {
                showDeleteDialog();
              }),
              SizedBox(
                height: height * .035,
              ),

              SizedBox(
                height: height * .04,
              ),
              Row(
                children: [
                  buildDrawerItem(
                    'assets/icons/ic_verified.svg',
                    'premium_account',
                    fontSize: AppFonts.getXXSmallFontSize(context),
                    iconSizeFactor: .03,
                    iconTextPaddingFactor: .01,
                  ),
                  Spacer(),
                  buildDrawerItem(
                    'assets/icons/ic_logo.svg',
                    'wave_fund_member',
                    fontSize: AppFonts.getXXSmallFontSize(context),
                    iconSizeFactor: .035,
                    iconTextPaddingFactor: .01,
                  ),
                  SizedBox(
                    width: width * .05,
                  ),
                ],
              ),
              SizedBox(height: height * .008),

              Container(
                width: width,
                height: height * .001,
                color: AppColors.white.withOpacity(.35),
              ),

              SizedBox(
                height: height * .05,
              ),
              buildDrawerItem('assets/icons/ic_exit.svg', 'logout', onClick: () => uiController.logout(context)),
              // InkWell(
              //   onTap: () {
              //     Utils.showToast('Coming Soon');
              //   },
              //   child: Padding(
              //     padding: EdgeInsets.symmetric(horizontal: width * .035),
              //     child: Text(
              //       appLocal.trans('settings_privacy'),
              //       style: TextStyle(
              //         fontSize: AppFonts.getMediumFontSize(context),
              //         color: Colors.white,
              //       ),
              //     ),
              //   ),
              // ),
              // SizedBox(
              //   height: height * .025,
              // ),
              // InkWell(
              //   onTap: () {
              //     Utils.showToast('Coming Soon');
              //   },
              //   child: Padding(
              //     padding: EdgeInsets.symmetric(horizontal: width * .035),
              //     child: Text(
              //       appLocal.trans('help_center'),
              //       style: TextStyle(
              //         fontSize: AppFonts.getMediumFontSize(context),
              //         color: Colors.white,
              //       ),
              //     ),
              //   ),
              // ),
              // SizedBox(
              //   height: height * .040,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
