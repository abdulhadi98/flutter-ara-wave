import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wave_flutter/di/login_screen_di.dart';
import 'package:wave_flutter/di/forget_password_screen_di.dart';
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

class ForgetPasswordScreen extends BaseStateFullWidget {
  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends BaseStateFullWidgetState<ForgetPasswordScreen> with ForgetPasswordScreenDi{

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
      body: Container(
        // height: height,
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(horizontal: width* .15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: mediaQuery.padding.top + height* .08),
            SvgPicture.asset(
              'assets/icons/ic_logo.svg',
              width: width* .125,
              height: width* .125,
            ),
            SizedBox(height: height* .035),
            Text(
              appLocal.trans('reset_your_password'),
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
              hintKey: appLocal.trans('enter_your_email'),
              height: height*.070,
            ),
            SizedBox(height: height* .05,),
            StreamBuilder<bool>(
                initialData: false,
                stream: uiController.loadingResetPasswordStream,
                builder: (context, loadingSnapshot) {
                  if(loadingSnapshot.data!){
                    return CircularProgressIndicator();
                  } else {
                    return buildMainBtn(
                      context: context,
                      titleKey: 'reset',
                      height: height,
                      btnWidth: width* .4,
                      onClick: () => uiController.onResetPasswordClicked(context),
                    );
                  }
                }
            ),
            SizedBox(height: height* .050,),
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
    );
  }

}
