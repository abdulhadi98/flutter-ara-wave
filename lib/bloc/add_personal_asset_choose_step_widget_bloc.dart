import 'package:rxdart/rxdart.dart';
import 'package:wave_flutter/helper/enums.dart';
import 'package:wave_flutter/models/personal_asset_type.dart';
import 'package:wave_flutter/models/personal_asset_type_step.dart';
import 'package:wave_flutter/services/api_provider.dart';
import 'package:wave_flutter/services/data_resource.dart';

class AddPersonalAssetChooseStepWidgetBloc {
  final ApiProvider _apiProvider;
  AddPersonalAssetChooseStepWidgetBloc({required apiProvider,})
      : _apiProvider = apiProvider;

  static const String LOG_TAG = 'AddPersonalAssetChooseStepWidgetBloc';

  fetchPersonalAssetTypeOptionChildren({
    required int typeId,
    required int? optionValueId,
    required Function(List<PersonalAssetTypeOptionModel> children) onData,
    required Function(String message) onError,
  }) async {
    try {
      final response = await _apiProvider.getPersonalAssetTypeOptionChildren(
          typeId: typeId,
          optionValueId: optionValueId,
      );
      List<PersonalAssetTypeOptionModel> types =
      List<PersonalAssetTypeOptionModel>.from(response.map((x) => PersonalAssetTypeOptionModel.fromJson(x)));
      onData(types);
    } on FormatException catch (error) {
      print('$LOG_TAG: fetchPersonalAssetTypeOptionChildren() FormatException: ${error.message}');
      onError(error.message);
      // dataRes = DataResource.failure(error.message);
      // setPersonalAssetTypeOptionChildren(dataRes);
    } catch (error) {
      print('$LOG_TAG: fetchPersonalAssetTypeOptionChildren() Exception: ${error.toString()}');
      onError(error.toString());
      // dataRes = DataResource.failure('something_went_wrong');
      // setPersonalAssetTypeOptionChildren(dataRes);
    }
  }

  dispose() {}

}