import 'package:flutter/material.dart';
import 'package:wave_flutter/di/price_history_step_dialog_content_di.dart';
import 'package:wave_flutter/helper/app_fonts.dart';
import 'package:wave_flutter/helper/enums.dart';
import 'package:wave_flutter/models/price_history_model.dart';
import 'package:wave_flutter/models/price_history_step_model.dart';
import 'package:wave_flutter/ui/common_widgets/base_statefull_widget.dart';
import 'package:wave_flutter/ui/common_widgets/image_widget.dart';
import '../add_asset_action_button.dart';
import '../add_assets_dialog_text_field.dart';

class PriceHistoryStepDialogContent extends BaseStateFullWidget {
  final int assetId;
  final String assetType;
  final String currentMarketValue;
  final int initialInvestmentYear;
  final VoidCallback onFinishButtonClicked;
  final Function() onSkipButtonClicked;
  PriceHistoryStepDialogContent({
    required this.assetId,
    required this.assetType,
    required this.currentMarketValue,
    required this.initialInvestmentYear,
    required this.onFinishButtonClicked,
    required this.onSkipButtonClicked,
  });

  @override
  createState() => _PriceHistoryStepDialogContentState();
}

class _PriceHistoryStepDialogContentState
    extends BaseStateFullWidgetState<PriceHistoryStepDialogContent>
    with PriceHistoryStepDialogContentDi {

  @override
  void initState() {
    initScreenDi(assetId: widget.assetId, assetType: widget.assetType,);
    super.initState();
    uiController.initYearPriceList(initialInvestmentYear: widget.initialInvestmentYear,);
    uiController.initCurrentMarketValue(widget.currentMarketValue);
  }

  @override
  Widget build(BuildContext context) {
    return buildScreenContent();
  }

  Widget buildScreenContent() {
    return Column(
      children: [
        SizedBox(height: height * .03),
        buildYearPriceComponent(),
        SizedBox(height: height * .03),
        AddAssetsDialogTextField(
          enabled: false,
          controller: uiController.currentMarketValueTextEditingController,
          keyboardType: TextInputType.number,
          hint: appLocal.trans('current_market_value'),
          onChanged: (value) => uiController.onPriceValueTextFieldChanged(value, uiController.yearPriceList.length -1),
          height: height* .07,
        ),
        SizedBox(height: height * .06),
        AddAssetActionButton(
          loadingStream: uiController.loadingStream,
          validationStream: uiController.validationStream,
          titleKey: 'finished',
          iconUrl: 'assets/icons/ic_arrow_next.svg',
          onClicked: () => uiController.onFinishButtonClicked(
            context: context,
            onDoneCallback: widget.onFinishButtonClicked,
          ),
        ),
        SizedBox(height: height * .03),
        buildSkipWidget(),
        SizedBox(height: height * .03),
      ],
    );
  }

  Widget buildYearPriceComponent() {
    List<YearPrice> yearPriceList = uiController.yearPriceList.take(uiController.yearPriceList.length-1).toList();

    if(yearPriceList.isEmpty) return Container();
    else return buildYearPriceList(yearPriceList);
  }

  Widget buildYearPriceList(List<YearPrice> yearPriceList) {
    int listLength = yearPriceList.length;
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: width * .01,
        mainAxisSpacing: height * .03,
        childAspectRatio: 2.25 / 1,
      ),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: listLength,
      itemBuilder: (context, index) {
        return AddAssetsDialogTextField(
          keyboardType: TextInputType.number,
          hint: yearPriceList[index].year,
          onChanged: (value) => uiController.onPriceValueTextFieldChanged(value, index),
        );
      },
    );
  }

  Widget buildSkipWidget() {
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: GestureDetector(
        onTap: () => widget.onSkipButtonClicked(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              appLocal.trans('skip'),
              style: TextStyle(
                height: 1.0,
                color: Colors.white,
                fontSize: AppFonts.getSmallFontSize(context),
              ),
            ),
            SizedBox(width: 4.0,),
            ImageWidget(
              url: 'assets/icons/ic_arrow_next.svg',
              width: width* .02,
              height: width* .02,
              fit: BoxFit.contain,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
