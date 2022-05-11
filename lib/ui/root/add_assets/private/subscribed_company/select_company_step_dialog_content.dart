import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wave_flutter/di/select_company_step_dialog_content_di.dart';
import 'package:wave_flutter/helper/app_colors.dart';
import 'package:wave_flutter/helper/app_fonts.dart';
import 'package:wave_flutter/helper/enums.dart';
import 'package:wave_flutter/models/private_asset_model.dart';
import 'package:wave_flutter/models/select_company_step_model.dart';
import 'package:wave_flutter/services/data_resource.dart';
import 'package:wave_flutter/ui/common_widgets/base_statefull_widget.dart';
import '../../add_asset_action_button.dart';
import '../../add_assets_dialog_text_field.dart';
import '../../custom_drop_down.dart';
import '../../loading_indicator.dart';

class SelectCompanyStepDialogContent extends BaseStateFullWidget {
  final Function(SelectCompanyStepModel selectCompanyStep) onNextButtonClicked;
  final ValueStream<DataResource<List<PrivateAssetModel>>?> privateAssetsStream;

  SelectCompanyStepDialogContent({required this.onNextButtonClicked, required this.privateAssetsStream,});

  @override
  createState() => _SelectCompanyStepDialogContentState();
}

class _SelectCompanyStepDialogContentState
    extends BaseStateFullWidgetState<SelectCompanyStepDialogContent>
    with SelectCompanyStepDialogContentDi {

  @override
  void initState() {
    initScreenDi();
    super.initState();
  }

  @override
  void dispose() {
    uiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildScreenContent();
  }

  Widget buildScreenContent() {
    return Column(
      children: [
        SizedBox(height: height * .03),
        buildPrivateAvailableCompanies(),
        SizedBox(height: height * .03),
        buildTextFieldValidationIndicator(titleKey: 'shareholder_passcode',),
        SizedBox(height: height * .03),
        AddAssetsDialogTextField(
          controller: uiController.shareholderPasscodeTextEditingController,
          keyboardType: TextInputType.number,
          hint: 'XXX-XXX-XXX',
          height: height* .070,
          onChanged: uiController.onSharesNumTextFieldChanged,
        ),
        SizedBox(height: height * .06),
        AddAssetActionButton(
          loadingStream: uiController.loadingStream,
          validationStream: uiController.validationStream,
          titleKey: 'next',
          iconUrl: 'assets/icons/ic_arrow_next.svg',
          onClicked: () => uiController.onNextButtonClicked(
            context: context,
            onDoneCallback: widget.onNextButtonClicked,
          ),
        ),
        SizedBox(height: height * .03),
      ],
    );
  }

  Widget buildPrivateAvailableCompanies() {
    return StreamBuilder<DataResource<List<PrivateAssetModel>>?>(
        stream: widget.privateAssetsStream,
        builder: (context, assetsSnapshot) {
          if (assetsSnapshot.hasData && assetsSnapshot.data != null) {
            switch (assetsSnapshot.data!.status) {
              case Status.LOADING:
                return LoadingIndicator();
              case Status.SUCCESS:
                return CustomDropDownWidget<PrivateAssetModel>(
                  title: 'Available Companies',
                  menuItems: assetsSnapshot.data!.data!,
                  onSelected: uiController.onPrivateCompanySelected,
                );
              default: return Container();
            }
          } else {
            return Container();
          }
        }
    );
  }

  Widget buildTextFieldValidationIndicator({required String titleKey,}) {
    return StreamBuilder<bool>(
        initialData: false,
        stream: uiController.validationShareholderPasscodeStream,
        builder: (context, isValidSnapshot) {
          return Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: height * .020),
            decoration: BoxDecoration(
              color: AppColors.mainColor,
              border: Border.all(color: isValidSnapshot.data! ? Colors.white : AppColors.mainColor, width: .5),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              appLocal.trans(titleKey),
              style: TextStyle(
                color: isValidSnapshot.data! ? AppColors.white : AppColors.white.withOpacity(.25),
                fontSize: AppFonts.getNormalFontSize(context),
                height: 1.0,
              ),
            ),
          );
        }
    );
  }

}
