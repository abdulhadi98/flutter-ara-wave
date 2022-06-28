import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wave_flutter/di/company_info_step_dialog_content_di.dart';
import 'package:wave_flutter/di/company_shares_step_dialog_content_di.dart';
import 'package:wave_flutter/helper/app_colors.dart';
import 'package:wave_flutter/helper/app_fonts.dart';
import 'package:wave_flutter/helper/utils.dart';
import 'package:wave_flutter/models/company_info_step_model.dart';
import 'package:wave_flutter/models/company_shares_step_model.dart';
import 'package:wave_flutter/ui/common_widgets/base_statefull_widget.dart';
import 'package:wave_flutter/ui/common_widgets/show_date_picker.dart';
import '../add_asset_action_button.dart';
import '../add_assets_dialog_text_field.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:intl/intl.dart';

class CompanySharesStepDialogContent extends BaseStateFullWidget {
  final ValueStream<bool>? loadingStream;
  final Function(CompanySharesStepModel sharesStep) onPriceHistoryButtonClicked;
  CompanySharesStepDialogContent(
      {required this.onPriceHistoryButtonClicked, required this.loadingStream});

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

  String formattedNum(String s) {
    return Utils.getFormattedStrNum(s);
  }

  TextEditingController investCont = TextEditingController(text: '');
  FocusNode fn = FocusNode();
  Widget buildScreenContent() {
    return Column(
      children: [
        SizedBox(height: height * .03),
        AddAssetsDialogTextField(
          isMoney: true,
          isNumber: false,
          controller: uiController.investmentCapitalTextEditingController,
          keyboardType: TextInputType.number,
          hint: appLocal.trans('invested'),
          height: height * .070,
          // inputFormatters: [
          //   FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]')),
          // ],

          onChanged: uiController.onInvestmentCapitalTextFieldChanged
          // var price = int.parse(val.replaceAll(',', ''));
          // var comma = NumberFormat('###,###,###,###');
          // investCont.text =
          //     comma.format(price).replaceAll(' ', '');
          // //     textEditingController.selection=TextSelection(baseOffset: )
          // //   val = formattedNum(val);
          // // if (val.length > 3)

          // // FocusScope.of(context).requestFocus(fn);

          // //   print(uiController.investmentCapitalTextEditingController.text);
          // uiController.onInvestmentCapitalTextFieldChanged(val);
          ,
        ),
        SizedBox(height: height * .03),
        AddAssetsDialogTextField(
          isMoney: false,
          isNumber: true,
          controller: uiController.sharedPurchasesTextEditingController,
          keyboardType: TextInputType.number,
          hint: '# ${appLocal.trans('shares_purchased')}',
          height: height * .070,
          onChanged: uiController.onSharedPurchasesTextFieldChanged,
        ),
        // SizedBox(height: height * .03),
        // AddAssetsDialogTextField(
        //     controller: uiController.purchasedPriceTextEditingController,
        //     keyboardType: TextInputType.text,
        //     hint: 'Purchased Price',
        //     height: height * .070,
        //     onChanged: uiController.onPurchasedPriceTextFieldChanged),
        SizedBox(height: height * .03),
        AddAssetsDialogTextField(
          isMoney: false,
          isNumber: false,
          controller: uiController.sharesClassTextEditingController,
          keyboardType: TextInputType.text,
          hint: appLocal.trans('share_class'),
          height: height * .070,
          onChanged: uiController.onSharesClassTextFieldChanged,
        ),
        SizedBox(height: height * .03),
        AddAssetsDialogTextField(
          isMoney: false,
          isNumber: true,
          controller:
              uiController.companySharesOutstandingTextEditingController,
          keyboardType: TextInputType.number,
          hint: appLocal.trans('company_shares_outstanding'),
          height: height * .070,
          onChanged: uiController.onCompanySharesOutstandingTextFieldChanged,
        ),
        SizedBox(height: height * .03),
        AddAssetsDialogTextField(
          isMoney: true,
          isNumber: false,
          controller: uiController.marketValueTextEditingController,
          keyboardType: TextInputType.number,
          hint: appLocal.trans('current_market_value'),
          height: height * .070,
          onChanged: uiController.onMarketValueTextFieldChanged,
        ),
        SizedBox(height: height * .034),
        AddAssetActionButton(
          loadingStream: widget.loadingStream,
          validationStream: uiController.validationStream,
          titleKey: 'price_history',
          iconUrl: 'assets/icons/ic_arrow_next.svg',
          onClicked: () => uiController.onPriceHistoryButtonClicked(
              onDoneCallback: widget.onPriceHistoryButtonClicked),
        ),
        SizedBox(height: height * .03),
      ],
    );
  }

  Widget buildInvestmentCapitalWidget() {
    return Container(
      height: height * .07,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.mainColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(
        appLocal.trans('invested'),
        style: TextStyle(
          color: Colors.white,
          fontSize: AppFonts.getNormalFontSize(context),
          height: 1.0,
        ),
      ),
    );
  }
}
