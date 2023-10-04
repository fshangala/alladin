import 'package:alladin/products/product_detail.dart';
import 'package:alladin/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:alladin/home/home.dart';
import 'package:alladin/cart/cart.dart';

void main() {
  runApp(const AlladinApp());
}

class AlladinApp extends StatelessWidget {
  const AlladinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alladin',
      routes: {
        HomeScreen.routeName: (context) => const HomeScreen(),
        ProductDetail.routeName: (context) => const ProductDetail(),
        CartScreen.routeName: (context) => const CartScreen(),
        SettingsScreen.routeName: (context) => const SettingsScreen()
      },
      initialRoute: '/',
    );
  }
}
