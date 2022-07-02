import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/cart_provider.dart';
import 'package:flutter_shop_app/providers/orders_provider.dart';
import 'package:flutter_shop_app/widgets/cart_item_block.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  static const routeName = '/cart';

  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _isLoad = false;

  @override
  Widget build(BuildContext context) {
    final CartProvider cart = Provider.of<CartProvider>(context);
    final cartItemsList = cart.items.values.toList();
    final ScaffoldMessengerState scaffoldMessenger =
        ScaffoldMessenger.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your cart'),
      ),
      body: _isLoad
          ? SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const <Widget>[
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'saving order, please wait...',
                  ),
                ],
              ),
            )
          : Column(
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
                            style:
                                Theme.of(context).primaryTextTheme.titleSmall,
                          ),
                        ),
                        TextButton(
                          onPressed: cart.total <= 0
                              ? null
                              : () async {
                                  setState(() {
                                    _isLoad = true;
                                  });
                                  final String orderId =
                                      await Provider.of<OrdersProvider>(context,
                                              listen: false)
                                          .addOrder(
                                    cart.items.values.toList(),
                                    cart.total,
                                  );
                                  cart.clear();
                                  setState(() {
                                    _isLoad = false;
                                  });
                                  scaffoldMessenger.clearSnackBars();
                                  scaffoldMessenger.showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'order is saved, order number is $orderId',
                                      ),
                                    ),
                                  );
                                },
                          child: const Text(
                            'ORDER NOW',
                          ),
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
