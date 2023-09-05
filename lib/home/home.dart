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
                  //print(snapshot);
                  if (snapshot.hasData) {
                    return Column(
                      children: snapshot.data![0].map((Product e) {
                        return ListTile(
                          title: Text(e.name),
                          trailing: Text(productPrice(e, snapshot.data![1])),
                          onTap: () {
                            Navigator.pushNamed(
                                context, ProductDetail.routeName,
                                arguments: ProductScreenArguments(e.id));
                          },
                        );
                      }).toList(),
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
}
