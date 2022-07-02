// packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// providers
import 'package:flutter_shop_app/providers/orders_provider.dart';
// widgets
import 'package:flutter_shop_app/widgets/order_block.dart';
import 'package:flutter_shop_app/widgets/app_drawer.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  Future? _ordersFuture;

  @override
  void initState() {
    _ordersFuture =
        Provider.of<OrdersProvider>(context, listen: false).fetchAndSetOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Your orders'),
      ),
      body: FutureBuilder(
        future: _ordersFuture,
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return SizedBox(
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
                    'importing orders...',
                  ),
                ],
              ),
            );
          } else {
            if (dataSnapshot.error == null) {
              return RefreshIndicator(
                onRefresh: () {
                  return Provider.of<OrdersProvider>(context, listen: false)
                      .fetchAndSetOrders();
                },
                child: Consumer<OrdersProvider>(builder: (ctx, orders, child) {
                  final List<Order> ordersList = orders.items.values.toList();
                  return ListView.builder(
                    itemCount: orders.items.length,
                    itemBuilder: (_, i) => OrderBlock(ordersList[i]),
                  );
                }),
              );
            } else {
              return const Center(
                child: Text('An error!!'),
              );
            }
          }
        },
      ),
    );
  }
}
