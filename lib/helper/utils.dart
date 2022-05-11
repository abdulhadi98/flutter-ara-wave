import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wave_flutter/local/app_local.dart';
import 'package:wave_flutter/storage/data_store.dart';
import 'package:collection/collection.dart';


class Utils {

  static Widget buildImage({required String? url, double? width , double? height, BoxFit fit=BoxFit.contain}) {

    Widget assetImage(resPath,){
      return Image.asset(
        resPath,
        fit: fit,
        width: width,
        height: height,
      );
    }

    if (url == null || url == '') {
      return assetImage('assets/images/placeholder.jpg',);
    }

    if (url.startsWith("http")) {
      return FadeInImage.assetNetwork(
        placeholder: 'assets/images/placeholder.jpg',
        image: url,
        fit: fit,
        width: width,
        height: height,
      );
    } else {
      return assetImage(url);
    }
  }

  static getImagesFromGallery({onData, onError}) async {
    try {
      var picker = ImagePicker();
      List<XFile>? images = await picker.pickMultiImage();
      onData(images);
    } catch (e) {
      print(e);
      onError();
    }
  }

  // static Future getImageFromCamera({onData, onError}) async {
  //   try {
  //     if (await permissionHandler.Permission.camera.request().isGranted) {
  //       var picker = ImagePicker();
  //       PickedFile file = await picker.getImage(source: ImageSource.camera);
  //       onData(file);
  //     }
  //   } catch (e) {
  //     print(e);
  //     onError();
  //   }
  // }

  static void showToast(String text) {
    Fluttertoast.showToast(
      msg: text,
    );
  }

  static void showTranslatedToast(context, String text) {
    Fluttertoast.showToast(
      msg: AppLocalizations.of(context).trans(text),
    );
  }

  static String enumToString<T>(T o) => o.toString().split('.').last;
  static T? enumFromString<T>(String key, List<T> values) => values.firstWhereOrNull((v) => key == enumToString(v!),);
  static int getEnumItemIndex<T>(Object o, List<T> values) => values.indexWhere((element) => element == o);
  static T getEnum<T>(int index, List<T> values) => values[index];

  static String getDateTimeValue(Locale local, String timeStamp) {
    try{
      final dateTime = DateTime.parse(timeStamp);
      final format = DateFormat.yMMMd(local.languageCode);
      return format.format(dateTime);
    } catch(e){
      return '';
    }
  }

  static String getDateTimeSignUpFormat(Locale local) {
    try{
      final format = DateFormat.yMd(local.languageCode);
      return format.format(DateTime.now());
    } catch(e){
      return '';
    }
  }

  static String getFormattedCount(var count){
    if (count < 9999) return count.toString();
    else if (count >= 9999 && count < 99999) return count.toString().substring(0, 1) + ' K';
    else return count.toString().substring(0, 2) + ' K';
  }

  static launchURL(myUrl) async {
    await launch(myUrl);
  }

  static bool isExist(value){
    return value != null && value != "";
  }

  static bool isLoggedUserExist() => (GetIt.I<DataStore>().userModel?.apiToken)!=null;

  static removeNullMapObjects(Map map) {
    map.removeWhere((key, value) => key == null || value == null);
  }

  static T? findItemById<T>(List? list, id){
    try{
      return list?.firstWhereOrNull((element) => element.id.toString()==id.toString(),);
    } catch(e){
      return null;
    }
  }

  static String convertFileToBase64(String path) {
    File file = File(path);
    List<int> fileInByte = file.readAsBytesSync();
    String fileInBase64 = base64Encode(fileInByte);
    return fileInBase64;
  }

  static String getFormattedNum(double? num) {
    String formattedNum = NumberFormat('###,###.00').format(num??0.0);
    return formattedNum;
  }
}

