import 'package:flutter/material.dart';
import 'package:wave_flutter/di/company_info_step_dialog_content_di.dart';
import 'package:wave_flutter/helper/app_colors.dart';
import 'package:wave_flutter/helper/app_fonts.dart';
import 'package:wave_flutter/models/company_info_step_model.dart';
import 'package:wave_flutter/ui/common_widgets/base_statefull_widget.dart';
import 'package:wave_flutter/ui/common_widgets/show_date_picker.dart';
import '../add_asset_action_button.dart';
import '../add_assets_dialog_text_field.dart';

class CompanyInfoStepDialogContent extends BaseStateFullWidget {
  final Function(CompanyInfoStepModel companyInfo) onNextButtonClicked;
  final String? initialCompanyName;
  CompanyInfoStepDialogContent({required this.onNextButtonClicked, this.initialCompanyName,});

  @override
  createState() => _CompanyInfoStepDialogContentState();
}

class _CompanyInfoStepDialogContentState
    extends BaseStateFullWidgetState<CompanyInfoStepDialogContent>
    with CompanyInfoStepDialogContentDi {

  @override
  void initState() {
    initScreenDi();
    uiController.companyNameTextEditingController.text = widget.initialCompanyName??'';

    super.initState();
  }

  @override
  void dispose() {
    uiController.disposeParent();
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
        AddAssetsDialogTextField(
          enabled: widget.initialCompanyName==null,
          controller: uiController.companyNameTextEditingController,
          keyboardType: TextInputType.text,
          hint: appLocal.trans('name_of_company'),
          height: height* .070,
          onChanged: uiController.onCompanyNameTextFieldChanged,
        ),
        SizedBox(height: height * .03),
        AddAssetsDialogTextField(
          controller: uiController.headquarterCityTextEditingController,
          keyboardType: TextInputType.text,
          hint: appLocal.trans('headquarter_city'),
          height: height* .070,
          onChanged: uiController.onHeadquarterCityTextFieldChanged,
        ),
        SizedBox(height: height * .03),
        AddAssetsDialogTextField(
          controller: uiController.countryTextEditingController,
          keyboardType: TextInputType.text,
          hint: 'country',
          height: height* .070,
          onChanged: uiController.onCountryTextFieldChanged,
        ),
        SizedBox(height: height * .03),
        buildYearPlaceholderWidget(),
        SizedBox(height: height * .06),
        AddAssetActionButton(
          validationStream: uiController.validationStream,
          titleKey: 'next',
          iconUrl: 'assets/icons/ic_arrow_next.svg',
          onClicked: () => uiController.onNextClicked(onDoneCallback: widget.onNextButtonClicked),
        ),
        SizedBox(height: height * .03),
      ],
    );
  }

  Widget buildYearPlaceholderWidget() {
    return StreamBuilder<int?>(
      stream: uiController.initialInvestmentYearStream,
      builder: (context, yearSnapshot) {
        return GestureDetector(
          onTap: () async => showYearPicker(
            initialDate: yearSnapshot.data!=null ? DateTime(yearSnapshot.data!) : null,
            context: context,
            onDatePicked: (dateTime) => uiController.onInitialInvestmentYearSelected(dateTime),
          ),
          child: Container(
            height: height* .07,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.mainColor,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              '${yearSnapshot.data??appLocal.trans('year_of_initial_investment')}',
              style: TextStyle(
                color: yearSnapshot.data!=null ? Colors.white : Colors.white.withOpacity(.25),
                fontSize: AppFonts.getMediumFontSize(context),
                height: 1.0,
              ),
            ),
          ),
        );
      }
    );
  }
}
