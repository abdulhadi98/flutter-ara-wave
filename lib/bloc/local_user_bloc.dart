import 'package:wave_flutter/models/user_model.dart';
import 'package:wave_flutter/storage/data_store.dart';

class LocalUserBloc {
  final DataStore _dataStore;

  LocalUserBloc({required dataStore}): _dataStore = dataStore {
    getUser();
  }

  UserModel? get currentUser => _dataStore.userModel;
  getUser() async => _dataStore.getUser();
  setUser(UserModel user) async => _dataStore.setUser(user);
}