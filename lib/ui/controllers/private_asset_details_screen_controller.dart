import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wave_flutter/bloc/private_asset_details_screen_bloc.dart';
import 'package:wave_flutter/helper/enums.dart';

class PrivateAssetDetailsScreenController {

  final PrivateAssetDetailsScreenBloc _privateAssetDetailsScreenBloc;
  PrivateAssetDetailsScreenController({required privateAssetDetailsScreenBloc, }):
        _privateAssetDetailsScreenBloc = privateAssetDetailsScreenBloc;

  fetchResult() {
    _privateAssetDetailsScreenBloc.fetchPrivateAssets();
  }

  final BehaviorSubject<String?> incomeAnalysisYearsController = BehaviorSubject<String?>();
  get incomeAnalysisYearsStream => incomeAnalysisYearsController.stream;
  String? getIncomeAnalysisYears() => incomeAnalysisYearsController.value;
  setIncomeAnalysisYears(String? year) => incomeAnalysisYearsController.sink.add(year);

  final BehaviorSubject<String?> projectedEarningsYearsController = BehaviorSubject<String?>();
  get projectedEarningsYearsStream => projectedEarningsYearsController.stream;
  String? getProjectedEarningsYears() => projectedEarningsYearsController.value;
  setProjectedEarningsYears(String? year) => projectedEarningsYearsController.sink.add(year);

  final BehaviorSubject<String?> projectedGrowthYearsController = BehaviorSubject<String?>();
  get projectedGrowthYearsStream => projectedGrowthYearsController.stream;
  String? getProjectedGrowthYears() => projectedGrowthYearsController.value;
  setProjectedGrowthYears(String? year) => projectedGrowthYearsController.sink.add(year);

  final BehaviorSubject<String?> balanceSheetAnalysisYearsController = BehaviorSubject<String?>();
  get balanceSheetAnalysisYearsStream => balanceSheetAnalysisYearsController.stream;
  String? getBalanceSheetAnalysisYears() => balanceSheetAnalysisYearsController.value;
  setBalanceSheetAnalysisYears(String? year) => balanceSheetAnalysisYearsController.sink.add(year);

  final BehaviorSubject<String?> ratioAnalysisYearsController = BehaviorSubject<String?>();
  get ratioAnalysisYearsStream => ratioAnalysisYearsController.stream;
  String? getRatioAnalysisYears() => ratioAnalysisYearsController.value;
  setRatioAnalysisYears(String? year) => ratioAnalysisYearsController.sink.add(year);

  final BehaviorSubject<String?> intrinsicValueYearsController = BehaviorSubject<String?>();
  get intrinsicValueYearsStream => intrinsicValueYearsController.stream;
  String? getIntrinsicValueYears() => intrinsicValueYearsController.value;
  setIntrinsicValueYears(String? year) => intrinsicValueYearsController.sink.add(year);

  disposeStreams() {

  }
}