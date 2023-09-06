import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

//General
class Options {
  String currency;
  String databaseName;

  Options({this.currency = 'ZMK', this.databaseName = 'local'});

  Map<String, dynamic> toMap() {
    return {'currency': currency, 'databaseName': databaseName};
  }

  static Options fromMap(Map<String, dynamic> data) {
    return Options(
        currency: data['currency'], databaseName: data['databaseName']);
  }

  static Options fromSharedPreferences(SharedPreferences instance) {
    return Options.fromMap(jsonDecode(instance.getString('options')!));
  }

  Future<bool> toSharedPreferences(SharedPreferences instance) {
    return instance.setString('options', jsonEncode(toMap()));
  }
}

//Products
class Product {
  String id;
  String name;
  String description;
  double price;

  Product(
      {this.id = '',
      required this.name,
      this.description = 'Product description',
      this.price = 0.0});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'description': description, 'price': price};
  }

  static Product fromMap(Map<String, dynamic> data) {
    return Product(
        id: data['id'],
        name: data['name'],
        description: data['description'],
        price: data['price']);
  }

  static Product getFromFirebase(String id) {
    return Product(
        id: id, name: 'Sample product', description: 'description', price: 0.0);
  }
}

class ProductScreenArguments {
  final String id;

  ProductScreenArguments(this.id);
}

//Cart
class CartItem {
  Product product;
  int quantity;
  CartItem(this.product, this.quantity);

  Map<String, dynamic> toMap() {
    return {'productId': product.id, 'quantity': quantity};
  }
}

class Cart {
  List<CartItem> items = [];

  Map<String, dynamic> toMap() {
    return {'items': items.map((e) => e.toMap())};
  }

  Future<bool> toSharedPreferences(SharedPreferences instance) {
    return instance.setString('cart', jsonEncode(toMap()));
  }

  static Cart fromSharedPreferences(SharedPreferences instance) {
    String? cartData = instance.getString('cart');
    var cartMap = jsonDecode(cartData!) as Map<String, dynamic>;
    var cart = Cart();
    cart.items = cartMap['items']
        .map((Map<String, dynamic> e) =>
            CartItem(Product.getFromFirebase(e['productId']), e['quantity']))
        .toList();
    return cart;
  }

  double totalPrice() {
    double price = 0.0;
    for (var item in items) {
      price += item.product.price * item.quantity;
    }
    return price;
  }

  void addProduct(Product product, int quantity) {
    var productFound = false;
    for (var i = 0; i < items.length; i++) {
      if (items[i].product.id == product.id) {
        productFound = true;
        items[i].quantity += quantity;
        break;
      }
    }
    if (!productFound) {
      items.add(CartItem(product, quantity));
    }
  }
}
