import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wave_flutter/di/login_screen_di.dart';
import 'package:wave_flutter/helper/app_colors.dart';
import 'package:wave_flutter/helper/app_fonts.dart';
import 'package:wave_flutter/helper/routes_helper.dart';
import 'package:wave_flutter/helper/utils.dart';
import 'package:wave_flutter/models/user_model.dart';
import 'package:wave_flutter/ui/auth/forget_password_screen.dart';
import 'package:wave_flutter/ui/auth/reset_password_screen.dart';
import 'package:wave_flutter/ui/auth/sign_up_screen.dart';
import 'package:wave_flutter/ui/common_widgets/base_statefull_widget.dart';
import 'package:wave_flutter/ui/common_widgets/input_field.dart';
import 'package:wave_flutter/ui/common_widgets/main_button.dart';
import 'package:wave_flutter/ui/intro/splash_screen.dart';

class LoginScreen extends BaseStateFullWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends BaseStateFullWidgetState<LoginScreen> with LoginScreenDi{

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
                appLocal.trans('login'),
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
                hintKey: appLocal.trans('password'),
                height: height*.070,
              ),
              SizedBox(height: height* .030,),
              InkWell(
                onTap: () => RoutesHelper.navigateTo(classToNavigate: ForgetPasswordScreen(), context: context),
                child: Text(
                  appLocal.trans('forget_password'),
                  style: TextStyle(
                    fontSize: AppFonts.getSmallFontSize(context),
                    color: AppColors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              SizedBox(height: height* .030,),
              InkWell(
                onTap: () => RoutesHelper.navigateTo(classToNavigate: ResetPasswordScreen(), context: context),
                child: Text(
                  appLocal.trans('reset_password'),
                  style: TextStyle(
                    fontSize: AppFonts.getSmallFontSize(context),
                    color: AppColors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              SizedBox(height: height* .030,),
              StreamBuilder<bool>(
                initialData: false,
                stream: uiController.loadingLoginStream,
                builder: (context, loadingSnapshot) {
                  if(loadingSnapshot.data!){
                    return CircularProgressIndicator();
                  } else {
                    return buildMainBtn(
                      context: context,
                      titleKey: 'login',
                      height: height,
                      btnWidth: width* .4,
                      onClick: () {
                        if (validateInputs()) {
                          submitLoginIn(UserModel(
                            email: uiController.emailTextEditingController.text,
                            password: uiController.passwordTextEditingController.text,
                          ));
                        }
                      },
                    );
                  }
                }
              ),
              SizedBox(height: height* .050,),
              Divider(thickness: 1, color: Colors.white.withOpacity(.3),),
              SizedBox(height: height* .050,),
              Text(
                appLocal.trans('no_account_no_problem'),
                style: TextStyle(
                  fontSize: AppFonts.getSmallFontSize(context),
                  color: Colors.white.withOpacity(.3),
                ),
              ),
              SizedBox(height: height* .030,),
              buildMainBtn(
                context: context,
                titleKey: 'register',
                height: height,
                btnWidth: width* .4,
                onClick: () {
                  RoutesHelper.navigateTo(classToNavigate: SignUpScreen(), context: context);
                },
              ),
              SizedBox(height: height* .030,),
              Text(
                appLocal.trans('login_message'),
                style: TextStyle(
                  fontSize: AppFonts.getXSmallFontSize(context),
                  color: Colors.white.withOpacity(.3),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: height* .020,),
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

    if (validationMessage.isEmpty) {
      return true;
    } else {
      Fluttertoast.showToast(msg: validationMessage,);
      return false;
    }
  }

  Future<void> submitLoginIn(user) async {
    uiController.setLoadingLoginState(true);
    authBloc.signIn(
        user: user,
        onData: () {
          uiController.setLoadingLoginState(false);
          RoutesHelper.navigateTo(classToNavigate: SplashScreen(), context: context);
        },
        onError: (error) {
          uiController.setLoadingLoginState(false);
          Utils.showTranslatedToast(context, error);
        });
  }

}
