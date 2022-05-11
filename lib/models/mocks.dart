
import 'image_model.dart';
import 'personal_asset_model.dart';

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
