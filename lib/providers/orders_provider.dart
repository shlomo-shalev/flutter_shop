// packages
import 'dart:convert';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/product_provider.dart';
import 'package:http/http.dart' as http;
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
  Map<String, Order> _orders = {};
  String? authToken;

  Map<String, Order> get items {
    return {..._orders};
  }

  void updateAuthToken(String? token) {
    authToken = token;
  }

  Future<String> addOrder(List<CartItem> items, double total) async {
    final DateTime now = DateTime.now();
    final Uri url = Uri.parse(
        'https://flutter-shop-50c56-default-rtdb.firebaseio.com/orders.json?auth=$authToken');
    final http.Response response = await http.post(
      url,
      body: json.encode({
        'total': total,
        'items': items.map((item) => item.toMap()).toList(),
        'dateTime': now.toIso8601String(),
      }),
    );
    final Map data = json.decode(response.body);
    final String id = data['name'];
    _orders[id] = Order(
      id: id,
      total: total,
      items: items,
      dateTime: now,
    );
    notifyListeners();
    return id;
  }

  Future<void> fetchAndSetOrders() async {
    final Uri url = Uri.parse(
        'https://flutter-shop-50c56-default-rtdb.firebaseio.com/orders.json?auth=$authToken');
    final http.Response response = await http.get(url);
    final Map<String, dynamic> orders = json.decode(response.body) ?? {};
    final Map<String, Order> newOrders = {};
    orders.forEach((orderId, orderData) {
      newOrders[orderId] = Order(
        id: orderId,
        items: (orderData['items'] as List<dynamic>)
            .map<CartItem>(
              (item) => CartItem(
                id: item['id'],
                price: item['price'],
                quantity: item['quantity'],
                item: ProductProvider(
                  id: item['item']['id'],
                  title: item['item']['title'],
                  description: item['item']['description'],
                  price: item['item']['price'],
                  imageUrl: item['item']['imageUrl'],
                ),
              ),
            )
            .toList(),
        total: orderData['total'],
        dateTime: DateTime.parse(orderData['dateTime']),
      );
    });
    _orders = LinkedHashMap.fromEntries(newOrders.entries.toList().reversed);
    notifyListeners();
  }
}
