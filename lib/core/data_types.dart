import 'dart:convert';
import 'package:alladin/core/databases.dart';
import 'package:shared_preferences/shared_preferences.dart';

//General
class Options {
  String currency;

  Options({this.currency = 'ZMK'});

  Map<String, dynamic> toMap() {
    return {'currency': currency};
  }

  static Options fromMap(Map<String, dynamic> data) {
    return Options(currency: data['currency']);
  }

  static Future<Options> fromSharedPreferences() async {
    var instance = await SharedPreferences.getInstance();
    var options = instance.getString('options');
    if (options == null) {
      return Options();
    } else {
      Map<String, dynamic> optionsMap = jsonDecode(options);
      return Options.fromMap(optionsMap);
    }
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

  static Future<List<Product>> get() async {
    var result = await Database.getDatabase().get('products');
    return result.map((e) => Product.fromMap(e)).toList();
  }

  static Future<Product?> getById(String id) async {
    var result = await Database.getDatabase().getById('products', id);
    if (result != null) {
      return Product.fromMap(result);
    } else {
      return null;
    }
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

  static Cart fromMap(Map<String, dynamic> data) {
    var cart = Cart();
    cart.items = data['items'].map((Map<String, dynamic> e) {
      Product? product;
      Product.getById(e['productId']).then((value) {
        product = value;
      });
      return CartItem(product!, e['quantity']);
    }).toList();
    return cart;
  }

  Future<bool> toSharedPreferences(SharedPreferences instance) {
    return instance.setString('cart', jsonEncode(toMap()));
  }

  static Future<Cart> fromSharedPreferences() async {
    var instance = await SharedPreferences.getInstance();
    String? cartData = instance.getString('cart');
    if (cartData == null) {
      return Cart();
    } else {
      Map<String, dynamic> cartMap = jsonDecode(cartData);
      return Cart.fromMap(cartMap);
    }
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
    SharedPreferences.getInstance().then((instance) {
      toSharedPreferences(instance);
    });
  }
}
