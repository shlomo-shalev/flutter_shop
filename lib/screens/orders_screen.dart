// packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// providers
import 'package:flutter_shop_app/providers/orders_provider.dart';
// widgets
import 'package:flutter_shop_app/widgets/order_block.dart';
import 'package:flutter_shop_app/widgets/app_drawer.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final OrdersProvider orders = Provider.of<OrdersProvider>(context);
    final List<Order> ordersList = orders.items.values.toList();
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Your orders'),
      ),
      body: ListView.builder(
        itemCount: orders.items.length,
        itemBuilder: (_, i) => OrderBlock(ordersList[i]),
      ),
    );
  }
}
