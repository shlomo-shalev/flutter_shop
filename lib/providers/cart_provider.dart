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
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get count {
    return _items.length;
  }

  double get total {
    double total = 0.0;
    _items.forEach((key, CartItem cartItem) =>
        total += cartItem.price * cartItem.quantity);
    return total;
  }

  void toggleItem(ProductProvider product) {
    if (_items.containsKey(product.id)) {
      _updateQuantityItem(product);
    } else {
      _addItem(product);
    }
    notifyListeners();
  }

  void _updateQuantityItem(ProductProvider product) {
    _items.update(
        product.id,
        (CartItem cartItem) => CartItem(
              id: cartItem.id,
              item: cartItem.item,
              quantity: cartItem.quantity + 1,
              price: cartItem.price,
            ));
  }

  void _addItem(ProductProvider product) {
    _items[product.id] = CartItem(
      id: DateTime.now().toString(),
      item: product,
      quantity: 1,
      price: product.price,
    );
    // _items.putIfAbsent(
    //   product.id,
    //   () => CartItem(
    //     id: DateTime.now().toString(),
    //     item: product,
    //     quantity: 1,
    //     price: product.price,
    //   ),
    // );
  }

  void remove(CartItem cartItem) {
    _items.removeWhere(
        (key, CartItem localCartItem) => cartItem.id == localCartItem.id);
    notifyListeners();
  }
}
