import 'package:alladin/core/data_types.dart';
import 'package:alladin/core/functions.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});
  static const routeName = '/cart';

  @override
  State<StatefulWidget> createState() {
    return _CartState();
  }
}

class _CartState extends State<CartScreen> {
  late Future<Cart> cart;
  late Future<Options> options;

  @override
  void initState() {
    super.initState();
    cart = Cart.fromSharedPreferences();
    options = Options.fromSharedPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, 'Cart'),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            FutureBuilder<List<dynamic>>(
                future: Future.wait([cart, options]),
                builder: ((context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        Column(
                          children:
                              snapshot.data![0].items.map((CartItem cartItem) {
                            return ListTile(
                              leading: Text(cartItem.quantity.toString()),
                              title: Text(cartItem.product.name),
                              subtitle: Text(displayPrice(
                                  cartItem.product.price,
                                  snapshot.data![1].currency)),
                            );
                          }).toList(),
                        ),
                        Row(
                          children: [
                            const Expanded(child: Text('Total Price')),
                            Text(displayPrice(snapshot.data![0].totalPrice(),
                                snapshot.data![1].currency))
                          ],
                        )
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  } else {
                    return const CircularProgressIndicator();
                  }
                }))
          ],
        ),
      ),
    );
  }
}
