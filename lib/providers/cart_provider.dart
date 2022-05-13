// packages
import 'package:flutter/material.dart';
// providers
import 'package:flutter_shop_app/providers/product_provider.dart';

class CartItem {
  final String id;
  final ProductProvider item;
  final int quantity;
  final double price;

  CartItem({
    required this.id,
    required this.item,
    required this.quantity,
    required this.price,
  });
}

class CartProvider with ChangeNotifier {
  Map<String, CartItem> items = {};

  void toggleItem(ProductProvider product) {
    if (items.containsKey(product.id)) {
      _updateQuantityItem(product);
    } else {
      _addItem(product);
    }
  }

  void _updateQuantityItem(ProductProvider product) {
    items.update(
        product.id,
        (CartItem cartItem) => CartItem(
              id: cartItem.id,
              item: cartItem.item,
              quantity: cartItem.quantity + 1,
              price: cartItem.price,
            ));
  }

  void _addItem(ProductProvider product) {
    items[product.id] = CartItem(
      id: DateTime.now().toString(),
      item: product,
      quantity: 1,
      price: product.price,
    );
    // items.putIfAbsent(
    //   product.id,
    //   () => CartItem(
    //     id: DateTime.now().toString(),
    //     item: product,
    //     quantity: 1,
    //     price: product.price,
    //   ),
    // );
  }
}
