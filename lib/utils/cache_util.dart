import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

final String packageKey = 'life_record';

final String enableRecordConfirmKey = 'enableRecordConfirm';

class CacheUtil {
  static saveData(String key, dynamic data) async {
    var sf = await SharedPreferences.getInstance();
    Map packageMap = jsonDecode(sf.getString(packageKey)??'{}');
    packageMap[key] = data;
    sf.setString(packageKey, jsonEncode(packageMap));
  }

  static Future<dynamic> getData(String key) async {
    var sf = await SharedPreferences.getInstance();
    Map packageMap = jsonDecode(sf.getString(packageKey)??'{}');
    return packageMap[key];
  }

  clearData() async {
    var sf = await SharedPreferences.getInstance();
    sf.remove(packageKey);
  }
}