import 'package:flutter/material.dart';
import 'package:wave_flutter/di/add_private_subscribed_company_dialog_content_di.dart';
import 'package:wave_flutter/helper/enums.dart';
import 'package:wave_flutter/helper/utils.dart';
import 'package:wave_flutter/ui/common_widgets/base_statefull_widget.dart';
import 'package:wave_flutter/ui/root/add_assets/price_history/price_history_step_dialog_content.dart';
import 'package:wave_flutter/ui/root/add_assets/private/company_info_step_dialog_content.dart';
import '../company_shares_step_dialog_content.dart';
import 'select_company_step_dialog_content.dart';

class AddPrivateSubscribedCompanyDialogContent extends BaseStateFullWidget {
  final VoidCallback onAssetAdded;
  AddPrivateSubscribedCompanyDialogContent({required this.onAssetAdded});

  @override
  createState() => _AddPrivateSubscribedCompanyDialogContentState();
}

class _AddPrivateSubscribedCompanyDialogContentState
    extends BaseStateFullWidgetState<AddPrivateSubscribedCompanyDialogContent>
    with AddPrivateSubscribedDialogContentDi {

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
    return StreamBuilder<AddingPrivateAssetStep>(
      initialData: AddingPrivateAssetStep.COMPANY,
      stream: uiController.addingPrivateAssetStepStream,
      builder: (context, stepSnapshot) {
        switch(stepSnapshot.data) {
          case AddingPrivateAssetStep.COMPANY:
            return buildSelectCompanyStepDialogContent();

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

  Widget buildSelectCompanyStepDialogContent() {
    return SelectCompanyStepDialogContent(
      privateAssetsStream: addPrivateSubscribedCompanyBloc.privateAssetsStream,
      onNextButtonClicked: (selectCompanyStep) => uiController.onSelectCompanyNextClicked(
        nextStep: AddingPrivateAssetStep.COMPANY_INFO,
        selectCompanyStep: selectCompanyStep,
      ),
    );
  }

  Widget buildCompanyInfoComponents() {
    return CompanyInfoStepDialogContent(
      initialCompanyName: uiController.selectCompanyStep!.company.name,
      onNextButtonClicked: (companyInfo) => uiController.onCompanyInfoNextClicked(
        nextStep: AddingPrivateAssetStep.COMPANY_SHARES,
        companyInfo: companyInfo,
      )
    );
  }

  Widget buildCompanySharesComponents() {
    return CompanySharesStepDialogContent(
      loadingStream: uiController.loadingStream,
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
