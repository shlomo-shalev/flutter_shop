// packages
import 'package:flutter/material.dart';
// dummies
import 'package:flutter_shop_app/dummy/products.dart';
// providers
import 'package:flutter_shop_app/providers/product_provider.dart';

class ProductsProvider with ChangeNotifier {
  final List<ProductProvider> _products = loadedProducts;

  List<ProductProvider> get products {
    return [..._products];
  }

  List<ProductProvider> get favoriteProducts {
    return _products.where((product) => product.isFavorite).toList();
  }

  ProductProvider findProduct(String id) {
    return _products.firstWhere((product) => product.id == id);
  }

  void add(ProductProvider product) {
    _products.insert(
      0,
      ProductProvider(
        id: DateTime.now().toString(),
        title: product.title,
        description: product.description,
        imageUrl: product.imageUrl,
        price: product.price,
      ),
    );
    notifyListeners();
  }

  void update(String id, ProductProvider product) {
    final productIndex =
        _products.indexWhere((loopProduct) => loopProduct.id == product.id);
    _products[productIndex] = product;
    notifyListeners();
  }

  void delete(String id) {
    _products.removeWhere((product) => product.id == id);
    notifyListeners();
  }
}
