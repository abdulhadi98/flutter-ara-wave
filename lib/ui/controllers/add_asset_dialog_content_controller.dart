import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wave_flutter/bloc/holdings_screen_bloc.dart';
import 'package:wave_flutter/helper/enums.dart';
import 'package:wave_flutter/helper/utils.dart';
import 'package:wave_flutter/models/add_asset_holding_drop_down_menu_model.dart';
import 'package:wave_flutter/models/add_personal_asset_holding_model.dart';
import 'package:wave_flutter/models/add_private_asset_holding_model.dart';
import 'package:wave_flutter/models/assets_financials.dart';
import 'package:wave_flutter/models/holding_list_model.dart';
import 'package:wave_flutter/models/private_asset_holding_model.dart';
import 'package:wave_flutter/models/private_asset_model.dart';
import 'package:wave_flutter/models/upload_image_model.dart';
import 'package:wave_flutter/services/data_resource.dart';

class AddAssetDialogContentController {

  final HoldingsScreenBloc _holdingsScreenBloc;
  AddAssetDialogContentController({required holdingsScreenBloc, }):
        _holdingsScreenBloc = holdingsScreenBloc;

  final BehaviorSubject<HoldingsType?> holdingsTypeController = BehaviorSubject<HoldingsType?>();
  get holdingsTypeStream => holdingsTypeController.stream;
  HoldingsType? getHoldingsType() => holdingsTypeController.value;
  setHoldingsType(HoldingsType? type) => holdingsTypeController.sink.add(type);

  final BehaviorSubject<AddAssetHoldingDropDownMenuModel?> selectedPublicCompanyController = BehaviorSubject<AddAssetHoldingDropDownMenuModel?>();
  get selectedPublicCompanyStream => selectedPublicCompanyController.stream;
  AddAssetHoldingDropDownMenuModel? getSelectedPublicCompany() => selectedPublicCompanyController.valueOrNull;
  setSelectedPublicCompany(AddAssetHoldingDropDownMenuModel? company) => selectedPublicCompanyController.sink.add(company);

  final BehaviorSubject<AddAssetHoldingDropDownMenuModel?> selectedPrivateCompanyController = BehaviorSubject<AddAssetHoldingDropDownMenuModel?>();
  get selectedPrivateCompanyStream => selectedPrivateCompanyController.stream;
  AddAssetHoldingDropDownMenuModel? getSelectedPrivateCompany() => selectedPrivateCompanyController.valueOrNull;
  setSelectedPrivateCompany(AddAssetHoldingDropDownMenuModel? company) => selectedPrivateCompanyController.sink.add(company);

  final BehaviorSubject<AddAssetHoldingDropDownMenuModel?> selectedAssetTypesController = BehaviorSubject<AddAssetHoldingDropDownMenuModel?>();
  get selectedAssetTypesStream => selectedAssetTypesController.stream;
  AddAssetHoldingDropDownMenuModel? getSelectedAssetTypes() => selectedAssetTypesController.valueOrNull;
  setSelectedAssetTypes(AddAssetHoldingDropDownMenuModel? company) => selectedAssetTypesController.sink.add(company);

  final BehaviorSubject<AddingPersonalAssetStages?> addingPersonalAssetStagesController = BehaviorSubject<AddingPersonalAssetStages?>();
  get addingPersonalAssetStagesStream => addingPersonalAssetStagesController.stream;
  AddingPersonalAssetStages? getAddingPersonalAssetStages() => addingPersonalAssetStagesController.valueOrNull;
  setAddingPersonalAssetStages(AddingPersonalAssetStages? stage) => addingPersonalAssetStagesController.sink.add(stage);

  final BehaviorSubject<String?> selectedPersonalAssetCategoryController = BehaviorSubject<String?>();
  get selectedPersonalAssetCategoryStream => selectedPersonalAssetCategoryController.stream;
  String? getSelectedPersonalAssetCategory() => selectedPersonalAssetCategoryController.valueOrNull;
  setSelectedPersonalAssetCategory(String? category) => selectedPersonalAssetCategoryController.sink.add(category);

  final BehaviorSubject<bool?> validateAddPersonalAssetInfoController = BehaviorSubject<bool?>();
  get validateAddPersonalAssetInfoStream => validateAddPersonalAssetInfoController.stream;
  bool? getValidateAddPersonalAssetInfo() => validateAddPersonalAssetInfoController.valueOrNull;
  setValidateAddPersonalAssetInfo(bool? state) => validateAddPersonalAssetInfoController.sink.add(state);

  final BehaviorSubject<List<XFile?>?> pickedPhotoAssetsController = BehaviorSubject<List<XFile?>?>();
  get pickedPhotoAssetsStream => pickedPhotoAssetsController.stream;
  List<XFile?>? getPickedPhotoAssets() => pickedPhotoAssetsController.valueOrNull;
  setPickedPhotoAssets(List<XFile?>? photoAssets) => pickedPhotoAssetsController.sink.add(photoAssets);

  final privatePurchasedPriceTextEditingController = TextEditingController();
  final privateSharesNumTextEditingController = TextEditingController();

  final publicStockNumTextEditingController = TextEditingController();
  final publicPurchasedPriceTextEditingController = TextEditingController();
  final publicSharesNumTextEditingController = TextEditingController();

  final personalMarketValueTextEditingController = TextEditingController();
  final personalDownPaymentTextEditingController = TextEditingController();
  final personalPurchasePriceTextEditingController = TextEditingController();
  final personalLoanAmountTextEditingController = TextEditingController();
  final personalInterestRateTextEditingController = TextEditingController();
  final personalAmortizationTextEditingController = TextEditingController();
  final personalAssetNameTextEditingController = TextEditingController();
  final personalPropertyAddressTextEditingController = TextEditingController();
  final personalTitleTextEditingController = TextEditingController();
  final personalEstMarketPriceTextEditingController = TextEditingController();
  final personalSerialNumberTextEditingController = TextEditingController();


  List<AddPersonalAssetOptionModel> addPersonalAssetOptionList = [];

  void clearAddAssetInputs() {
    setSelectedPrivateCompany(null);
    setSelectedAssetTypes(null);
    privatePurchasedPriceTextEditingController.text = '';
    privateSharesNumTextEditingController.text = '';

    publicStockNumTextEditingController.text = '';
    publicPurchasedPriceTextEditingController.text = '';
    publicSharesNumTextEditingController.text = '';
  }

  bool validateAddPersonalAssetInfo() {
    return addPersonalAssetOptionList.length > 0;
  }

  String getScreenTitle(appLocal){
    switch(getHoldingsType()){
      case HoldingsType.PRIVATE:
        return appLocal.trans('private_holdings');
      case HoldingsType.PUBLIC:
        return appLocal.trans('public_holdings');
      case HoldingsType.PERSONAL:
        return appLocal.trans('personal_holdings');

      default: return appLocal.trans('personal_holdings');
    }
  }

  fetchInitialRequiredData(HoldingsType? type) {
    switch(type) {
      case HoldingsType.PERSONAL:
        fetchPersonalAssetTypes();
        break;
      case HoldingsType.PRIVATE:
        fetchPrivateAssets();
        break;
      case HoldingsType.PUBLIC:
        fetchPublicAssets();
        break;

      default: break;
    }
  }

  fetchPersonalAssetTypes() => _holdingsScreenBloc.fetchPersonalAssetTypes();
  fetchPrivateAssets() => _holdingsScreenBloc.fetchPrivateAssets();
  fetchPublicAssets() => _holdingsScreenBloc.fetchPublicAssets();

  final BehaviorSubject<bool> addingHoldingLoadingStateController = BehaviorSubject.seeded(false);
  get addingHoldingLoadingStateStream => addingHoldingLoadingStateController.stream;
  bool getAddingHoldingLoadingState() => addingHoldingLoadingStateController.value;
  setAddingHoldingLoadingState(bool state) => addingHoldingLoadingStateController.sink.add(state);

  onAddingPersonalAssetHoldingClicked(context,) {
    if(validateAddPersonalAssetInfo()){
      setAddingHoldingLoadingState(true);
      if(getPickedPhotoAssets()?.isNotEmpty??false) {
        List<UploadImageModel> images = _createUploadImageList('personal');
        _holdingsScreenBloc.uploadImageList(
          images: images,
          onData: () => _addPersonalAssetHolding(context: context, imageUrlList: images.map((e) => e.url??'').toList()),
          onError: (message) => _onHoldingAddingFailed(context, message),
        );
      } else _addPersonalAssetHolding(context: context);
    }
  }

  List<UploadImageModel> _createUploadImageList(assetType){
    return getPickedPhotoAssets()!.map<UploadImageModel>((e) => UploadImageModel(
      imagebase64: Utils.convertFileToBase64(e!.path),
      imageName: 'test', //ToDO
      assetType: assetType,
      apiToken: _holdingsScreenBloc.currentUser?.apiToken??'',
    )).toList();
  }

  _addPersonalAssetHolding({required context, List<String>? imageUrlList}) {
    _holdingsScreenBloc.addPersonalAssetHolding(
      addPersonalAssetHoldings: AddPersonalAssetHoldingModel(
        apiToken: _holdingsScreenBloc.currentUser?.apiToken??'',
        assetTypeId: getSelectedAssetTypes()?.id??-1,
        options: addPersonalAssetOptionList,
        photos: imageUrlList,
      ),
      onData: () => _onPersonalHoldingAddingSucceed(context,),
      onError: (message) => _onHoldingAddingFailed(context, message),
    );
  }

  onAddingPrivateHoldingClicked(context) {
    if(_validateAddPrivateHolding(context))
      _addPrivateAssetHolding(context);
  }

  onAddingPublicHoldingClicked(context) {
    if(_validateAddPublicHolding(context))
      _addPublicAssetHolding(context);
  }

  bool _validateAddPrivateHolding(context) {

    if(privatePurchasedPriceTextEditingController.text.isEmpty) {
      Utils.showToast('purchased price is required field!');
      return false;
    }

    if(getSelectedPrivateCompany() == null) {
      Utils.showToast('company is required field!');
      return false;
    }

    if(privateSharesNumTextEditingController.text.isEmpty) {
      Utils.showToast('shares number is required field!');
      return false;
    }

    return true;
  }

  bool _validateAddPublicHolding(context) {
    if(getSelectedPublicCompany() == null) {
      Utils.showToast('stock symbol is required field!');
      return false;
    }

    if(publicSharesNumTextEditingController.text.isEmpty) {
      Utils.showToast('shares number is required field!');
      return false;
    }

    if(publicPurchasedPriceTextEditingController.text.isEmpty) {
      Utils.showToast('purchased price is required field!');
      return false;
    }

    return true;
  }

  _addPrivateAssetHolding(context) {
    setAddingHoldingLoadingState(true);
    // _holdingsScreenBloc.addPrivateAssetHolding(
    //   addPrivateAssetHoldings: AddPrivateAssetHoldingModel(
    //       apiToken: _holdingsScreenBloc.currentUser?.apiToken??'',
    //       assetId: getSelectedPrivateCompany()!.id.toString(), //ToDo
    //       purchasedPrice: privatePurchasedPriceTextEditingController.text,
    //     quantity: privateSharesNumTextEditingController.text, //ToDo
    //     source: 'test', //ToDo
    //     verified: '1', //ToDo
    //     purchasedAt: DateTime.now().toString().substring(0, 10),
    //   ),
    //   onData: (holding) => _onPrivateHoldingAddingSucceed(context,),
    //   onError: (message) => _onHoldingAddingFailed(context, message),
    // );
  }

  _addPublicAssetHolding(context) {
    setAddingHoldingLoadingState(true);
    // _holdingsScreenBloc.addPublicAssetHolding(
    //   addPublicAssetHoldings: AddPrivateAssetHoldingModel(
    //     apiToken: _holdingsScreenBloc.currentUser?.apiToken??'',
    //     assetId: getSelectedPublicCompany()!.id.toString(), //ToDo
    //     purchasedPrice: publicPurchasedPriceTextEditingController.text,
    //     quantity: publicSharesNumTextEditingController.text, //ToDo
    //     source: 'test', //ToDo
    //     verified: '1', //ToDo
    //     purchasedAt: DateTime.now().toString().substring(0, 10),
    //   ),
    //   onData: (holding) => _onPublicHoldingAddingSucceed(context,),
    //   onError: (message) => _onHoldingAddingFailed(context, message),
    // );
  }

  var map = {
    "options": [
      {"option_id":3, "option_value_type":"select", "option_value":5},
      {"option_id":5, "option_value_type":"text", "option_value":"\$ 1000000"},
      {"option_id":7, "option_value_type":"text", "option_value":"\$ 900000"},
      {"option_id":13, "option_value_type":"text", "option_value":"my capin"}
      ]
  };

  _onPrivateHoldingAddingSucceed(context,) {
    _holdingsScreenBloc.fetchPrivateAssetHoldings(
      onData: () {
        setAddingHoldingLoadingState(false);
        Navigator.of(context).pop();
      },
      onError: (message) {
        setAddingHoldingLoadingState(false);
        Navigator.of(context).pop();
      },
    );
  }

  _onPublicHoldingAddingSucceed(context,) {
    _holdingsScreenBloc.fetchPublicAssetHoldings(
      onData: () {
        setAddingHoldingLoadingState(false);
        Navigator.of(context).pop();
      },
      onError: (message) {
        setAddingHoldingLoadingState(false);
        Navigator.of(context).pop();
      },
    );
  }

  _onPersonalHoldingAddingSucceed(context,) {
    _holdingsScreenBloc.fetchPersonalAssetHoldings(
      onData: () {
        setAddingHoldingLoadingState(false);
        Navigator.of(context).pop();
      },
      onError: (message) {
        setAddingHoldingLoadingState(false);
        Navigator.of(context).pop();
      },
    );
  }

  _onHoldingAddingFailed(context, String message) {
    setAddingHoldingLoadingState(false);
    Utils.showTranslatedToast(context, message);
  }

  disposeStreams() {
    holdingsTypeController.close();
    selectedPrivateCompanyController.close();
    selectedPublicCompanyController.close();
    selectedAssetTypesController.close();
    addingPersonalAssetStagesController.close();
    selectedPersonalAssetCategoryController.close();
    validateAddPersonalAssetInfoController.close();
    pickedPhotoAssetsController.close();
    addingHoldingLoadingStateController.close();
    _holdingsScreenBloc.disposeStreams();
  }
}