import 'package:alladin/core/data_types.dart';
import 'package:alladin/core/functions.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});
  static const routeName = '/cart';

  @override
  State<StatefulWidget> createState() {
    return _CartState();
  }
}

class _CartState extends State<CartScreen> {
  Cart cart = Cart();
  Options options = Options();
  bool initialized = false;

  void _initialize() {
    if (!initialized) {
      SharedPreferences.getInstance().then((instance) {
        setState(() {
          cart = Cart.fromSharedPreferences(instance);
          options = Options.fromSharedPreferences(instance);
          initialized = true;
        });
      });
    }
  }

  Column _renderCart() {
    return Column(
      children: [
        Column(
          children: cart.items.map((CartItem cartItem) {
            return ListTile(
              leading: Text(cartItem.quantity.toString()),
              title: Text(cartItem.product.name),
              subtitle:
                  Text(displayPrice(cartItem.product.price, options.currency)),
            );
          }).toList(),
        ),
        Row(
          children: [
            const Expanded(child: Text('Total Price')),
            Text(displayPrice(cart.totalPrice(), options.currency))
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    _initialize();
    return Scaffold(
      appBar: appBar(context, 'Cart'),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [_renderCart()],
        ),
      ),
    );
  }
}
