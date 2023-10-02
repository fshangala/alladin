import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

List<Database> databases = [
  LocalDatabase(),
];

abstract class Database {
  static Database getDatabase() {
    return databases[0];
  }

  Future<List<Map<String, dynamic>>> get(String collection) async {
    var instance = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> results =
        jsonDecode(instance.getString(collection)!);
    if (collection == 'products' && results.isEmpty) {
      var dummies = [
        {'name': 'product1', 'description': 'description1', 'price': 1.0},
        {'name': 'product2', 'description': 'description2', 'price': 2.0},
        {'name': 'product3', 'description': 'description3', 'price': 3.0},
        {'name': 'product4', 'description': 'description4', 'price': 4.0},
      ];
      for (var dummy in dummies) {
        await setItem(collection, dummy);
      }
    }
    results = jsonDecode(instance.getString(collection)!);
    return results;
  }

  Future<Map<String, dynamic>?> getById(String collection, dynamic id) async {
    Map<String, dynamic>? data;
    var instance = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> results =
        jsonDecode(instance.getString(collection)!);
    for (var result in results) {
      if (result['id'] == id) {
        data = result;
        break;
      }
    }
    return data;
  }

  Future<void> setItem(String collection, Map<String, dynamic> data) async {
    var items = await get(collection);
    data['id'] = items.length + 1;
    items.add(data);
    var instance = await SharedPreferences.getInstance();
    instance.setString(collection, jsonEncode(items));
  }
}

class LocalDatabase extends Database {}
