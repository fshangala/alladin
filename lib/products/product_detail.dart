import 'package:alladin/core/functions.dart';
import 'package:flutter/material.dart';
import 'package:alladin/core/data_types.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail({super.key});
  static const routeName = '/product/detail';

  @override
  State<StatefulWidget> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  late Future<Options> options;
  late Future<Cart> cart;

  @override
  void initState() {
    super.initState();
    options = Options.fromSharedPreferences();
    cart = Cart.fromSharedPreferences();
  }

  FutureBuilder _renderProduct(String id) {
    return FutureBuilder(
        future: Future.wait([Product.getById(id), cart, options]),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                Center(
                  child: Text(snapshot.data![0].name),
                ),
                Text(snapshot.data![0].description),
                Row(
                  children: [
                    const Expanded(child: Text('Price')),
                    Text(productPrice(snapshot.data!, snapshot.data![2]))
                  ],
                ),
                TextButton(
                    onPressed: () {
                      setState(() {
                        snapshot.data![1].addProduct(snapshot.data!, 1);
                        SharedPreferences.getInstance().then((instance) =>
                            snapshot.data![1].toSharedPreferences(instance));
                      });
                    },
                    child: const Text('Add To Cart'))
              ],
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          } else {
            return const CircularProgressIndicator();
          }
        }));
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as ProductScreenArguments;
    return Container(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [_renderProduct(args.id)],
      ),
    );
  }
}
