import 'package:alladin/core/data_types.dart';

List<Database> databases = [
  LocalDatabase('local'),
];

abstract class Database {
  abstract String name;

  static Database? getDatabase(String name) {
    Database? database;
    for (var db in databases) {
      if (db.name == name) {
        database = db;
        break;
      }
    }
    return database;
  }

  List<Map<String, dynamic>> getProducts() {
    return [
      'product1',
      'product2',
      'product3',
      'product4',
      'product5',
    ].map((e) => Product(name: e).toMap()).toList();
  }

  Map<String, dynamic> getProductById(String id) {
    return Product(name: 'product1').toMap();
  }
}

class LocalDatabase extends Database {
  @override
  String name;

  LocalDatabase(this.name);
}
