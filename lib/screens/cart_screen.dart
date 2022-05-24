import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/cart_provider.dart';
import 'package:flutter_shop_app/providers/orders_provider.dart';
import 'package:flutter_shop_app/widgets/cart_item_block.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CartProvider cart = Provider.of<CartProvider>(context);
    final cartItemsList = cart.items.values.toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: <Widget>[
                  const Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  const Spacer(),
                  Chip(
                    backgroundColor: Theme.of(context).primaryColor,
                    label: Text(
                      '\$${cart.total.toStringAsFixed(2)}',
                      style: Theme.of(context).primaryTextTheme.titleSmall,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Provider.of<OrdersProvider>(context, listen: false)
                          .addOrder(
                        cart.items.values.toList(),
                        cart.total,
                      );
                      cart.clear();
                    },
                    child: const Text('ORDER NOW'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (_, index) =>
                  CartItemBlock(cartItem: cartItemsList[index]),
              itemCount: cart.count,
            ),
          ),
        ],
      ),
    );
  }
}
