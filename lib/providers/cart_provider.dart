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

  Map toMap() {
    return {
      'id': id,
      'item': item.toMap(),
      'quantity': quantity,
      'price': price,
    };
  }
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

  void addItemOrUpdateQuantity(ProductProvider product) {
    if (_items.containsKey(product.id)) {
      _updateQuantity(product);
    } else {
      _addItem(product);
    }
    notifyListeners();
  }

  void removeItemOrSubtractQuantity(ProductProvider product) {
    if (_items.containsKey(product.id)) {
      if ((_items[product.id] as CartItem).quantity > 1) {
        _subtractQuantity(product);
      } else {
        _items.remove(product.id);
      }
      notifyListeners();
    }
  }

  void _updateQuantity(ProductProvider product) {
    _items.update(
        product.id,
        (CartItem cartItem) => CartItem(
              id: cartItem.id,
              item: cartItem.item,
              quantity: cartItem.quantity + 1,
              price: cartItem.price,
            ));
  }

  void _subtractQuantity(ProductProvider product) {
    _items.update(
        product.id,
        (CartItem cartItem) => CartItem(
              id: cartItem.id,
              item: cartItem.item,
              quantity: cartItem.quantity - 1,
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

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
