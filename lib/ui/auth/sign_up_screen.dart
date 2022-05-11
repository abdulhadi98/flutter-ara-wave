import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wave_flutter/di/login_screen_di.dart';
import 'package:wave_flutter/di/sign_up_screen_di.dart';
import 'package:wave_flutter/helper/app_colors.dart';
import 'package:wave_flutter/helper/app_fonts.dart';
import 'package:wave_flutter/helper/routes_helper.dart';
import 'package:wave_flutter/helper/utils.dart';
import 'package:wave_flutter/models/user_model.dart';
import 'package:wave_flutter/ui/auth/login_screen.dart';
import 'package:wave_flutter/ui/common_widgets/base_statefull_widget.dart';
import 'package:wave_flutter/ui/root/add_assets/custom_drop_down.dart';
import 'package:wave_flutter/ui/common_widgets/input_field.dart';
import 'package:wave_flutter/ui/common_widgets/main_button.dart';
import 'package:wave_flutter/ui/intro/splash_screen.dart';

class SignUpScreen extends BaseStateFullWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends BaseStateFullWidgetState<SignUpScreen> with SignUpScreenDi{

  @override
  void initState() {
    super.initState();

    initScreenDi();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Container(
          // height: height,
          margin: EdgeInsets.symmetric(horizontal: width* .15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: mediaQuery.padding.top + height* .08),
              SvgPicture.asset(
                'assets/icons/ic_logo.svg',
                width: width* .125,
                height: width* .125,
              ),
              SizedBox(height: height* .035),
              Text(
                appLocal.trans('register'),
                style: TextStyle(
                  fontSize: AppFonts.getLargeFontSize(context),
                  color: Colors.white,
                ),
              ),
              SizedBox(height: height* .050),
              buildDialogInputField(
                context,
                width,
                uiController.emailTextEditingController,
                TextInputType.text,
                hintKey: appLocal.trans('email'),
                height: height*.070,
              ),
              SizedBox(height: height* .030,),
              buildDialogInputField(
                context,
                width,
                uiController.passwordTextEditingController,
                TextInputType.text,
                obscureText: true,
                hintKey: appLocal.trans('set_password'),
                height: height*.070,
              ),
              SizedBox(height: height* .030,),
              buildDialogInputField(
                context,
                width,
                uiController.firstNameTextEditingController,
                TextInputType.text,
                hintKey: appLocal.trans('first_name'),
                height: height*.070,
              ),
              SizedBox(height: height* .030,),
              buildDialogInputField(
                context,
                width,
                uiController.lastNameTextEditingController,
                TextInputType.text,
                hintKey: appLocal.trans('last_name'),
                height: height*.070,
              ),
              SizedBox(height: height* .030,),
              buildCustomDropDownMenu(
                  screenWidth: width,
                  stream: uiController.selectedCountryStream,
                  hintKey: 'select_country',
                  menuItems: [
                    'USA',
                    'SY',
                    'JP',
                    'UAE',
                    'UK',
                    'GE',
                  ],
                  onChanged: (newValue) => uiController.setSelectedCountry(newValue),
              ),
              SizedBox(height: height* .030,),
              buildDialogInputField(
                context,
                width,
                uiController.phoneTextEditingController,
                TextInputType.number,
                hintKey: appLocal.trans('international_phone'),
                height: height*.070,
              ),
              SizedBox(height: height* .030,),
              StreamBuilder<bool>(
                  initialData: false,
                  stream: uiController.loadingSignUpStream,
                  builder: (context, loadingSnapshot) {
                    if(loadingSnapshot.data!){
                      return CircularProgressIndicator();
                    } else {
                      return buildMainBtn(
                        context: context,
                        titleKey: 'register',
                        height: height,
                        btnWidth: width* .4,
                        onClick: () {
                          if (validateInputs()) {
                            submitSignUp(UserModel(
                              email: uiController.emailTextEditingController.text,
                              password: uiController.passwordTextEditingController.text,
                              firstName: uiController.firstNameTextEditingController.text,
                              lastName: uiController.lastNameTextEditingController.text,
                              country: uiController.getSelectedCountry(),
                              phone: uiController.phoneTextEditingController.text,
                              //TODO
                              name: uiController.firstNameTextEditingController.text +' '+ uiController.lastNameTextEditingController.text,
                              joinDate: DateTime.now(),
                              city: 'Damas',
                            ));
                          }
                        },
                      );
                    }
                  }
              ),
              SizedBox(height: height* .030,),
              InkWell(
                onTap: () {
                  RoutesHelper.navigateTo(classToNavigate: LoginScreen(), context: context);
                },
                child: Text(
                  appLocal.trans('back_to_login'),
                  style: TextStyle(
                    fontSize: AppFonts.getSmallFontSize(context),
                    color: AppColors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              SizedBox(height: height* .030,),
            ],
          ),
        ),
      ),
    );
  }

  bool validateInputs() {
    var validationMessage = '';

    if (uiController.emailTextEditingController.text.isEmpty || !uiController.emailTextEditingController.text.contains('@')) {
      if (validationMessage.isNotEmpty) validationMessage = validationMessage + '\nInvalid email';
      validationMessage = 'Invalid email';
    }
    if (uiController.passwordTextEditingController.text.isEmpty || uiController.passwordTextEditingController.text.length < 5) {
      if (validationMessage.isNotEmpty)
        validationMessage = validationMessage + '\nPassword is too short!';
      else
        validationMessage = 'Password is too short!';
    }
    if (uiController.firstNameTextEditingController.text.isEmpty) {
      if (validationMessage.isNotEmpty) validationMessage = validationMessage + '\nfirst name required';
      validationMessage = 'first name required';
    }
    if (uiController.lastNameTextEditingController.text.isEmpty) {
      if (validationMessage.isNotEmpty) validationMessage = validationMessage + '\nlast name required';
      validationMessage = 'last name required';
    }
    if (uiController.phoneTextEditingController.text.isEmpty) {
      if (validationMessage.isNotEmpty) validationMessage = validationMessage + '\nphone number required';
      validationMessage = 'phone number required';
    }
    if(uiController.getSelectedCountry()==null){
      if (validationMessage.isNotEmpty) validationMessage = validationMessage + '\ncountry required';
      validationMessage = 'country required';
    }

    if (validationMessage.isEmpty) {
      return true;
    } else {
      Fluttertoast.showToast(msg: validationMessage,);
      return false;
    }
  }

  Future<void> submitSignUp(user) async {
    uiController.setLoadingSignUpState(true);
    authBloc.signUp(
        user: user,
        onData: () {
          uiController.setLoadingSignUpState(false);
          RoutesHelper.navigateTo(classToNavigate: SplashScreen(), context: context);
        },
        onError: (error) {
          uiController.setLoadingSignUpState(false);
          Utils.showTranslatedToast(context, error);
        });
  }


  Widget buildCustomDropDownMenu({required screenWidth,required stream,required hintKey,required menuItems,required onChanged}) {
    return StreamBuilder<String?>(
        stream: stream,
        builder: (context, companySnapshot) {
          return Container(
            padding: EdgeInsets.only(left: screenWidth * .05, right: screenWidth * .05),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.mainColor,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: DropdownButton<String>(
              value: companySnapshot.data,
              hint: Text(
                appLocal.trans(hintKey),
                textAlign: TextAlign.left,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    height: 1.0, color: AppColors.white.withOpacity(.3)),
              ),
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
              iconSize: screenWidth * .055,
              elevation: 0,
              underline: SizedBox(),
              style: const TextStyle(color: Colors.white),
              onChanged: (String? newValue) {
                if (newValue != null) onChanged(newValue);
              },
              dropdownColor: AppColors.mainColor,
              items: menuItems.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    textAlign: TextAlign.left,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      height: 1.0,
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        });
  }

}
