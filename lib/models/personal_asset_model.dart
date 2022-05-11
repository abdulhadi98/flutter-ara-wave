import 'package:wave_flutter/models/image_model.dart';

class PersonalAssetModel{
  PersonalAssetModel({
    this.title,
    this.value,
    this.icon,
    this.type,
    this.year,
    this.quantity,
    this.currency,
    this.price,
    this.state,
    this.gallery,
    this.estMarketValue,
    this.downPayment,
    this.ownership,
    this.purchasePrice,
    this.acquisitionDate,
    this.purchaseDate,
    this.serialNumber,
    this.set,
    this.series,
    this.collection,
    this.statistics1,
    this.statistics2,
    this.statistics3,
    this.statistics4,
  });

  String? title;
  double? value;
  ImageModel? icon;
  String? type;
  String? year;
  int? quantity;
  double? currency;
  double? price;
  String? state;
  List<ImageModel>? gallery;
  int? estMarketValue;
  int? downPayment;
  int? ownership;
  String? acquisitionDate;
  String? purchaseDate;
  String? serialNumber;
  String? set;
  String? series;
  int? purchasePrice;
  String? collection;

  Statistics1? statistics1;
  Statistics2? statistics2;
  Statistics3? statistics3;
  Statistics4? statistics4;

}

class Statistics1{
  int? loanAmount;
  double? interestRate;
  int? amortization;
  int? outstandingBalance;
  int? termContract;
  int? monthlyPayments;

  Statistics1({
        this.loanAmount,
      this.interestRate,
      this.amortization,
      this.outstandingBalance,
      this.termContract,
      this.monthlyPayments,
      });
}

class Statistics2{
  String? propertyClass;
  int? buildingSize;
  int? lotSize;
  int? buildingEvaluation;
  int? taxAssessedValue;
  int? annualTaxAmount;
  int? yearBuilt;
  String? heatingCooling;
  String? interior;
  String? flooring;

  Statistics2({
    this.propertyClass,
    this.buildingSize,
    this.lotSize,
    this.buildingEvaluation,
    this.taxAssessedValue,
    this.annualTaxAmount,
    this.yearBuilt,
    this.heatingCooling,
    this.interior,
    this.flooring,
  });
}

class Statistics3{
  double? grossAnnualRentalIncome;
  int? annualRentGrowth;
  double? propertyExpenses;
  int? generalVacancyRate;
  int? expenseReserve;
  int? managementCommissions;
  int? annualExpenseGrowth;

  Statistics3({
    this.grossAnnualRentalIncome,
    this.annualRentGrowth,
    this.propertyExpenses,
    this.generalVacancyRate,
    this.expenseReserve,
    this.managementCommissions,
    this.annualExpenseGrowth,
  });
}

class Statistics4{
  double? capRate;
  double? leveredInternalRateOfReturn;
  double? averagedLeveredAnnualIncome;

  Statistics4({
    this.capRate,
    this.leveredInternalRateOfReturn,
    this.averagedLeveredAnnualIncome,
  });
}