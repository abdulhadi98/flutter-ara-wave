import 'package:flutter/material.dart';
import 'package:wave_flutter/di/add_public_asset_holding_dialog_content_di.dart';
import 'package:wave_flutter/helper/app_colors.dart';
import 'package:wave_flutter/helper/app_fonts.dart';
import 'package:wave_flutter/models/public_asset_model.dart';
import 'package:wave_flutter/services/data_resource.dart';
import 'package:wave_flutter/ui/common_widgets/base_statefull_widget.dart';
import 'package:wave_flutter/ui/common_widgets/show_date_picker.dart';
import 'package:wave_flutter/ui/root/add_assets/addSearchable.dart';
import '../add_asset_action_button.dart';
import '../add_asset_dialog.dart';
import '../add_assets_dialog_text_field.dart';
import '../custom_drop_down.dart';
import '../loading_indicator.dart';

class AddPublicAssetHoldingDialogContent extends BaseStateFullWidget {
  final VoidCallback onAssetAdded;
  AddPublicAssetHoldingDialogContent({required this.onAssetAdded});
  @override
  createState() => _AddPublicAssetHoldingDialogContentState();
}

class _AddPublicAssetHoldingDialogContentState
    extends BaseStateFullWidgetState<AddPublicAssetHoldingDialogContent>
    with AddPublicAssetHoldingDialogContentDi {
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
    return AddAssetDialog(
      contentWidget: buildDialogContent(),
      titleKey: 'add_public_asset',
    );
  }

  Widget buildDialogContent() {
    return Column(
      children: [
        SizedBox(height: height * .03),
        buildPublicAvailableCompanies(),
        SizedBox(height: height * .03),
        AddAssetsDialogTextField(
          isMoney: false,
          isNumber: false,
          controller: uiController.stockExchangeTextEditingController,
          keyboardType: TextInputType.text,
          hint: appLocal.trans('enter_stock_exchange'),
          height: height * .070,
          onChanged: uiController.onStockExchangeTextFieldChanged,
        ),
        SizedBox(height: height * .03),
        AddAssetsDialogTextField(
          isMoney: false,
          isNumber: false,
          controller: uiController.ofSharesTextEditingController,
          keyboardType: TextInputType.number,
          hint: '# ${appLocal.trans('of_shares')}',
          height: height * .070,
          onChanged: uiController.onOfSharesTextFieldChanged,
        ),
        SizedBox(height: height * .03),
        buildPurchaseDatePlaceholderWidget(),
        SizedBox(height: height * .06),
        AddAssetActionButton(
          loadingStream: uiController.loadingStream,
          validationStream: uiController.validationStream,
          titleKey: 'add_asset',
          onClicked: () => uiController.onAddAssetButtonClicked(
              context, widget.onAssetAdded),
        ),
        SizedBox(height: height * .04),
      ],
    );
  }

  Widget buildPublicAvailableCompanies() {
    return StreamBuilder<DataResource<List<PublicAssetModel>>?>(
        stream: addPublicAssetHoldingBloc.publicAssetsStream,
        builder: (context, assetsSnapshot) {
          switch (assetsSnapshot.data?.status) {
            case Status.LOADING:
              return LoadingIndicator();
            case Status.SUCCESS:
              return CustomDropDownWidget<PublicAssetModel>(
                title: 'Available Companies',
                menuItems: assetsSnapshot.data!.data!,
                onSelected: uiController.onPublicCompanySelected,
              );
            default:
              return Container();
          }
        });
  }

  Widget buildSearchable() {
    return StreamBuilder<DataResource<List<PublicAssetModel>>?>(
        builder: (context, assetsSnapshot) {
      switch (assetsSnapshot.data?.status) {
        case Status.LOADING:
          return LoadingIndicator();
        case Status.SUCCESS:
          return SearchableWidget<PublicAssetModel>(
            title: 'Available Companies',
            menuItems: assetsSnapshot.data!.data!,
            onSelected: uiController.onPublicCompanySelected,
          );
        default:
          return Container();
      }
    });
  }

  Widget buildPurchaseDatePlaceholderWidget() {
    return StreamBuilder<DateTime?>(
        stream: uiController.purchaseDateStream,
        builder: (context, dateTimeSnapshot) {
          return GestureDetector(
            onTap: () async {
              DateTime? pickedDateTime = await showCustomDatePicker(
                initialDate: dateTimeSnapshot.data,
                context: context,
                locale: appLocal.locale,
              );
              uiController.onPurchaseDatePicked(pickedDateTime);
            },
            child: Container(
              height: height * .07,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.mainColor,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                dateTimeSnapshot.data == null
                    ? appLocal.trans('purchase_date')
                    : dateTimeSnapshot.data.toString().substring(0, 10),
                style: TextStyle(
                  color: dateTimeSnapshot.data != null
                      ? Colors.white
                      : Colors.white.withOpacity(.25),
                  fontSize: AppFonts.getSmallFontSize(context),
                  //height: 1.0,
                ),
              ),
            ),
          );
        });
  }
}
