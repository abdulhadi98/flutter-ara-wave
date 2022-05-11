import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wave_flutter/bloc/holdings_screen_bloc.dart';
import 'package:wave_flutter/di/add_asset_dialog_content_di.dart';
import 'package:wave_flutter/helper/app_colors.dart';
import 'package:wave_flutter/helper/app_fonts.dart';
import 'package:wave_flutter/helper/enums.dart';
import 'package:intl/intl.dart';
import 'package:wave_flutter/helper/utils.dart';
import 'package:wave_flutter/models/add_asset_holding_drop_down_menu_model.dart';
import 'package:wave_flutter/models/add_personal_asset_holding_model.dart';
import 'package:wave_flutter/models/personal_asset_type.dart';
import 'package:wave_flutter/models/private_asset_model.dart';
import 'package:wave_flutter/models/public_asset_model.dart';
import 'package:wave_flutter/services/data_resource.dart';
import 'package:wave_flutter/ui/common_widgets/base_statefull_widget.dart';
import 'package:wave_flutter/ui/root/add_assets/custom_drop_down.dart';
import 'package:wave_flutter/ui/controllers/holdings_screen_controller.dart';

import 'add_asset_text_field.dart';

class AddAssetDialogContent extends BaseStateFullWidget {
  final HoldingsType? type;
  final HoldingsScreenBloc holdingsScreenBloc;

  AddAssetDialogContent({
    this.type,
    required this.holdingsScreenBloc,
  });

  @override
  _AddAssetDialogContentState createState() => _AddAssetDialogContentState();
}

class _AddAssetDialogContentState extends BaseStateFullWidgetState<AddAssetDialogContent> with AddAssetDialogContentDi {


  @override
  void initState() {
    super.initState();
    initScreenDi(holdingsScreenBloc: widget.holdingsScreenBloc);
    uiController.setHoldingsType(widget.type);
    uiController.fetchInitialRequiredData(widget.type);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.transparent,
      body: StreamBuilder<bool>(
        initialData: false,
        stream: uiController.addingHoldingLoadingStateStream,
        builder: (context, loadingSnapshot) {
          return IgnorePointer(
            ignoring: loadingSnapshot.data!,
            child: Stack(
              children: [
                Positioned(
                  top: width * .075 / 2,
                  right: width * .075 / 2,
                  left: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.mainColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: height * .025),
                        Text(
                          appLocal.trans('add_new_asset'),
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: AppFonts.getLargeFontSize(context),
                            height: 1.0,
                          ),
                        ),
                        SizedBox(height: height * .020),
                        Container(
                          margin: const EdgeInsets.all(1),
                          padding: EdgeInsets.symmetric(horizontal: width * .08),
                          decoration: BoxDecoration(
                            color: AppColors.black,
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(12),
                              bottomLeft: Radius.circular(12),
                            ),
                          ),
                          child: buildDialogContent(loadingSnapshot.data!),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: GestureDetector(
                    onTap: () {
                      uiController.clearAddAssetInputs();
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.gray, width: .5),
                        shape: BoxShape.circle,
                        color: AppColors.mainColor,
                      ),
                      child: Icon(
                        Icons.close,
                        color: AppColors.gray,
                        size: width * .055,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      ),
    );
  }

  Widget buildDialogContent(isLoading) {
    return StreamBuilder<HoldingsType?>(
      stream: uiController.holdingsTypeStream,
      builder: (context, typeSnapshot) {
        if(typeSnapshot.data!=null) return buildAddNewAssetContent(typeSnapshot.data!, isLoading);
        else return buildAddAssetTypeSelectorResult();
      },
    );
  }

  Widget buildAddNewAssetContent(type, isLoading) {
    switch (type) {
      case HoldingsType.PRIVATE:
        return buildPrivateContent(isLoading);

      case HoldingsType.PERSONAL:
        return buildPersonalContentResult(isLoading);

      case HoldingsType.PUBLIC:
        return buildPublicContentResult(isLoading);

      default: return buildAddAssetTypeSelectorResult();
    }
  }

  Widget buildAddAssetTypeSelectorResult() {
    return Column(
      children: [
        SizedBox(height: height * .03),
        buildAddAssetTypeSelectorItem(titleKey: 'private', type: HoldingsType.PRIVATE,),
        SizedBox(height: height * .02),
        buildAddAssetTypeSelectorItem(titleKey: 'public', type: HoldingsType.PUBLIC,),
        SizedBox(height: height * .02),
        buildAddAssetTypeSelectorItem(titleKey: 'personal', type: HoldingsType.PERSONAL,),
        SizedBox(height: height * .03),
      ],
    );
  }

  Widget buildAddAssetTypeSelectorItem({required titleKey, required HoldingsType type}) {
    return GestureDetector(
      onTap: () {
        uiController.setHoldingsType(type);
        uiController.fetchInitialRequiredData(type);
        },
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: height * .020),
        decoration: BoxDecoration(
          color: AppColors.mainColor,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          appLocal.trans(titleKey),
          style: TextStyle(
            color: AppColors.white.withOpacity(.85),
            fontSize: AppFonts.getNormalFontSize(context),
            height: 1.0,
          ),
        ),
      ),
    );
  }

  Widget buildPrivateContent(isLoading) {
    return Column(
      children: [
        SizedBox(height: height * .03),
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: height * .020),
          decoration: BoxDecoration(
            color: AppColors.mainColor,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Text(
            appLocal.trans('private'),
            style: TextStyle(
              color: AppColors.white,
              fontSize: AppFonts.getNormalFontSize(context),
              height: 1.0,
            ),
          ),
        ),
        SizedBox(height: height * .03),
        buildPrivateAvailableCompanies(),
        SizedBox(height: height * .03),
        buildDialogInputField(
          uiController.privatePurchasedPriceTextEditingController,
          TextInputType.number,
          hintKey: appLocal.trans('purchased_price'),
          height: height*.070,
        ),
        SizedBox(height: height * .03),
        buildDialogInputField(
          uiController.privateSharesNumTextEditingController,
          TextInputType.number,
          hintKey: appLocal.trans('num_of_shares'),
          height: height*.070,
        ),
        SizedBox(height: height * .06),
        if(!isLoading) buildDialogAddAssetBtn(
          onClicked: () => uiController.onAddingPrivateHoldingClicked(context),
        ),
        if(isLoading) buildLoadingIndicator(),
        SizedBox(height: height * .04),
      ],
    );
  }

  Widget buildPrivateAvailableCompanies() {
    return StreamBuilder<DataResource<List<PrivateAssetModel>>?>(
        stream: widget.holdingsScreenBloc.privateAssetsStream,
        builder: (context, assetsSnapshot) {
          if (assetsSnapshot.hasData && assetsSnapshot.data != null) {
            switch (assetsSnapshot.data!.status) {
              case Status.LOADING:
                return buildLoadingIndicator();
              case Status.SUCCESS:
                return CustomDropDownWidget(
                  title: 'Available Companies',
                  menuItems: getDropDownMenuModel(assetsSnapshot.data!.data!),
                  onSelected: (selectedItem) {
                    uiController.setSelectedPrivateCompany(selectedItem);
                  },
                );
              default:
                return Container();
            }
          } else {
            return Container();
          }
        }
    );
  }

  Widget buildPersonalContentResult(isLoading) {
    return StreamBuilder<DataResource<List<PersonalAssetTypeModel>>?>(
        stream: widget.holdingsScreenBloc.personalAssetTypesStream,
        builder: (context, typesSnapshot) {
          if (typesSnapshot.hasData && typesSnapshot.data != null) {
            return StreamBuilder<AddingPersonalAssetStages?>(
                initialData: AddingPersonalAssetStages.TYPE,
                stream: uiController.addingPersonalAssetStagesStream,
                builder: (context, stageSnapshot) {
                  switch (typesSnapshot.data!.status) {
                    case Status.LOADING:
                      return buildLoadingIndicator();
                    case Status.SUCCESS:
                      return buildPersonalContent(typesSnapshot.data!.data!, stageSnapshot.data!, isLoading: isLoading);
                  // case Status.NO_RESULTS:
                  //   return ErrorMessageWidget(messageKey: 'no_result_found_message', image: 'assets/images/ic_not_found.png');
                  // case Status.FAILURE:
                  //   return ErrorMessageWidget(messageKey: assetsSnapshot.data?.message??'', image: 'assets/images/ic_error.png');

                    default:
                      return Container();
                  }
                });
          } else {
            return Container();
          }
        }
    );
  }

  Widget buildPublicContentResult(bool isLoading) {
    return Column(
      children: [
        SizedBox(height: height * .03),
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: height * .020),
          decoration: BoxDecoration(
            color: AppColors.mainColor,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Text(
            appLocal.trans('public'),
            style: TextStyle(
              color: AppColors.white,
              fontSize: AppFonts.getNormalFontSize(context),
              height: 1.0,
            ),
          ),
        ),
        SizedBox(height: height * .03),
        buildPublicAvailableCompanies(),
        SizedBox(height: height * .03),
        buildDialogInputField(
          uiController.publicSharesNumTextEditingController,
          TextInputType.number,
          hintKey: appLocal.trans('amount_of_shares_purchased'),
          height: height*.070,
        ),
        SizedBox(height: height * .03),
        buildDialogInputField(
          uiController.publicPurchasedPriceTextEditingController,
          TextInputType.number,
          hintKey: appLocal.trans('purchased_price'),
          height: height*.070,
        ),
        SizedBox(height: height * .06),
        if(!isLoading) buildDialogAddAssetBtn(
          onClicked: () => uiController.onAddingPublicHoldingClicked(context),
        ),
        if(isLoading) buildLoadingIndicator(),
        SizedBox(height: height * .04),
      ],
    );
  }

  Widget buildPublicAvailableCompanies() {
    return StreamBuilder<DataResource<List<PublicAssetModel>>?>(
        stream: widget.holdingsScreenBloc.publicAssetsStream,
        builder: (context, assetsSnapshot) {
          if (assetsSnapshot.hasData && assetsSnapshot.data != null) {
            switch (assetsSnapshot.data!.status) {
              case Status.LOADING:
                return buildLoadingIndicator();
              case Status.SUCCESS:
                return CustomDropDownWidget(
                  title: 'Available Companies',
                  menuItems: getDropDownMenuModel(assetsSnapshot.data!.data!),
                  onSelected: (selectedItem) {
                    uiController.setSelectedPublicCompany(selectedItem);
                  },
                );
              default:
                return Container();
            }
          } else {
            return Container();
          }
        }
    );
  }

  Widget buildPersonalContent(List<PersonalAssetTypeModel> personalAssetTypes, AddingPersonalAssetStages stage, {isLoading = false,}) {
    switch (stage) {
      case AddingPersonalAssetStages.TYPE:
        return Column(
          children: [
            SizedBox(height: height * .03),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: height * .020),
              decoration: BoxDecoration(
                color: AppColors.mainColor,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                appLocal.trans('personal'),
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: AppFonts.getNormalFontSize(context),
                  height: 1.0,
                ),
              ),
            ),
            SizedBox(height: height * .03),
            CustomDropDownWidget(
              title: 'Asset Type',
              menuItems: getDropDownMenuModel(personalAssetTypes),
              onSelected: (selectedItem) {
                uiController.setSelectedAssetTypes(selectedItem);
                uiController.setAddingPersonalAssetStages(AddingPersonalAssetStages.INFO);
              },
            ),
            SizedBox(height: height * .03),
          ],
        );

      case AddingPersonalAssetStages.INFO:
        return Container(
          height: height * .6,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: height * .03),
                Container(
                  alignment: Alignment.center,
                  padding:
                  EdgeInsets.symmetric(vertical: height * .020),
                  decoration: BoxDecoration(
                    color: AppColors.mainColor,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    uiController.getSelectedAssetTypes()?.name??'',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: AppFonts.getNormalFontSize(context),
                      height: 1.0,
                    ),
                  ),
                ),
                SizedBox(height: height * .03),
                buildPersonalInfoGrid(personalAssetTypes.firstWhere((element) => element.id == uiController.getSelectedAssetTypes()?.id).personalAssetTypeOptions),
                SizedBox(height: height * .03),
                StreamBuilder<bool?>(
                    initialData: false,
                    stream: uiController.validateAddPersonalAssetInfoStream,
                    builder: (context, validateSnapshot) {
                      return GestureDetector(
                        onTap: () =>
                          uiController.onAddingPersonalAssetHoldingClicked(context),
                        child: isLoading ? buildLoadingIndicator() : Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(vertical: height * .020),
                          decoration: BoxDecoration(
                            color: AppColors.mainColor,
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(
                              color: validateSnapshot.data! ? Colors.white : AppColors.mainColor,
                              width: validateSnapshot.data! ? 1.0 : 0.0,
                            ),
                          ),
                          child: Text(
                            appLocal.trans('add_asset'),
                            style: TextStyle(
                              color: validateSnapshot.data! ? AppColors.white : AppColors.white.withOpacity(.3),
                              fontSize: AppFonts.getNormalFontSize(context),
                              height: 1.0,
                            ),
                          ),
                        ),
                      );
                    }),
                SizedBox(height: height * .03),
                StreamBuilder<bool?>(
                    initialData: false,
                    stream: uiController.validateAddPersonalAssetInfoStream,
                    builder: (context, validateSnapshot) {
                      return GestureDetector(
                        onTap: isLoading ? null : () {
                          if(uiController.validateAddPersonalAssetInfo()){
                            validateSnapshot.data!
                                ? uiController.setAddingPersonalAssetStages(AddingPersonalAssetStages.IMAGES)
                                : Utils.showTranslatedToast(context, 'add_personal_asset_message');
                          } else Utils.showTranslatedToast(context, 'add_personal_asset_message');
                        },
                        child: Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(
                              vertical: height * .020),
                          decoration: BoxDecoration(
                            color: AppColors.mainColor,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Row(
                            crossAxisAlignment:
                            CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Text(
                                  appLocal.trans('add_more_data'),
                                  style: TextStyle(
                                    color: validateSnapshot.data!
                                        ? AppColors.white
                                        : AppColors.white
                                        .withOpacity(.3),
                                    fontSize:
                                    AppFonts.getNormalFontSize(
                                        context),
                                    height: 1.0,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward,
                                color: validateSnapshot.data!
                                    ? Colors.white
                                    : Colors.white.withOpacity(.3),
                                size: width * .05,
                              ),
                              SizedBox(width: width * .04),
                            ],
                          ),
                        ),
                      );
                    }),
                SizedBox(height: height * .03),
              ],
            ),
          ),
        );

      case AddingPersonalAssetStages.IMAGES:
        return Container(
          height: height* .6,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: height * .03),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: height * .020),
                  decoration: BoxDecoration(
                    color: AppColors.mainColor,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    appLocal.trans('add_photos'),
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: AppFonts.getNormalFontSize(context),
                      height: 1.0,
                    ),
                  ),
                ),
                SizedBox(height: height * .03),
                buildPersonalPhotosGrid(),
                SizedBox(height: height * .02),
                buildDialogInputField(
                  uiController.personalPropertyAddressTextEditingController,
                  TextInputType.text,
                  hintKey: appLocal.trans('enter_property_address'),
                  height: height* .085,
                ),
                SizedBox(height: height * .03),
                GestureDetector(
                  onTap: () => uiController.onAddingPersonalAssetHoldingClicked(context),
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: height * .020),
                    decoration: BoxDecoration(
                      color: AppColors.mainColor,
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: Colors.white,
                        width: 1.0,
                      ),
                    ),
                    child: Text(
                      appLocal.trans('finished'),
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize:
                        AppFonts.getNormalFontSize(context),
                        height: 1.0,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: height * .03),
              ],
            ),
          ),
        );

      default:
        return Container();
    }
  }

  Widget buildPersonalInfoGrid(List<PersonalAssetTypeOptionModel> options) {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: options.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: width * .030,
        mainAxisSpacing: height * .03,
        childAspectRatio: 1.65 / 1,
      ),
      itemBuilder: (context, index) {
        PersonalAssetTypeOptionModel option = options[index];
        switch(option.typeEnum) {
          // case AddPersonalAssetHoldingTypeOptionType.select:
          //   return CustomDropDownWidget(
          //     title: option.name,
          //     menuItems: getDropDownMenuModel(option.personalAssetTypeOptionValues??[]),
          //     onSelected: (selectedItem) {
          //       AddPersonalAssetOptionModel? repetedOption = Utils.findItemById<AddPersonalAssetOptionModel?>(uiController.addPersonalAssetOptionList, option.id);
          //       if(repetedOption!=null){
          //         uiController.addPersonalAssetOptionList.remove(repetedOption);
          //       }
          //
          //       uiController.addPersonalAssetOptionList.add(AddPersonalAssetOptionModel(
          //         id: option.id,
          //         type: Utils.enumToString(AddPersonalAssetHoldingTypeOptionType.select),
          //         value: selectedItem.name,
          //       ),);
          //
          //       uiController.setValidateAddPersonalAssetInfo(uiController.validateAddPersonalAssetInfo());
          //     },
          //   );

          case AddPersonalAssetHoldingTypeOptionType.text:
            return AddAssetTextField(
                hintKey: option.name,
                onChanged: (value) {
                  AddPersonalAssetOptionModel? repetedOption = Utils.findItemById<AddPersonalAssetOptionModel?>(uiController.addPersonalAssetOptionList, option.id);
                  if(repetedOption!=null){
                    uiController.addPersonalAssetOptionList.remove(repetedOption);
                  }

                  uiController.addPersonalAssetOptionList.add(AddPersonalAssetOptionModel(
                    id: option.id,
                    type: Utils.enumToString(AddPersonalAssetHoldingTypeOptionType.text),
                    value: value,
                  ),);

                  uiController.setValidateAddPersonalAssetInfo(uiController.validateAddPersonalAssetInfo());
                }
              );

          default: return SizedBox();
        }
        },
    );


    // return GridView.count(
    //   physics: NeverScrollableScrollPhysics(),
    //   crossAxisCount: 2,
    //   crossAxisSpacing: width * .030,
    //   mainAxisSpacing: height * .03,
    //   shrinkWrap: true,
    //   childAspectRatio: 1.65 / 1,
    //   children: [
    //     buildDialogDropDownMenu(
    //       stream: uiController.selectedPersonalAssetCategoryStream,
    //       title: 'Category',
    //       menuItems: getDropDownMenuModel([
    //         'Residential',
    //         'Commercial',
    //         'Industrial',
    //         'Mixed-Use',
    //         'Land',
    //         'Special Purpose',
    //         'Agricultural',
    //       ]),
    //       onChanged: (newValue,) {
    //         uiController.setSelectedPersonalAssetCategory(newValue);
    //         uiController.setValidateAddPersonalAssetInfo(
    //             uiController.validateAddPersonalAssetInfo());
    //       },
    //     ),
    //     buildDialogDropDownMenu(
    //       stream: uiController.selectedPersonalAssetProperetyTypeStream,
    //       title: 'Property type',
    //       menuItems: getDropDownMenuModel([
    //         'Single Family',
    //         'Multi Family',
    //         'Apart Building',
    //         'Condo',
    //         'Manufactured',
    //         'Cooperative',
    //       ]),
    //       onChanged: (newValue,) {
    //         uiController.setSelectedPersonalAssetProperetyType(newValue);
    //         uiController.setValidateAddPersonalAssetInfo(
    //             uiController.validateAddPersonalAssetInfo());
    //       },
    //     ),
    //     buildDialogInputField(
    //       uiController.personalMarketValueTextEditingController,
    //       TextInputType.number,
    //       labelKey: appLocal.trans('market_key'),
    //     ),
    //     buildDialogInputField(
    //       uiController.personalDownPaymentTextEditingController,
    //       TextInputType.number,
    //       labelKey: appLocal.trans('down_payment'),
    //     ),
    //     buildDialogInputField(
    //       uiController.personalPurchasePriceTextEditingController,
    //       TextInputType.number,
    //       labelKey: appLocal.trans('purchase_price'),
    //     ),
    //     buildDialogInputField(
    //       uiController.personalLoanAmountTextEditingController,
    //       TextInputType.number,
    //       labelKey: appLocal.trans('loan_amount'),
    //     ),
    //     buildDialogInputField(
    //       uiController.personalInterestRateTextEditingController,
    //       TextInputType.number,
    //       labelKey: appLocal.trans('interest_rate'),
    //     ),
    //     buildDialogInputField(
    //       uiController.personalAmortizationTextEditingController,
    //       TextInputType.number,
    //       labelKey: appLocal.trans('amortization'),
    //     ),
    //     StreamBuilder<DateTime?>(
    //         stream: uiController.personalAcquisitionDateStream,
    //         builder: (context, dateSnapshot) {
    //           return GestureDetector(
    //             onTap: () async {
    //               final dateTime = await showDatePicker(
    //                 context: context,
    //                 initialDate: uiController.getPersonalAcquisitionDate() ??
    //                     DateTime.now(),
    //                 firstDate: DateTime(2000),
    //                 lastDate: DateTime(2025),
    //                 builder: (context, child) {
    //                   return Theme(
    //                     data: ThemeData.dark(),
    //                     // This will change to light theme.
    //                     child: child!,
    //                   );
    //                 },
    //               );
    //               if (dateTime != null) {
    //                 uiController.setPersonalAcquisitionDate(dateTime);
    //                 uiController.setValidateAddPersonalAssetInfo(
    //                     uiController.validateAddPersonalAssetInfo());
    //               }
    //             },
    //             child: Container(
    //               alignment: Alignment.center,
    //               padding: EdgeInsets.symmetric(
    //                   vertical: height * .020, horizontal: width * .02),
    //               decoration: BoxDecoration(
    //                 color: AppColors.mainColor,
    //                 borderRadius: BorderRadius.circular(8.0),
    //               ),
    //               child: Text(
    //                 dateSnapshot.data != null
    //                     ? DateFormat.yMMMMd(appLocal.locale.languageCode)
    //                         .format(dateSnapshot.data!)
    //                     : appLocal.trans('acquisition_date'),
    //                 style: TextStyle(
    //                   color: dateSnapshot.data != null
    //                       ? AppColors.white
    //                       : AppColors.white.withOpacity(.3),
    //                   fontSize: dateSnapshot.data != null
    //                       ? AppFonts.getMediumFontSize(context)
    //                       : AppFonts.getSmallFontSize(context),
    //                   height: 1.0,
    //                 ),
    //                 maxLines: 1,
    //                 overflow: TextOverflow.ellipsis,
    //               ),
    //             ),
    //           );
    //         }),
    //     buildDialogInputField(
    //       uiController.personalAssetNameTextEditingController,
    //       TextInputType.text,
    //       hintKey: appLocal.trans('asset_name'),
    //     ),
    //   ],
    // );
  }

  Widget buildDialogInputField(controller, keyboardType, {hintKey, labelKey, height}) {
    return Container(
      height: height??double.infinity,
      alignment: Alignment.center,
      // padding: EdgeInsets.only(top: height* .008,),
      decoration: BoxDecoration(
        color: AppColors.mainColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: TextField(
          autofocus: false,
          enabled: true,
          onChanged: (v) {
            if (v != null) {
              uiController.setValidateAddPersonalAssetInfo(uiController.validateAddPersonalAssetInfo());
            }
          },
          textInputAction: TextInputAction.next,
          // onEditingComplete: () => uiController.setValidateAddPersonalAssetInfo(uiController.validateAddPersonalAssetInfo()),
          style: TextStyle(
            color: AppColors.white,
            fontSize: AppFonts.getMediumFontSize(context),
            height: 1.1,
          ),
          keyboardType: keyboardType,
          cursorColor: AppColors.blue,
          textAlign: TextAlign.center,
          maxLines: 1,
          controller: controller,
          decoration: InputDecoration(
            contentPadding:
                EdgeInsets.symmetric(horizontal: width * .02, vertical: 0.0,),
            fillColor: AppColors.mainColor,
            filled: true,
            labelText: labelKey,
            // alignLabelWithHint: true,
            labelStyle: labelKey!= null ? TextStyle(
              color: AppColors.white.withOpacity(.3),
              fontSize: AppFonts.getSmallFontSize(context),
            ): null,
            hintText: hintKey,
            hintStyle: hintKey!= null ? TextStyle(
              color: AppColors.white.withOpacity(.3),
              fontSize: AppFonts.getSmallFontSize(context),
            ): null,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget buildDialogRowInputField(controller, keyboardType, prefixTitle, {hintKey, labelKey, height}){
    return Container(
      height: height??double.infinity,
      alignment: Alignment.center,
      // padding: EdgeInsets.only(top: height* .008,),
      decoration: BoxDecoration(
        color: AppColors.mainColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              fit: FlexFit.tight,
              flex: 3,
              child: Text(
                prefixTitle,
                style: TextStyle(
                  fontSize: AppFonts.getMediumFontSize(context),
                  color: Colors.white,
                  height: 1.0,
                ),
                textAlign: TextAlign.end,
              ),
            ),
            Flexible(
              fit: FlexFit.tight,
              flex: 2,
              child: TextField(
                autofocus: false,
                enabled: true,
                onChanged: (v) {
                  if (v != null) {
                    uiController.setValidateAddPersonalAssetInfo(uiController.validateAddPersonalAssetInfo());
                  }
                },
                textInputAction: TextInputAction.next,
                // onEditingComplete: () => uiController.setValidateAddPersonalAssetInfo(uiController.validateAddPersonalAssetInfo()),
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: AppFonts.getMediumFontSize(context),
                  height: 1.1,
                ),
                keyboardType: keyboardType,
                cursorColor: AppColors.blue,
                textAlign: TextAlign.center,
                maxLines: 1,
                controller: controller,
                decoration: InputDecoration(
                  contentPadding:
                  EdgeInsets.symmetric(horizontal: width * .02, vertical: 0.0,),
                  fillColor: AppColors.mainColor,
                  filled: true,
                  labelText: labelKey,
                  // alignLabelWithHint: true,
                  labelStyle: labelKey!= null ? TextStyle(
                    color: AppColors.white.withOpacity(.3),
                    fontSize: AppFonts.getSmallFontSize(context),
                  ): null,
                  hintText: hintKey,
                  hintStyle: hintKey!= null ? TextStyle(
                    color: AppColors.white.withOpacity(.3),
                    fontSize: AppFonts.getSmallFontSize(context),
                  ): null,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLoadingIndicator() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      alignment: Alignment.center,
      child: CircularProgressIndicator(),
    );
  }

  Widget buildDialogAddAssetBtn({required onClicked}) {
    return GestureDetector(
      onTap: onClicked,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: height * .020),
        decoration: BoxDecoration(
          color: AppColors.mainColor,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          appLocal.trans('add_asset'),
          style: TextStyle(
            color: AppColors.white,
            fontSize: AppFonts.getNormalFontSize(context),
            height: 1.0,
          ),
        ),
      ),
    );
  }

  Widget buildPersonalPhotosGrid() {
    photoComponentItem({XFile? xFile}) {
      return Stack(
        children: [
          GestureDetector(
            onTap: () async {
              Utils.getImagesFromGallery(
                onData: (List<XFile>? xFiles) {
                  if(xFiles!=null && xFiles.isNotEmpty){
                    if(uiController.getPickedPhotoAssets()!=null) uiController.setPickedPhotoAssets(uiController.getPickedPhotoAssets()?..addAll(xFiles));
                    else uiController.setPickedPhotoAssets(xFiles);
                  }
                  },
                onError: () {

                },
              );
            },
            child: Container(
              margin: EdgeInsets.only(left: width* .02, top: height* .01,),
              width: double.infinity,
              height: double.infinity,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.mainColor,
                borderRadius: BorderRadius.circular(6.0),
              ),
              child: SvgPicture.asset(
                'assets/icons/ic_circular_add.svg',
                width: width * .1,
                height: width * .1,
              ),
            ),
          ),
          if (xFile != null) Positioned(
            top: height* .01,
            left: width* .02,
            bottom: 0,
            right: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(6.0)),
              child: Image.file(
                File(xFile.path),
                fit: BoxFit.cover,
                // width: double.infinity,
                // height: double.infinity,
              ),
            ),
          ),
          if(xFile!=null) GestureDetector(
            onTap: () {
              uiController.setPickedPhotoAssets(uiController.getPickedPhotoAssets()?..remove(xFile));
            },
            child: Icon(
              Icons.cancel,
              color: Colors.red.shade400,
              size: width* .075,
            ),
          ),
        ],
      );
    }

    return StreamBuilder<List<XFile?>?>(
      stream: uiController.pickedPhotoAssetsStream,
      builder: (context, photosSnapshot) {
        int gridItemsLength=6;
        if(photosSnapshot.hasData&&photosSnapshot.data!=null){
          if(photosSnapshot.data!.length >= 6) gridItemsLength=photosSnapshot.data!.length+1;
        }
        return GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            // maxCrossAxisExtent: 200,
            childAspectRatio: 1 / 1,
            crossAxisSpacing: width * .030,
            mainAxisSpacing: width * .030,
            crossAxisCount: 2,
          ),
          itemCount: gridItemsLength,
          itemBuilder: (context, index) {
            XFile? photoAsset;
            if(index < (photosSnapshot.data?.length??-1)) photoAsset = photosSnapshot.data![index];
            return photoComponentItem(xFile: photoAsset);
          },
        );
        },
    );
  }

  List<AddAssetHoldingDropDownMenuModel> getDropDownMenuModel(List list) {
     return list.map((e) => AddAssetHoldingDropDownMenuModel(id: e.id??'', name: e.name??'',)).toList();
  }
}
