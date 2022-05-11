import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wave_flutter/di/company_info_step_dialog_content_di.dart';
import 'package:wave_flutter/di/company_shares_step_dialog_content_di.dart';
import 'package:wave_flutter/helper/app_colors.dart';
import 'package:wave_flutter/helper/app_fonts.dart';
import 'package:wave_flutter/models/company_info_step_model.dart';
import 'package:wave_flutter/models/company_shares_step_model.dart';
import 'package:wave_flutter/ui/common_widgets/base_statefull_widget.dart';
import 'package:wave_flutter/ui/common_widgets/show_date_picker.dart';
import '../add_asset_action_button.dart';
import '../add_assets_dialog_text_field.dart';

class CompanySharesStepDialogContent extends BaseStateFullWidget {
  final ValueStream<bool>? loadingStream;
  final Function(CompanySharesStepModel sharesStep) onPriceHistoryButtonClicked;
  CompanySharesStepDialogContent({required this.onPriceHistoryButtonClicked, required this.loadingStream});

  @override
  createState() => _CompanySharesStepDialogContentState();
}

class _CompanySharesStepDialogContentState
    extends BaseStateFullWidgetState<CompanySharesStepDialogContent>
    with CompanySharesStepDialogContentDi {

  @override
  void initState() {
    initScreenDi();
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
          controller: uiController.investmentCapitalTextEditingController,
          keyboardType: TextInputType.number,
          hint: appLocal.trans('investment_capital'),
          height: height* .070,
          onChanged: uiController.onInvestmentCapitalTextFieldChanged,
        ),
        SizedBox(height: height * .03),
        AddAssetsDialogTextField(
          controller: uiController.sharedPurchasesTextEditingController,
          keyboardType: TextInputType.number,
          hint: '# ${appLocal.trans('shares_purchased')}',
          height: height* .070,
          onChanged: uiController.onSharedPurchasesTextFieldChanged,
        ),
        SizedBox(height: height * .03),
        AddAssetsDialogTextField(
          controller: uiController.sharesClassTextEditingController,
          keyboardType: TextInputType.text,
          hint: appLocal.trans('share_class'),
          height: height* .070,
          onChanged: uiController.onSharesClassTextFieldChanged,
        ),
        SizedBox(height: height * .03),
        AddAssetsDialogTextField(
          controller: uiController.companySharesOutstandingTextEditingController,
          keyboardType: TextInputType.number,
          hint: appLocal.trans('company_shares_outstanding'),
          height: height* .070,
          onChanged: uiController.onCompanySharesOutstandingTextFieldChanged,
        ),
        SizedBox(height: height * .03),
        AddAssetsDialogTextField(
          controller: uiController.marketValueTextEditingController,
          keyboardType: TextInputType.number,
          hint: appLocal.trans('current_market_value'),
          height: height* .070,
          onChanged: uiController.onMarketValueTextFieldChanged,
        ),
        SizedBox(height: height * .06),
        AddAssetActionButton(
          loadingStream: widget.loadingStream,
          validationStream: uiController.validationStream,
          titleKey: 'price_history',
          iconUrl: 'assets/icons/ic_arrow_next.svg',
          onClicked: () =>
              uiController.onPriceHistoryButtonClicked(onDoneCallback: widget.onPriceHistoryButtonClicked),
        ),
        SizedBox(height: height * .03),
      ],
    );
  }

  Widget buildInvestmentCapitalWidget() {
    return Container(
      height: height* .07,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.mainColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(
        appLocal.trans('investment_capital'),
        style: TextStyle(
          color: Colors.white ,
          fontSize: AppFonts.getNormalFontSize(context),
          height: 1.0,
        ),
      ),
    );
  }
}
