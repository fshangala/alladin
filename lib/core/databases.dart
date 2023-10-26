import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

List<Database> databases = [
  LocalDatabase(),
];

abstract class Database {
  final List<Map<String, dynamic>> mockData = [
    {
      'id': 'mock1',
      'name': 'product1',
      'description': 'description1',
      'price': 100.0
    },
    {
      'id': 'mock2',
      'name': 'product2',
      'description': 'description2',
      'price': 200.0
    },
    {
      'id': 'mock3',
      'name': 'product3',
      'description': 'description3',
      'price': 300.0
    },
    {
      'id': 'mock4',
      'name': 'product4',
      'description': 'description4',
      'price': 400.0
    },
  ];

  static Database getDatabase() {
    return databases[0];
  }

  Future<List<Map<String, dynamic>>> get(String collection) async {
    var instance = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> results = [];
    var resultsData = instance.getString(collection);
    if (resultsData != null) {
      results = jsonDecode(resultsData);
    } else {
      /*if (collection == 'products') {
        var dummies = [
          {'name': 'product1', 'description': 'description1', 'price': 1.0},
          {'name': 'product2', 'description': 'description2', 'price': 2.0},
          {'name': 'product3', 'description': 'description3', 'price': 3.0},
          {'name': 'product4', 'description': 'description4', 'price': 4.0},
        ];
        for (var dummy in dummies) {
          await setItem(collection, dummy);
        }
        results = await get(collection);
      }*/
      results = mockData;
    }

    return results;
  }

  Future<Map<String, dynamic>?> getById(String collection, dynamic id) async {
    Map<String, dynamic>? data;
    var instance = await SharedPreferences.getInstance();
    var resultsData = instance.getString(collection);
    if (resultsData != null) {
      List<Map<String, dynamic>> results = jsonDecode(resultsData);
      for (var result in results) {
        if (result['id'] == id) {
          data = result;
          break;
        }
      }
    }
    if (data == null) {
      for (var element in mockData) {
        if (element['id'] == id) {
          data = element;
          break;
        }
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
