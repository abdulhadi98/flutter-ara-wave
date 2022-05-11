import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wave_flutter/bloc/price_history_bloc.dart';
import 'package:wave_flutter/helper/utils.dart';
import 'package:wave_flutter/models/company_info_step_model.dart';
import 'package:wave_flutter/models/price_history_model.dart';
import 'package:wave_flutter/models/price_history_step_model.dart';

class PriceHistoryStepDialogContentController {
  final PriceHistoryBloc _priceHistoryBloc;
  final Map<String, dynamic> _addPriceHistoryParams;
  PriceHistoryStepDialogContentController({required priceHistoryBloc, required addPriceHistoryParams,})
      : _priceHistoryBloc = priceHistoryBloc, _addPriceHistoryParams = addPriceHistoryParams;

  final BehaviorSubject<bool> _loadingController = BehaviorSubject.seeded(false);
  get loadingStream => _loadingController.stream;
  bool getLoadingState() => _loadingController.value;
  setLoadingState(bool state) => _loadingController.sink.add(state);

  TextEditingController currentMarketValueTextEditingController = TextEditingController();

  initYearPriceList({required int initialInvestmentYear,}) {
    int currentYear = DateTime.now().year;
    int yearDifference = currentYear - initialInvestmentYear;

    for(int i = 0; i <= yearDifference; i++) {
      int year = initialInvestmentYear + i;
      YearPrice yearPrice = YearPrice(
        year: year.toString(),
      );
      yearPriceList.add(yearPrice);
    }
  }

  initCurrentMarketValue(String currentMarketValue) {
    yearPriceList[yearPriceList.length- 1].price = currentMarketValue;
    currentMarketValueTextEditingController.text = currentMarketValue;
    _validateInputs();
  }

  List<YearPrice> yearPriceList = [];

  onMarketValueTextFieldChanged(String value) {
    _validateInputs();
  }

  onPriceValueTextFieldChanged(String value, int index) {
    yearPriceList[index].price = value;
    _validateInputs();
  }

  onYearValueTextFieldChanged(String value) {
    _validateInputs();
  }

  addPriceHistory({
    required PriceHistoryModel priceHistoryModel,
    required Function() onData,
    required Function(String message) onError,
  }) => _priceHistoryBloc.addPriceHistory(priceHistoryModel: priceHistoryModel, onData: onData, onError: onError);

  onFinishButtonClicked({
    required BuildContext context,
    required VoidCallback onDoneCallback,
  }) {
    setLoadingState(true);
    addPriceHistory(
      priceHistoryModel: createPriceHistoryModel(),
      onData: () => onDoneCallback(),
      onError: (message) => onAddPriceHistoryFailed(context, message),
    );
  }

  PriceHistoryModel createPriceHistoryModel() {
    return PriceHistoryModel(
      apiToken: _priceHistoryBloc.currentUserApiToken??'',
      assetId: _addPriceHistoryParams['asset_id'],
      assetType: _addPriceHistoryParams['asset_type'],
      yearPrice: yearPriceList,
    );
  }

  onAddPriceHistoryFailed(context, message) {
    setLoadingState(false);
    Utils.showToast(message);
  }

  bool _validateYearPrice() {
    return yearPriceList.every((element) => element.price?.isNotEmpty??false);
  }

  final BehaviorSubject<bool> _validationController = BehaviorSubject.seeded(false);
  get validationStream => _validationController.stream;
  bool getValidationState() => _validationController.value;
  setValidationState(bool type) => _validationController.sink.add(type);

  _validateInputs() {
    bool isValid = _validateYearPrice();
    setValidationState(isValid);
  }

  dispose() {
    _validationController.close();
    _loadingController.close();
    currentMarketValueTextEditingController.dispose();
  }
}
