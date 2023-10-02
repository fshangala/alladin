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
  Options options = Options();
  Cart cart = Cart();
  bool initialized = false;

  void _initialize(ProductScreenArguments args) {
    if (!initialized) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return const Dialog(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          });
      SharedPreferences.getInstance().then((instance) {
        Navigator.pop(context);
        setState(() {
          options = Options.fromSharedPreferences(instance);
          cart = Cart.fromSharedPreferences(instance);
          initialized = true;
        });
      });
    }
  }

  Column _geProduct(String id) {
    var product = Product(name: 'Product');
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return const Dialog(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
    Product.getById(id).then((value) {
      Navigator.pop(context);
      product = product;
    });
    return Column(
      children: [
        Center(
          child: Text(product.name),
        ),
        Text(product.description),
        Row(
          children: [
            const Expanded(child: Text('Price')),
            Text(productPrice(product, options))
          ],
        ),
        TextButton(
            onPressed: () {
              setState(() {
                cart.addProduct(product, 1);
                SharedPreferences.getInstance()
                    .then((instance) => cart.toSharedPreferences(instance));
              });
            },
            child: const Text('Add To Cart'))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as ProductScreenArguments;
    _initialize(args);
    return Container(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [_geProduct(args.id)],
      ),
    );
  }
}
