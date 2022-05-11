import 'dart:convert';

class AddPersonalAssetHoldingModel {

  AddPersonalAssetHoldingModel({
    required this.apiToken,
    required this.assetTypeId,
    required this.options,
    this.photos,
  });

  String apiToken;
  int assetTypeId;
  List<AddPersonalAssetOptionModel> options;
  List<String>? photos;

  Map<String, dynamic> toJson() => {
    "api_token": apiToken,
    "asset_type_id": assetTypeId,
    "options": json.encode(List<dynamic>.from(options.map((x) => x.toJson()))),
    "photos": json.encode(photos) /*==null ? null : List<dynamic>.from(photos!.map((x) => x.toJson()))*/,
  };
}

class AddPersonalAssetOptionModel {
  AddPersonalAssetOptionModel({
    required this.id,
    required this.type,
    required this.value,
  });

  int id;
  String type;
  String value;

  Map<String, dynamic> toJson() => {
    "option_id": id,
    "option_value_type": type,
    "option_value": value,
  };
}


// var map = {
//   "options": [
//     {"option_id":3, "option_value_type":"select", "option_value":5},
//     {"option_id":5, "option_value_type":"text", "option_value":"\$ 1000000"},
//     {"option_id":7, "option_value_type":"text", "option_value":"\$ 900000"},
//     {"option_id":13, "option_value_type":"text", "option_value":"my capin"}
//   ]
// };