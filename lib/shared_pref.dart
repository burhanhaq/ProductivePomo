import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SharedPref {
  read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return json.decode(prefs.getString(key.toLowerCase()));
  }

  save(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key.toLowerCase(), json.encode(value));
  }

  remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key.toLowerCase());
  }

  removeAll() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  getKeys() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getKeys().toList();
  }

  get() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> keys = prefs.getKeys().toList();

    print('-------All keys: $keys');

    List<dynamic> fullList = [];
    for (int i = 0; i < keys.length; i++) {
//      fullList.add(prefs.getString(keys[i])); //json.decode(prefs.getString(keys[i])));
      fullList.add(json.decode(prefs.getString(keys[i])));
    }



    return fullList;
  }
}