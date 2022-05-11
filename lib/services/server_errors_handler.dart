import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:wave_flutter/helper/app_constant.dart';
import 'package:wave_flutter/helper/utils.dart';
import 'package:wave_flutter/models/errors_model.dart';
import 'package:wave_flutter/storage/data_store.dart';
import '../main.dart';

class ServerErrors {

  static ErrorModel? getError(ErrorModel error) {
    switch (int.parse(error.code!)) {
      case 400:
        if(error.message == 'You don\'t have permission to access this data'){
          GetIt.instance<DataStore>().deleteCurrentUserData();
          Navigator.pushAndRemoveUntil(AppConstant.context!, MaterialPageRoute(builder: (BuildContext context) => MyApp()), (Route<dynamic> route) => false);
        }
        else return ErrorModel(message: 'user_not_found');
        break;
      case 401:
        if(error.message?.contains('User doesn\'t have privilages')??false){
          return ErrorModel(message: 'user_have_not_privileges');
        } else if(Utils.isLoggedUserExist()) {
          GetIt.instance<DataStore>().deleteCurrentUserData();
          Navigator.pushAndRemoveUntil(AppConstant.context!, MaterialPageRoute(builder: (BuildContext context) => MyApp()), (Route<dynamic> route) => false);
        }
        return ErrorModel(message: 'wrong_credential');
      case 402:
        {
          if (error.message?.contains('The password must be at least 8 characters')??false)
            return ErrorModel(message: 'password_length_error');
          else if (error.message?.contains('The email has already been taken')??false) return ErrorModel(message: 'email_exists');
          break;
        }
      case 410:
        return ErrorModel(message: 'already_replied');
      case 411:
        return ErrorModel(message: 'phone_num_used');
      case 412:
        return ErrorModel(message: 'wrong_credential');
      case 413:
        return ErrorModel(message: 'username_used');
      case 415:
        return ErrorModel(message: 'constraint_failed');
      case 422:
        {
          if (error.message?.contains('username')??false)
            return ErrorModel(message: 'username_exists');
          else if (error.message?.contains('email')??false) return ErrorModel(message: 'email_exists');
          break;
        }
      case 454:
        {
          if (error.message?.contains('phonenumber')??false)
            return ErrorModel(message: 'phone_num_used');
          else if (error.message?.contains('email')??false) return ErrorModel(message: 'email_exists');
          break;
        }
      case 404:
      case 450:
        return ErrorModel(message: 'not_found');
      case 464:
        return ErrorModel(message: 'student_already_exist');

      default:
        return ErrorModel(message: 'something_went_wrong');
    }
  }

}
