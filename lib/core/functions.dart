import 'package:alladin/core/data_types.dart';
import 'package:alladin/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:alladin/cart/cart.dart';

//General Widgets
AppBar appBar(BuildContext context, String title) {
  return AppBar(
    title: Text('Alladin - $title'),
    actions: [
      IconButton(
          onPressed: () => Navigator.pushNamed(context, CartScreen.routeName),
          icon: const Icon(Icons.shopping_basket)),
      IconButton(
          onPressed: () =>
              Navigator.pushNamed(context, SettingsScreen.routeName),
          icon: const Icon(Icons.settings)),
    ],
  );
}

//Products
String productPrice(Product product, Options options) {
  return "${product.price} ${options.currency}";
}

String displayPrice(double price, String currency) {
  return "$price $currency";
}
