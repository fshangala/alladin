import 'package:alladin/core/databases.dart';
import 'package:alladin/products/product_detail.dart';
import 'package:flutter/material.dart';
import 'package:alladin/core/data_types.dart';
import 'package:alladin/core/functions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const routeName = '/';

  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<HomeScreen> {
  List<Product> products = [];
  Options options = Options();
  bool initialized = false;

  void _fetchProducts() {
    products = Database.getDatabase(options.databaseName)!
        .getProducts()
        .map((e) => Product.fromMap(e))
        .toList();
  }

  void _initialize() {
    if (!initialized) {
      SharedPreferences.getInstance().then((instance) {
        setState(() {
          options = Options.fromSharedPreferences(instance);
          _fetchProducts();
          initialized = true;
        });
      });
    }
  }

  Column _renderProducts(BuildContext context) {
    if (products.isNotEmpty) {
      return Column(
        children: products.map((e) {
          return ListTile(
            title: Text(e.name),
            trailing: Text(productPrice(e, options)),
            onTap: () {
              Navigator.pushNamed(context, ProductDetail.routeName,
                  arguments: ProductScreenArguments(e.id));
            },
          );
        }).toList(),
      );
    } else {
      return const Column(
        children: [Text('No products to show.')],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _initialize();
    return Scaffold(
      appBar: appBar(context, 'Home'),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [_renderProducts(context)],
        ),
      ),
    );
  }
}
