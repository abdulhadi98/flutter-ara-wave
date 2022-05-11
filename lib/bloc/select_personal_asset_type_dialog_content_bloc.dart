import 'package:rxdart/rxdart.dart';
import 'package:wave_flutter/models/personal_asset_type.dart';
import 'package:wave_flutter/services/api_provider.dart';
import 'package:wave_flutter/services/data_resource.dart';

class SelectPersonalAssetTypeDialogContentBloc {
  final ApiProvider _apiProvider;
  SelectPersonalAssetTypeDialogContentBloc({required apiProvider,})
      : _apiProvider = apiProvider;

  static const String LOG_TAG = 'SelectPersonalAssetTypeDialogContentBloc';

  final _personalAssetTypesController = BehaviorSubject<DataResource<List<PersonalAssetTypeModel>>?>();
  get personalAssetTypesStream => _personalAssetTypesController.stream;
  DataResource<List<PersonalAssetTypeModel>>? getPersonalAssetTypes() => _personalAssetTypesController.value;
  setPersonalAssetTypes(DataResource<List<PersonalAssetTypeModel>>? dataRes) => _personalAssetTypesController.sink.add(dataRes);

  fetchPersonalAssetTypes() async {
    DataResource<List<PersonalAssetTypeModel>> dataRes;
    try {
      setPersonalAssetTypes(DataResource.loading());

      final response = await _apiProvider.getPersonalAssetTypes();
      List<PersonalAssetTypeModel> types = personalAssetTypeListModelFromJson(response,);

      if(types.isNotEmpty) dataRes = DataResource.success(types);
      else dataRes = DataResource.noResults();
      setPersonalAssetTypes(dataRes);
    } on FormatException catch (error) {
      print('$LOG_TAG: fetchPersonalAssetTypes() FormatException: ${error.message}');
      dataRes = DataResource.failure(error.message);
      setPersonalAssetTypes(dataRes);
    } catch (error) {
      print('$LOG_TAG: fetchPersonalAssetTypes() Exception: ${error.toString()}');
      dataRes = DataResource.failure('something_went_wrong');
      setPersonalAssetTypes(dataRes);
    }
  }

  dispose() {
    _personalAssetTypesController.close();
  }

}