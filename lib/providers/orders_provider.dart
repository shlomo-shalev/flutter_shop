// packages
import 'package:flutter/material.dart';
// providers
import 'package:flutter_shop_app/providers/cart_provider.dart';

class Order {
  final String id;
  final double total;
  final List<CartItem> items;
  final DateTime dateTime;

  Order({
    required this.id,
    required this.total,
    required this.items,
    required this.dateTime,
  });
}

class OrdersProvider with ChangeNotifier {
  final Map<String, Order> _orders = {};

  Map<String, Order> get items {
    return {..._orders};
  }

  void addOrder(List<CartItem> items, double total) {
    final DateTime now = DateTime.now();
    final String id = now.toString();
    _orders[id] = Order(
      id: id,
      total: total,
      items: items,
      dateTime: now,
    );
    notifyListeners();
  }
}
