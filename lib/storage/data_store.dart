import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wave_flutter/models/image_model.dart';
import 'package:wave_flutter/models/news_model.dart';
import 'package:wave_flutter/models/personal_asset_model.dart';
import 'package:wave_flutter/models/user_model.dart';

class DataStore {

  static const String _LANG_KEY = 'lang_key';
  static const String _USER_KEY = 'user_key';

  DataStore() {
    getUser();
    getLang();
  }

  String? _lang;

  String? get lang => _lang;

  Future<bool> setLang(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _lang = value;
    return prefs.setString(_LANG_KEY, value);
  }

  Future<String> getLang() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _lang = prefs.getString(_LANG_KEY) ?? "";
    return _lang!;
  }

  UserModel? _userModel;

  UserModel? get userModel => _userModel;

  Future<bool> setUser(UserModel value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _userModel = value;
    return prefs.setString(_USER_KEY, userModelToJson(value));
  }

  Future<UserModel?> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? prefsData = prefs.getString(_USER_KEY);
    _userModel = prefsData != null ? userModelFromJson(prefsData) : null;
    // _userModel = UserModel(
    //   userId: 1,
    //   primaryIdentifier: 'johnsmith97',
    //   user: User(
    //     name: "John Smith",
    //     image: ImageModel(
    //       url: 'https://cdn.pixabay.com/photo/2019/05/04/15/24/art-4178302_960_720.jpg',
    //       id: 1,
    //     ),
    //   ),
    // );
    return _userModel;
  }


  Future<bool> deleteCurrentUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _userModel = null;
    return await prefs.clear();
  }

  // List<AssetModel> getTempTopPerformingAssets() {
  //   List<AssetModel> assets = [];
  //   List<String> companies = [
  //     'Amazon',
  //     'Walmart',
  //     'Apple Inc.',
  //     'Facebook',
  //     'Nike'
  //   ];
  //   List<String> nicknames = ['AMZN', 'WT', 'AP', 'FB', 'NK'];
  //   List<double> currencies = [452.690, 412.20, 392.260, 372.275, 371.690];
  //   List<int> increments = [811, 600, 559, 520, 499];
  //   List<int> decrements = [811, 600, 559, 520, 499];
  //   for (int i = 0; i < companies.length; i++) {
  //     assets.add(AssetModel(
  //       company: companies[i],
  //       currency: currencies[i],
  //       nickname: nicknames[i],
  //       increment: increments[i],
  //       decrement: decrements[i],
  //       image: ImageModel(
  //         url: 'assets/icons/ic_building.png',
  //         id: i,
  //       ),
  //     ));
  //   }
  //   return assets;
  // }
  //
  //
  // List<AssetModel> getPrivateAssets() {
  //   List<AssetModel> assets = [];
  //   List<String> companies = [
  //     'Amazon',
  //     'Walmart',
  //     'Apple Inc.',
  //     'Facebook',
  //     'Nike'
  //   ];
  //   List<String> nicknames = ['AMZN', 'WT', 'AP', 'FB', 'NK'];
  //   String owner = 'NASDAQ';
  //   List<double> currencies = [452.690, 412.20, 392.260, 372.275, 371.690];
  //   List<int> increments = [811, 600, 559, 520, 499];
  //   List<int> decrements = [811, 600, 559, 520, 499];
  //   List<String> countries = [ 'USA', 'UAE', 'SY', 'CA', 'GE',];
  //   List<String> states = [
  //     'LosAngles',
  //     'Dubai',
  //     'Damascus',
  //     'Otawa',
  //     'Berlin',
  //   ];
  //   List<int> totals = [15000, 11000, 10500, 13600, 128465];
  //   List<int> types = [1, 0, 1, 0, 1,];
  //   List<Investment> investments = [
  //     Investment(
  //       title: '7625 Rose Ave',
  //       currency: 79578,
  //       incrementPercentage: 50,
  //       icon: ImageModel(
  //         url: 'assets/icons/ic_building.svg',
  //         id: 1,
  //       ),
  //       total: 1500000,
  //       country: 'USA',
  //       state: 'Los Angeles, CA',
  //       percentage: 10,
  //     ),
  //     Investment(
  //       title: '1626 W Broadway',
  //       currency: 2678900,
  //       incrementPercentage: 48,
  //       icon: ImageModel(
  //         url: 'assets/icons/ic_tower.svg',
  //         id: 1,
  //       ),
  //       total: 267890,
  //       country: 'Canada',
  //       state: 'Vancouver, BC',
  //       percentage: 10,
  //     ),
  //     Investment(
  //       title: '7625 Rose Ave',
  //       currency: 79578,
  //       incrementPercentage: 50,
  //       icon: ImageModel(
  //         url: 'assets/icons/ic_building.svg',
  //         id: 1,
  //       ),
  //       total: 1500000,
  //       country: 'USA',
  //       state: 'Los Angeles, CA',
  //       percentage: 10,
  //     ),
  //     Investment(
  //       title: '1626 W Broadway',
  //       currency: 2678900,
  //       incrementPercentage: 48,
  //       icon: ImageModel(
  //         url: 'assets/icons/ic_tower.svg',
  //         id: 1,
  //       ),
  //       total: 267890,
  //       country: 'Canada',
  //       state: 'Vancouver, BC',
  //       percentage: 10,
  //     ),
  //     Investment(
  //       title: '7625 Rose Ave',
  //       currency: 79578,
  //       incrementPercentage: 50,
  //       icon: ImageModel(
  //         url: 'assets/icons/ic_building.svg',
  //         id: 1,
  //       ),
  //       total: 1500000,
  //       country: 'USA',
  //       state: 'Los Angeles, CA',
  //       percentage: 10,
  //     ),
  //     Investment(
  //       title: '1626 W Broadway',
  //       currency: 2678900,
  //       incrementPercentage: 48,
  //       icon: ImageModel(
  //         url: 'assets/icons/ic_tower.svg',
  //         id: 1,
  //       ),
  //       total: 267890,
  //       country: 'Canada',
  //       state: 'Vancouver, BC',
  //       percentage: 10,
  //     ),
  //   ];
  //   List<int> sharesOwned = [2000, 1600, 1550, 1200, 900];
  //   List<int> totalAmountInvested = [15000, 11000, 10500, 13600, 128465];
  //   List<int> dividendYield = [ 9, 8, 5, 3, 2];
  //   List<int> marketCapitalization = [
  //     3200000,
  //     3100506,
  //     3100054,
  //     3000000,
  //     2809041,
  //   ];
  //   List<int> sharesOutstanding = [20100, 16020, 15450, 15200, 1900];
  //   List<String> shareClass = [
  //     'Preferred',
  //     'Preferred',
  //     'Preferred',
  //     'Preferred',
  //     'Preferred'
  //   ];
  //   int salesRevenue = 2653000;
  //   int costOfGoodsSold = 1591600;
  //   int grossProfit = 1061400;
  //   int operatingExpenses = 250000;
  //   int operatingIncome = 811400;
  //   int interestExpense = 48000;
  //   int netProfitBeforeTax = 763400;
  //   int taxExpense = 190850;
  //   int netProfitAfterTax = 572550;
  //   int preferredDividends = 160000;
  //   int earningsAvailableToCommonStockholders = 412550;
  //   double earningsPerShares = 20.63;
  //   final projectedEarnings = ProjectedEarnings(
  //     earningsBeforeTaxes: 491000,
  //     amortization: 200000,
  //     interest: 600000,
  //     projectedEbitda: 571000,
  //     incomeTaxes: 142750,
  //     cashFlowFromOperations: 428250,
  //     capex: 50000,
  //     nwc: 18000,
  //     discretionaryCashFlow: 360250,
  //     capitalizationRate: 9,
  //     transactionCashFlows: 360250,
  //     terminalValue5y: 5204007,
  //   );
  //   final projectedGrowth = ProjectedGrowth(
  //     salesRevenue: salesRevenue,
  //     costOfGoodsSold: costOfGoodsSold,
  //     grossProfit: grossProfit,
  //     operatingExpenses: operatingExpenses,
  //     operatingIncome: operatingIncome,
  //     interestExpense: interestExpense,
  //     netProfitBeforeTax: netProfitBeforeTax,
  //     taxExpense: taxExpense,
  //     netProfitAfterTax: netProfitAfterTax,
  //     preferredDividends: preferredDividends,
  //     earningsAvailableToCommonStockholders: earningsAvailableToCommonStockholders,
  //     depreciationExpense: 340750,
  //     netProfitMargin: 43.22,
  //   );
  //   final balanceSheetAnalysis = BalanceSheetAnalysis(
  //       cashAndCashEquivalents: 300000,
  //       inventory: 190000,
  //       otherCurrentAssets: 45000,
  //       totalCurrentAssets: 940000,
  //       ppeLessDepreciation: 120000000,
  //       otherNonCurrentAssets: 500000,
  //       totalAssets: 2640000,
  //       accountsPayableAccruedLiabilities: 35000,
  //       shortTermDebt: 104000,
  //       otherCurrentLiabilities: 370000,
  //       totalCurrentLiabilities: 509000,
  //       longTermDebt: 435000,
  //       otherNonCurrentLiabilities: 73000,
  //       totalLiabilities: 1017000,
  //       preferredStock: 200000,
  //       commonStock: 500000,
  //       retainedEarnings: 923,
  //       totalLiabilitiesAndEquity: 2640000,
  //   );
  //   final ratioAnalysis = RatioAnalysis(
  //       currentRatio: 1.85,
  //       quickRatio: 1.47,
  //       debtToTotalAssets: .20,
  //       debtToEquity: .33,
  //       timesInterestCoverageRatio: 16.90,
  //       inventoryTurnover: 8.39,
  //       totalAssetTurnover: 1.00,
  //       grossProfitMargin: 40.01,
  //       netProfitMargin: 21.58,
  //       returnOnEquity: 35.28,
  //       returnOnAssets: 21.69,
  //   );
  //   final intrinsicValue = IntrinsicValue(
  //       enterpriseValue: 4086319.39,
  //       cash: 239549.52,
  //       debt: 300000.00,
  //       equityValue: 4025868.91,
  //       equityValueShare: 100.65,
  //   );
  //   final marketValueVsIntrinsicValue = MarketValueVsIntrinsicValue(
  //       intrinsicValue: 80.00,
  //       currentMarketValue: 20.65,
  //       projectedUpside: 100.65,
  //       rateOfReturnTargetPriceUpside: 25.81,
  //   );
  //   final currentEnterpriseValue = CurrentEnterpriseValue(
  //       marketCap: 3200000.00,
  //       debt: 300000.00,
  //       cash: 239549.52,
  //       enterpriseValue: 3260450.48,
  //   );
  //
  //   for (int i = 0; i < companies.length; i++) {
  //     assets.add(AssetModel(
  //       owner: owner,
  //       company: companies[i],
  //       currency: currencies[i],
  //       nickname: nicknames[i],
  //       increment: increments[i],
  //       decrement: decrements[i],
  //       country: countries[i],
  //       total: totals[i],
  //       state: states[i],
  //       type: types[i],
  //       image: ImageModel(
  //         url: 'assets/icons/ic_building.png',
  //         id: i,
  //       ),
  //       investments: investments,
  //       sharesOwned: sharesOwned[i],
  //       totalAmountInvested: totalAmountInvested[i],
  //       dividendYield: dividendYield[i],
  //       marketCapitalization: marketCapitalization[i],
  //       sharesOutstanding: sharesOutstanding[i],
  //       shareClass: shareClass[i],
  //       salesRevenue: salesRevenue,
  //       costOfGoodsSold: costOfGoodsSold,
  //       grossProfit: grossProfit,
  //       operatingExpenses: operatingExpenses,
  //       operatingIncome: operatingIncome,
  //       interestExpense: interestExpense,
  //       netProfitBeforeTax: netProfitBeforeTax,
  //       taxExpense: taxExpense,
  //       netProfitAfterTax: netProfitAfterTax,
  //       preferredDividends: preferredDividends,
  //       earningsAvailableToCommonStockholders: earningsAvailableToCommonStockholders,
  //       earningsPerShares: earningsPerShares,
  //       projectedEarnings: projectedEarnings,
  //       projectedGrowth: projectedGrowth,
  //       balanceSheetAnalysis: balanceSheetAnalysis,
  //       ratioAnalysis: ratioAnalysis,
  //       intrinsicValue: intrinsicValue,
  //       marketValueVsIntrinsicValue: marketValueVsIntrinsicValue,
  //       currentEnterpriseValue: currentEnterpriseValue,
  //     ));
  //   }
  //   return assets;
  // }

  List<PersonalAssetModel> getPersonalAssets(){
    List<PersonalAssetModel> assets = [];

    List<String> titles = [
      'Lebron James - Feb 6 2020 Dunk',
      'LA Beach House',
      'Mercedes-Benz GLE SUV',
      'Rolex 654',
      'Tiffany Cushion 24 Carat',
    ];
    List<double> values = [1000, 795781, 60000, 9500, 34500];
    List<ImageModel> icons = [
      ImageModel(url: 'assets/icons/ic_nft.svg', id: 1,),
      ImageModel(url: 'assets/icons/ic_building.svg', id: 2,),
      ImageModel(url: 'assets/icons/ic_tower.svg', id: 3,),
      ImageModel(url: 'assets/icons/ic_price_tag.svg', id: 4,),
      ImageModel(url: 'assets/icons/ic_percentage.svg', id: 5,),
    ];
    List<String> types = [
      'Collectables',
      'Property',
      'Vehicle',
      'Time Piece',
      'Jewelry',
    ];
    List<String> years = [
      '2020',
      '2016',
      '2021',
      '2009',
      '2000',
    ];
    List<String> states = [
      'Dubai',
      'LosAngles',
      'Damascus',
      'Otawa',
      'Berlin',
    ];
    double price = 1500000;
    int quantity = 1;
    List<double> currencies = [
      500,
      200,
      85839,
      7000,
      65600,
    ];
    List<ImageModel> gallery = [
      ImageModel(url: 'https://cdn.pixabay.com/photo/2017/07/09/19/21/tree-2487889_960_720.jpg', id: 1,),
      ImageModel(url: 'https://cdn.pixabay.com/photo/2021/07/04/17/29/caterpillar-6387049_960_720.jpg', id: 2,),
      ImageModel(url: 'https://cdn.pixabay.com/photo/2020/11/22/20/12/schafer-dog-5767834_960_720.jpg', id: 3,),
      ImageModel(url: 'https://cdn.pixabay.com/photo/2021/05/14/22/11/faces-6254573_960_720.jpg', id: 4,),
      ImageModel(url: 'https://cdn.pixabay.com/photo/2021/05/25/12/59/mountain-6282389_960_720.jpg', id: 5,),
    ];
    List<ImageModel> collectableGallery = [
      ImageModel(url: 'assets/images/collectable_gallery_1.png', id: 1,),
      ImageModel(url: 'assets/images/collectable_gallery_2.png', id: 2,),
      ImageModel(url: 'assets/images/collectable_gallery_3.png', id: 3,),
    ];
    int estMarketValue = 1500000;
    int downPayment= 200000;
    int ownership = 100;
    int purchasePrice = 1000000;
    String acquisitionDate = 'June 31, 2016';
    String purchaseDate = 'June 31, 2016';
    String collection = 'NBA Top Shots';
    String serialNumber= '#43 / 59';
    String set= 'Legendary: From The Top';
    String series= 'Series 1';
    final statistics1 = Statistics1(
        loanAmount: 800000,
        interestRate: 2.5,
        amortization: 30,
        outstandingBalance: 704219,
        termContract: 5,
        monthlyPayments: 3185,
    );
    final statistics2 = Statistics2(
      propertyClass: 'Single Family - Residential',
      buildingSize: 4464,
      lotSize: 4017,
      buildingEvaluation: 255000,
      taxAssessedValue: 915000,
      annualTaxAmount: 6650,
      yearBuilt: 2003,
      heatingCooling: 'Central Air',
      interior: '3 Bedroom - 3.5 Bathroom',
      flooring: 'Hardwood',
    );
    final statistics3 = Statistics3(
      grossAnnualRentalIncome: 17.00,
      annualRentGrowth: 2,
      propertyExpenses: .5,
      generalVacancyRate: 4,
      expenseReserve: 2,
      managementCommissions: 11000,
      annualExpenseGrowth: 3,
    );
    final statistics4 = Statistics4(
      capRate: 7.21,
      leveredInternalRateOfReturn: 28.2,
      averagedLeveredAnnualIncome: 20.98,
    );

    for (int i = 0; i < titles.length; i++) {
      assets.add(PersonalAssetModel(
        title: titles[i],
        currency: currencies[i],
        state: i==1 ? states[i] : null,
        price: i==1 ? price : null,
        type: types[i],
        icon: icons[i],
        value: values[i],
        year: years[i],
        quantity: i==0 ? quantity : null,
        gallery: i==0 ? collectableGallery : gallery,
        estMarketValue: estMarketValue,
        downPayment: downPayment,
        ownership: ownership,
        purchasePrice: purchasePrice,
        acquisitionDate: acquisitionDate,
        purchaseDate: purchaseDate,
        collection: i==0 ? collection : null,
        statistics1: statistics1,
        statistics2: statistics2,
        statistics3: statistics3,
        statistics4: statistics4,
          serialNumber: serialNumber,
          set: set,
          series: series,
      ));
    }
    return assets;
  }

  List<NewsModel> getTopNews() => [];
  // List<NewsModel> getTopNews() {
  //   List<NewsModel> news = [];
  //   List<String> titles = [
  //     'Dapper Labs Leads \$1.14 Million Seed Round Investment',
  //     'Private companies believe they will have greater resilience',
  //     'A New Model to Spark innovation Inside Big Companies',
  //     'Why should private equity firms invest in retail?',
  //     'Will The U.S. Stock Market crashIn 2021?',
  //   ];
  //   List<String> descriptions = [
  //     'The pace of digital transformation exploded for 69% of privately-held businesses, a new Deloitte survey finds.',
  //     'Ten years ago, Erich Wood’s development company helped Topps launch its first digital trading card platform that would',
  //     'Impressed by the breakneck growth of digitally-native companies such as Amazon, Alphabet, and Alibaba',
  //     'Private equity firms have been behind the buyouts of some of the most well-knownnames in the retail sector and invested',
  //     'The Dow Jones, the S&P 500 and the Nasdaq have been extremely volatile in the last three weeks, reacting to news about',
  //   ];
  //   List<String> createdAt = [
  //     '6 Hours Ago',
  //     'May 15, 2021',
  //     'May 17, 2021',
  //     'May 17, 2021',
  //     'May 18, 2021',
  //   ];
  //   List<String> imageUrls = [
  //     'https://cdn.pixabay.com/photo/2017/07/09/19/21/tree-2487889_960_720.jpg',
  //     'https://cdn.pixabay.com/photo/2021/07/04/17/29/caterpillar-6387049_960_720.jpg',
  //     'https://cdn.pixabay.com/photo/2020/11/22/20/12/schafer-dog-5767834_960_720.jpg',
  //     'https://cdn.pixabay.com/photo/2021/05/14/22/11/faces-6254573_960_720.jpg',
  //     'https://cdn.pixabay.com/photo/2021/05/25/12/59/mountain-6282389_960_720.jpg',
  //   ];
  //   List<String> companies = [
  //     'Amazon',
  //     'Walmart',
  //     'Apple Inc.',
  //     'Facebook',
  //     'Nike'
  //   ];
  //   for (int i = 0; i < companies.length; i++) {
  //     news.add(NewsModel(
  //       id: i,
  //       title: titles[i],
  //       description: descriptions[i],
  //       createdAt: createdAt[i],
  //       company: companies[i],
  //       image: ImageModel(
  //         url: imageUrls[i],
  //         id: i,
  //       ),
  //     ));
  //   }
  //   return news;
  // }

}
