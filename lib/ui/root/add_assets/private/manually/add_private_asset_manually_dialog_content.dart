import 'package:flutter/material.dart';
import 'package:wave_flutter/di/add_private_asset_manually_dialog_content_di.dart';
import 'package:wave_flutter/helper/enums.dart';
import 'package:wave_flutter/helper/utils.dart';
import 'package:wave_flutter/models/asset_list_model.dart';
import 'package:wave_flutter/ui/common_widgets/base_statefull_widget.dart';
import 'package:wave_flutter/ui/root/add_assets/price_history/price_history_step_dialog_content.dart';
import '../company_info_step_dialog_content.dart';
import '../company_shares_step_dialog_content.dart';

class AddPrivateAssetManuallyDialogContent extends BaseStateFullWidget {
  final VoidCallback onAssetAdded;
  AddPrivateAssetManuallyDialogContent({required this.onAssetAdded});

  @override
  createState() => _AddPrivateAssetManuallyDialogContentState();
}

class _AddPrivateAssetManuallyDialogContentState
    extends BaseStateFullWidgetState<AddPrivateAssetManuallyDialogContent>
    with AddPrivateAssetManuallyDialogContentDi {

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
    return StreamBuilder<AddingPrivateAssetStep>(
        initialData: AddingPrivateAssetStep.COMPANY_INFO,
        stream: uiController.addingPrivateAssetStepStream,
        builder: (context, stepSnapshot) {
          switch(stepSnapshot.data) {
            case AddingPrivateAssetStep.COMPANY_INFO:
              return buildCompanyInfoComponents();

            case AddingPrivateAssetStep.COMPANY_SHARES:
              return buildCompanySharesComponents();

            case AddingPrivateAssetStep.PRICE_HISTORY:
              return buildPriceHistoryComponents();

            default: return Container();
          }
        }
    );
  }

  Widget buildCompanyInfoComponents() {
    return CompanyInfoStepDialogContent(
        onNextButtonClicked: (companyInfo) => uiController.onCompanyInfoNextClicked(
          nextStep: AddingPrivateAssetStep.COMPANY_SHARES,
          companyInfo: companyInfo,
        )
    );
  }

  Widget buildCompanySharesComponents() {
    return CompanySharesStepDialogContent(
      loadingStream: uiController.loadingStream,
      // onPriceHistoryButtonClicked: (sharesStep) => uiController.onNextButtonClicked(AddingPrivateAssetStep.PRICE_HISTORY),
      onPriceHistoryButtonClicked: (sharesStep) => uiController.onPriceHistoryButtonClicked(
        context: context,
        nextStep: AddingPrivateAssetStep.PRICE_HISTORY,
        sharesStep: sharesStep,
        onAssetAdded: widget.onAssetAdded,
      ),
    );
  }

  Widget buildPriceHistoryComponents() {
    return PriceHistoryStepDialogContent(
      assetId: uiController.addedAssetId!,
      assetType: Utils.enumToString(HoldingsType.PRIVATE).toLowerCase(),
      currentMarketValue: uiController.companySharesStep!.marketValue.toString(),
      initialInvestmentYear: uiController.companyInfo?.initialInvestmentYear??0,
      onFinishButtonClicked: () => uiController.onFinishedClicked(context),
      onSkipButtonClicked: () => Navigator.of(context).pop(),
    );
  }

}
