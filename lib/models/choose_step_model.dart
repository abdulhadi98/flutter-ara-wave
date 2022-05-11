import 'package:wave_flutter/helper/enums.dart';
import 'package:wave_flutter/models/personal_asset_type.dart';
import 'package:wave_flutter/models/personal_asset_type_step.dart';

class ChooseStepModel {
  final AddPersonalAssetChooseStepType type;
  final PersonalAssetTypeOptionModel? option;
  final List<PersonalAssetTypeStep>? steps;

  ChooseStepModel({required this.type, this.option, this.steps});
}