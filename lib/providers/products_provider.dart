import 'package:flutter/material.dart';
import 'package:flutter_shop_app/dummy/products.dart';
import 'package:flutter_shop_app/providers/product.dart';

class ProductsProvider with ChangeNotifier {
  final List<Product> _products = loadedProducts;

  List<Product> get products {
    return [..._products];
  }

  Product findProduct(String id) {
    return _products.firstWhere((product) => product.id == id);
  }

  void add(Product product) {
    // _products.add(product);
    notifyListeners();
  }
}
