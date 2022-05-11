import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wave_flutter/bloc/holdings_screen_bloc.dart';
import 'package:wave_flutter/helper/enums.dart';
import 'package:wave_flutter/helper/utils.dart';
import 'package:wave_flutter/models/add_private_asset_holding_model.dart';
import 'package:wave_flutter/models/assets_financials.dart';
import 'package:wave_flutter/models/holding_list_model.dart';
import 'package:wave_flutter/models/private_asset_holding_model.dart';
import 'package:wave_flutter/models/private_asset_model.dart';
import 'package:wave_flutter/models/public_asset_graph_request_body.dart';
import 'package:wave_flutter/services/data_resource.dart';

class HoldingsScreenController {

  final HoldingsScreenBloc _holdingsScreenBloc;
  HoldingsScreenController({required holdingsScreenBloc, }):
        _holdingsScreenBloc = holdingsScreenBloc;

  final BehaviorSubject<HoldingsType> holdingsTypeController = BehaviorSubject<HoldingsType>.seeded(HoldingsType.PRIVATE);
  get holdingsTypeStream => holdingsTypeController.stream;
  HoldingsType getHoldingsType() => holdingsTypeController.value;
  setHoldingsType(HoldingsType type) => holdingsTypeController.sink.add(type);

  final BehaviorSubject<String?> selectedPrivateCompanyController = BehaviorSubject<String?>();
  get selectedPrivateCompanyStream => selectedPrivateCompanyController.stream;
  String? getSelectedPrivateCompany() => selectedPrivateCompanyController.value;
  setSelectedPrivateCompany(String? company) => selectedPrivateCompanyController.sink.add(company);

  final BehaviorSubject<String?> selectedAssetTypesController = BehaviorSubject<String?>();
  get selectedAssetTypesStream => selectedAssetTypesController.stream;
  String? getSelectedAssetTypes() => selectedAssetTypesController.valueOrNull;
  setSelectedAssetTypes(String? company) => selectedAssetTypesController.sink.add(company);

  final BehaviorSubject<AddingPersonalAssetStages?> addingPersonalAssetStagesController = BehaviorSubject<AddingPersonalAssetStages?>();
  get addingPersonalAssetStagesStream => addingPersonalAssetStagesController.stream;
  AddingPersonalAssetStages? getAddingPersonalAssetStages() => addingPersonalAssetStagesController.valueOrNull;
  setAddingPersonalAssetStages(AddingPersonalAssetStages? stage) => addingPersonalAssetStagesController.sink.add(stage);

  final BehaviorSubject<String?> selectedPersonalAssetCategoryController = BehaviorSubject<String?>();
  get selectedPersonalAssetCategoryStream => selectedPersonalAssetCategoryController.stream;
  String? getSelectedPersonalAssetCategory() => selectedPersonalAssetCategoryController.valueOrNull;
  setSelectedPersonalAssetCategory(String? category) => selectedPersonalAssetCategoryController.sink.add(category);

  final BehaviorSubject<String?> selectedPersonalAssetProperetyTypeController = BehaviorSubject<String?>();
  get selectedPersonalAssetProperetyTypeStream => selectedPersonalAssetProperetyTypeController.stream;
  String? getSelectedPersonalAssetProperetyType() => selectedPersonalAssetProperetyTypeController.valueOrNull;
  setSelectedPersonalAssetProperetyType(String? category) => selectedPersonalAssetProperetyTypeController.sink.add(category);

  final BehaviorSubject<DateTime?> personalAcquisitionDateController = BehaviorSubject<DateTime?>();
  get personalAcquisitionDateStream => personalAcquisitionDateController.stream;
  DateTime? getPersonalAcquisitionDate() => personalAcquisitionDateController.valueOrNull;
  setPersonalAcquisitionDate(DateTime? date) => personalAcquisitionDateController.sink.add(date);

  final BehaviorSubject<bool?> validateAddPersonalAssetInfoController = BehaviorSubject<bool?>();
  get validateAddPersonalAssetInfoStream => validateAddPersonalAssetInfoController.stream;
  bool? getValidateAddPersonalAssetInfo() => validateAddPersonalAssetInfoController.valueOrNull;
  setValidateAddPersonalAssetInfo(bool? state) => validateAddPersonalAssetInfoController.sink.add(state);

  final BehaviorSubject<List<XFile?>?> pickedPhotoAssetsController = BehaviorSubject<List<XFile?>?>();
  get pickedPhotoAssetsStream => pickedPhotoAssetsController.stream;
  List<XFile?>? getPickedPhotoAssets() => pickedPhotoAssetsController.valueOrNull;
  setPickedPhotoAssets(List<XFile?>? photoAssets) => pickedPhotoAssetsController.sink.add(photoAssets);

  final BehaviorSubject<String?> selectedPersonalAssetController = BehaviorSubject<String?>();
  get selectedPersonalAssetStream => selectedPersonalAssetController.stream;
  String? getSelectedPersonalAsset() => selectedPersonalAssetController.valueOrNull;
  setSelectedPersonalAsset(String? asset) => selectedPersonalAssetController.sink.add(asset);

  final BehaviorSubject<String?> selectedPersonalAssetNftSecuredController = BehaviorSubject<String?>();
  get selectedPersonalAssetNftSecuredStream => selectedPersonalAssetNftSecuredController.stream;
  String? getSelectedPersonalAssetNftSecured() => selectedPersonalAssetNftSecuredController.valueOrNull;
  setSelectedPersonalAssetNftSecured(String? asset) => selectedPersonalAssetNftSecuredController.sink.add(asset);

  final BehaviorSubject<String?> selectedPersonalAssetCollectionController = BehaviorSubject<String?>();
  get selectedPersonalAssetCollectionStream => selectedPersonalAssetCollectionController.stream;
  String? getSelectedPersonalAssetCollection() => selectedPersonalAssetCollectionController.valueOrNull;
  setSelectedPersonalAssetCollection(String? asset) => selectedPersonalAssetCollectionController.sink.add(asset);

  final BehaviorSubject<String?> selectedPersonalAssetTierController = BehaviorSubject<String?>();
  get selectedPersonalAssetTierStream => selectedPersonalAssetTierController.stream;
  String? getSelectedPersonalAssetTier() => selectedPersonalAssetTierController.valueOrNull;
  setSelectedPersonalAssetTier(String? asset) => selectedPersonalAssetTierController.sink.add(asset);

  final BehaviorSubject<String?> selectedPersonalAssetSetSeriesController = BehaviorSubject<String?>();
  get selectedPersonalAssetSetSeriesStream => selectedPersonalAssetSetSeriesController.stream;
  String? getSelectedPersonalAssetSetSeries() => selectedPersonalAssetSetSeriesController.valueOrNull;
  setSelectedPersonalAssetSetSeries(String? asset) => selectedPersonalAssetSetSeriesController.sink.add(asset);

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

  void clearAddAssetInputs(){
    setSelectedPrivateCompany(null);
    setSelectedAssetTypes(null);
    privatePurchasedPriceTextEditingController.text = '';
    privateSharesNumTextEditingController.text = '';

    publicStockNumTextEditingController.text = '';
    publicPurchasedPriceTextEditingController.text = '';
    publicSharesNumTextEditingController.text = '';
  }

  bool validateAddPersonalAssetInfo() {
    if(getSelectedAssetTypes()=='Collectables'){
      if(getSelectedPersonalAsset()!=null &&
          getSelectedPersonalAssetNftSecured()!=null &&
          getSelectedPersonalAssetCollection()!=null &&
          getSelectedPersonalAssetCategory()!=null &&
          getSelectedPersonalAssetTier()!=null &&
          getSelectedPersonalAssetSetSeries()!=null &&
          personalTitleTextEditingController.text.isNotEmpty &&
          personalPurchasePriceTextEditingController.text.isNotEmpty &&
          personalEstMarketPriceTextEditingController.text.isNotEmpty &&
          personalSerialNumberTextEditingController.text.isNotEmpty
      ){
        return true;
      }
    } else {
      if(getSelectedPersonalAssetCategory()!=null &&
          getSelectedPersonalAssetProperetyType()!=null &&
          getSelectedPersonalAssetProperetyType()!=null &&
          getPersonalAcquisitionDate()!=null &&
          personalMarketValueTextEditingController.text.isNotEmpty &&
          personalDownPaymentTextEditingController.text.isNotEmpty &&
          personalPurchasePriceTextEditingController.text.isNotEmpty &&
          personalLoanAmountTextEditingController.text.isNotEmpty &&
          personalInterestRateTextEditingController.text.isNotEmpty &&
          personalAmortizationTextEditingController.text.isNotEmpty &&
          personalAssetNameTextEditingController.text.isNotEmpty
      ){
        return true;
      }
    }
    return false;
  }

  get assetsFinancialsStream {
    switch(getHoldingsType()){
      case HoldingsType.PRIVATE:
        return _holdingsScreenBloc.privateAssetsFinancialsStream;

      case HoldingsType.PUBLIC:
        return _holdingsScreenBloc.publicAssetsFinancialsStream;

      case HoldingsType.PERSONAL:
        return _holdingsScreenBloc.personalAssetsFinancialsStream;
    }
  }
  DataResource<AssetsFinancials>? getAssetsFinancials() {
    switch(getHoldingsType()){
      case HoldingsType.PRIVATE:
        return _holdingsScreenBloc.getPrivateAssetsFinancials();

      case HoldingsType.PUBLIC:
        return _holdingsScreenBloc.getPublicAssetsFinancials();

      case HoldingsType.PERSONAL:
        return _holdingsScreenBloc.getPersonalAssetsFinancials();
    }
  }

  void fetchAssetsFinancialsResults() {
    switch(getHoldingsType()){
      case HoldingsType.PRIVATE:
        _holdingsScreenBloc.fetchPrivateAssetsFinancials();
        break;

      case HoldingsType.PUBLIC:
        _holdingsScreenBloc.fetchPublicAssetsFinancials();
        break;

      case HoldingsType.PERSONAL:
        _holdingsScreenBloc.fetchPersonalAssetsFinancials();
        break;
    }
  }

  void fetchAssetsResults() {
    switch(getHoldingsType()){
      case HoldingsType.PRIVATE:
        _holdingsScreenBloc.fetchPrivateAssetHoldings();
        break;

      case HoldingsType.PUBLIC:
        _holdingsScreenBloc.fetchPublicAssetHoldings();
        break;

      case HoldingsType.PERSONAL:
        _holdingsScreenBloc.fetchPersonalAssetHoldings();
        break;
    }
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

  fetchPersonalAssetTypes() => _holdingsScreenBloc.fetchPersonalAssetTypes();

  ChartFilters? chartFilter;
  fetchPublicAssetHistorical({ChartFilters filter=ChartFilters.xALL}) {
    chartFilter = filter;
    _holdingsScreenBloc.setPublicAssetGraph(DataResource.loading());
    _holdingsScreenBloc.fetchPublicAssetMainGraph(
        publicAssetGraphRequestBody: _createPublicAssetGraphRequestBody()
    );
  }

  PublicAssetGraphRequestBody _createPublicAssetGraphRequestBody() {
    return PublicAssetGraphRequestBody(
      apiToken: _holdingsScreenBloc.currentUser?.apiToken??'',
      fromDate: _getChartFromTime(),
      toDate: DateTime.now().toString().substring(0, 10),
      interval: 1,
      range: Utils.enumToString(_getChartRange()),
    );
  }

  String _getChartFromTime() {
    DateTime nowDateTime = DateTime.now();
    switch(chartFilter){
      case ChartFilters.x24H:
        return DateTime(nowDateTime.year, nowDateTime.month, nowDateTime.day, nowDateTime.hour-24).toString().substring(0, 10);

      case ChartFilters.x7D:
        return DateTime(nowDateTime.year, nowDateTime.month, nowDateTime.day- 7).toString().substring(0, 10);

      case ChartFilters.x1M:
        return DateTime(nowDateTime.year, nowDateTime.month-1, nowDateTime.day).toString().substring(0, 10);

      case ChartFilters.x3M:
        return DateTime(nowDateTime.year, nowDateTime.month-3, nowDateTime.day).toString().substring(0, 10);

      case ChartFilters.x1Y:
        return DateTime(nowDateTime.year-1, nowDateTime.month, nowDateTime.day).toString().substring(0, 10);

      default:
        return DateTime(nowDateTime.year-5, nowDateTime.month, nowDateTime.day).toString().substring(0, 10);
    }
  }

  PublicAssetHistoricalDataRanges _getChartRange() {
    switch(chartFilter){
      case ChartFilters.x24H:
        return PublicAssetHistoricalDataRanges.hour;

      case ChartFilters.x7D:
        return PublicAssetHistoricalDataRanges.day;

      case ChartFilters.x1M:
        return PublicAssetHistoricalDataRanges.day;

      case ChartFilters.x3M:
        return PublicAssetHistoricalDataRanges.week;

      case ChartFilters.x1Y:
        return PublicAssetHistoricalDataRanges.month;

      default: return PublicAssetHistoricalDataRanges.quarter;
    }
  }

  final BehaviorSubject<bool> addingHoldingLoadingStateController = BehaviorSubject.seeded(false);
  get addingHoldingLoadingStateStream => addingHoldingLoadingStateController.stream;
  bool getAddingHoldingLoadingState() => addingHoldingLoadingStateController.value;
  setAddingHoldingLoadingState(bool state) => addingHoldingLoadingStateController.sink.add(state);

  onAddingPrivateHoldingClicked(context) {
    if(_validateAddPrivateHolding(context))
      _addPrivateAssetHolding(context);
  }

  bool _validateAddPrivateHolding(context) {
    //ToDo
    String message = '';
    if(privatePurchasedPriceTextEditingController.text.isEmpty) {
      message = 'purchased price is required field!';
    }

    if(message.isEmpty) return true;

    Utils.showTranslatedToast(context, message);
    return false;
  }

  _addPrivateAssetHolding(context) {
    setAddingHoldingLoadingState(true);
    // _holdingsScreenBloc.addPrivateAssetHolding(
    //   addPrivateAssetHoldings: AddPrivateAssetHoldingModel(
    //       apiToken: _holdingsScreenBloc.currentUser?.apiToken??'',
    //       assetId: '4', //ToDo
    //       purchasedPrice: privatePurchasedPriceTextEditingController.text,
    //       quantity: '2', //ToDo
    //       source: 'test', //ToDo
    //     verified: '1', //ToDo
    //     purchasedAt: DateTime.now().toString().substring(0, 10),
    //   ),
    //   onData: (holding) => _onHoldingAddingSucceed(context, holding),
    //   onError: (message) => _onHoldingAddingFailed(context, message),
    // );
  }

  _onHoldingAddingSucceed(context, PrivateAssetModel holding) {
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

  _onHoldingAddingFailed(context, String message) {
    setAddingHoldingLoadingState(false);
    Utils.showTranslatedToast(context, message);
  }

  disposeStreams() {
    holdingsTypeController.close();
    selectedPrivateCompanyController.close();
    selectedAssetTypesController.close();
    addingPersonalAssetStagesController.close();
    selectedPersonalAssetCategoryController.close();
    selectedPersonalAssetProperetyTypeController.close();
    personalAcquisitionDateController.close();
    validateAddPersonalAssetInfoController.close();
    pickedPhotoAssetsController.close();
    selectedPersonalAssetController.close();
    selectedPersonalAssetNftSecuredController.close();
    selectedPersonalAssetCollectionController.close();
    selectedPersonalAssetTierController.close();
    selectedPersonalAssetSetSeriesController.close();
    addingHoldingLoadingStateController.close();
    _holdingsScreenBloc.disposeStreams();
  }
}