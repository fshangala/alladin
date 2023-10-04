import 'package:alladin/products/product_detail.dart';
import 'package:flutter/material.dart';
import 'package:alladin/core/data_types.dart';
import 'package:alladin/core/functions.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const routeName = '/';

  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<HomeScreen> {
  late Future<List<Product>> products;
  late Future<Options> options;

  @override
  void initState() {
    super.initState();
    products = Product.get();
    options = Options.fromSharedPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, 'Home'),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            FutureBuilder(
                future: Future.wait([products, options]),
                builder: ((context, AsyncSnapshot<List<dynamic>> snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: _productsListTile(
                          snapshot.data![0], snapshot.data![1]),
                    );
                  } else if (snapshot.hasError) {
                    return Text('No products to show: ${snapshot.error!}');
                  }
                  return const CircularProgressIndicator();
                }))
          ],
        ),
      ),
    );
  }

  List<ListTile> _productsListTile(List<Product> products, Options options) {
    return products
        .map((e) => ListTile(
              title: Text(e.name),
              trailing: Text(displayPrice(e.price, options.currency)),
              onTap: () {
                Navigator.pushNamed(context, ProductDetail.routeName,
                    arguments: ProductScreenArguments(e.id));
              },
            ))
        .toList();
  }
}
