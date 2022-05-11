import 'package:get_it/get_it.dart';
import 'package:wave_flutter/models/user_model.dart';
import 'package:wave_flutter/services/auth_provider.dart';
import 'package:wave_flutter/storage/data_store.dart';

class AuthenticationBloc{

  final AuthProvider _authProvider;
  final DataStore _dataStore;
  AuthenticationBloc({required authProvider, required dataStore}):
        _authProvider = authProvider, _dataStore = dataStore;

  static const String LOG_TAG = 'AuthenticationBloc';

  signIn({required UserModel user, onData, onError}) async {
    try {
      var response = await _authProvider.signIn(user,);
      UserModel data = UserModel.fromJson(response);
      _dataStore.setUser(data).then((_) {
        _dataStore.getUser();
        onData();
      });
    } on FormatException catch (error) {
      onError(error.message);
      print('$LOG_TAG signIn FormatException: ${error.message}');
    } catch (error) {
      print('$LOG_TAG signIn Exception: ${error.toString()}');
      onError('something_went_wrong');
    }
  }

  logout() async {
    try {
      var response = await _authProvider.logout(_dataStore.userModel?.apiToken??'',);
    } on FormatException catch (error) {
      print('$LOG_TAG logout FormatException: ${error.message}');
    } catch (error) {
      print('$LOG_TAG logout Exception: ${error.toString()}');
    }
  }

  signUp({required UserModel user, onData, onError}) async {
    try {
      var response = await _authProvider.signUp(user,);
      UserModel data = UserModel.fromJson(response);
      GetIt.I<DataStore>().setUser(data).then((_) {
        GetIt.I<DataStore>().getUser();
        onData();
      });
    } on FormatException catch (error) {
      print('$LOG_TAG signUp FormatException: ${error.message}');
      onError(error.message);
    } catch (error) {
      print('$LOG_TAG signUp Exception: ${error.toString()}');
      onError('something_went_wrong');
    }
  }

  forgetPassword({required email, required onData, required onError}) async {
    try {
      var response = await _authProvider.forgotPassword(email,);
      onData();
    } on FormatException catch (error) {
      print('$LOG_TAG forgetPassword FormatException: ${error.message}');
      onError(error.message);
    } catch (error) {
      print('$LOG_TAG forgetPassword Exception: ${error.toString()}');
      onError('something_went_wrong');
    }
  }

  resetPassword({required email, required oldPassword, required newPassword, required onData, required onError}) async {
    try {
      var response = await _authProvider.resetPassword(
        email,
        oldPassword,
        newPassword,
      );
      onData();
    } on FormatException catch (error) {
      print('$LOG_TAG resetPassword FormatException: ${error.message}');
      onError(error.message);
    } catch (error) {
      print('$LOG_TAG resetPassword Exception: ${error.toString()}');
      onError('something_went_wrong');
    }
  }

}