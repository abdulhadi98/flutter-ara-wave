import 'package:rxdart/rxdart.dart';
import 'package:wave_flutter/services/api_provider.dart';

import 'local_user_bloc.dart';

class AddPersonalAssetStepDialogContentBloc {
  final ApiProvider _apiProvider;
  final LocalUserBloc _localUserBloc;
  AddPersonalAssetStepDialogContentBloc({required apiProvider, required localUserBloc})
      : _apiProvider = apiProvider, _localUserBloc = localUserBloc;

  static const String LOG_TAG = 'AddPersonalAssetStepDialogContentBloc';
  //
  // final _personalAssetTypesController = BehaviorSubject<DataResource<List<PersonalAssetTypeModel>>?>();
  // get personalAssetTypesStream => _personalAssetTypesController.stream;
  // DataResource<List<PersonalAssetTypeModel>>? getPersonalAssetTypes() => _personalAssetTypesController.value;
  // setPersonalAssetTypes(DataResource<List<PersonalAssetTypeModel>>? dataRes) => _personalAssetTypesController.sink.add(dataRes);
  //
  // fetchPersonalAssetTypes() async {
  //   DataResource<List<PersonalAssetTypeModel>> dataRes;
  //   try {
  //     setPersonalAssetTypes(DataResource.loading());
  //
  //     final response = await _apiProvider.getPersonalAssetTypes();
  //     List<PersonalAssetTypeModel> types = personalAssetTypeListModelFromJson(response,);
  //
  //     if(types.isNotEmpty) dataRes = DataResource.success(types);
  //     else dataRes = DataResource.noResults();
  //     setPersonalAssetTypes(dataRes);
  //   } on FormatException catch (error) {
  //     print('$LOG_TAG: fetchPersonalAssetTypes() FormatException: ${error.message}');
  //     dataRes = DataResource.failure(error.message);
  //     setPersonalAssetTypes(dataRes);
  //   } catch (error) {
  //     print('$LOG_TAG: fetchPersonalAssetTypes() Exception: ${error.toString()}');
  //     dataRes = DataResource.failure('something_went_wrong');
  //     setPersonalAssetTypes(dataRes);
  //   }
  // }
  //
  // dispose() {
  //   _personalAssetTypesController.close();
  // }
}