import 'package:flutter/material.dart';
import 'package:flutter_shop_app/dummy/products.dart';
import 'package:flutter_shop_app/models/product.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _products = loadedProducts;

  List<Product> get products {
    return [..._products];
  }

  void add() {
    //Product product) {
    // _products.add(product);
    notifyListeners();
  }
}
