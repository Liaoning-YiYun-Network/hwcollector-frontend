import 'package:shared_preferences/shared_preferences.dart';

// 存储数据
Future<void> saveData(String key, String value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(key, value);
}

// 读取数据
Future<String?> readData(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? value = prefs.getString(key);
  return value;
}