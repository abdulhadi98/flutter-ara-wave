import 'dart:convert';

import 'package:wave_flutter/models/personal_asset_type.dart';

class PersonalAssetType {
  int id;
  String name;
  List<PersonalAssetTypeStep> steps;
  PersonalAssetType({
    required this.id,
    required this.name,
    required this.steps,
  });


  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "steps": List.of(steps.map((x) => x.toJson())),
  };
}

class PersonalAssetTypeStep {
  List<PersonalAssetTypeOptionModel> options;

  PersonalAssetTypeStep({
    this.options = const [],
  });

  Map<String, dynamic> toJson() => {
    "options": List.of(options.map((x) => x.toJson())),
  };
}
