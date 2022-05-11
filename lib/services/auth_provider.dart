import 'package:wave_flutter/models/user_model.dart';
import 'api_provider.dart';
import 'urls_container.dart';

class AuthProvider extends ApiProvider {

  static const LOG_TAG = 'AuthProvider';

  Future<dynamic> signIn(UserModel user,) async {
    var body = {
      "email": user.email?.trim(),
      "password": user.password?.trim(),
    };
    return await postCallApi(
      url : UrlsContainer.emailLogin,
      body: body,
    );
  }

  Future<dynamic> logout(token,) async {
    final body = {
      "api_token": token,
    };
    return await postCallApi(
      url : UrlsContainer.logout,
      body: body,
    );
  }

  signUp(UserModel user,) async {
    var body = {
      "name": user.name?.trim(),
      "email": user.email?.trim(),
      "password": user.password?.trim(),
      "first_name": user.firstName?.trim(),
      "last_name": user.lastName?.trim(),
      "join_date": user.joinDate,
      "country": user.country,
      "city": user.city,
      "phone": user.phone?.trim(),
      "bio": null,
    };
    return await postCallApi(
      url : UrlsContainer.emailSignUp,
      body: body,
    );
  }

  forgotPassword(email,) async {
    var body = {
      "email": email?.trim(),
    };
    return await postCallApi(
      url : UrlsContainer.forgotPassword,
      body: body,
    );
  }

  resetPassword(email, oldPassword, newPassword) async {
    var body = {
      "email": email?.trim(),
      "old_password": oldPassword?.trim(),
      "new_password": newPassword?.trim(),
      "confirm_password": newPassword?.trim(),
    };
    return await postCallApi(
      url : UrlsContainer.resetPassword,
      body: body,
    );
  }
}
