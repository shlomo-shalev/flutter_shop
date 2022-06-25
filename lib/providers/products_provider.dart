// packages
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// dummies
// import 'package:flutter_shop_app/dummy/products.dart';
// providers
import 'package:flutter_shop_app/providers/product_provider.dart';

class ProductsProvider with ChangeNotifier {
  List<ProductProvider> _products = []; //loadedProducts;

  List<ProductProvider> get products {
    return [..._products];
  }

  List<ProductProvider> get favoriteProducts {
    return _products.where((product) => product.isFavorite).toList();
  }

  ProductProvider findProduct(String id) {
    return _products.firstWhere((product) => product.id == id);
  }

  Future<void> fetchAndSetProducts() async {
    final Uri url = Uri.parse(
        'https://flutter-shop-50c56-default-rtdb.firebaseio.com/products.json');
    final http.Response response = await http.get(url);
    final Map<String, dynamic> products = json.decode(response.body) ?? {};
    final List<ProductProvider> newProducts = [];
    products.forEach((productId, productData) {
      newProducts.add(ProductProvider(
        id: productId,
        title: productData['title'],
        description: productData['description'],
        imageUrl: productData['imageUrl'],
        price: productData['price'],
        isFavorite: productData['isFavorite'],
      ));
    });
    _products = newProducts;
    notifyListeners();
  }

  Future<void> add(ProductProvider product) async {
    final Uri url = Uri.parse(
        'https://flutter-shop-50c56-default-rtdb.firebaseio.com/products.json');
    final http.Response response = await http.post(
      url,
      body: json.encode({
        'title': product.title,
        'description': product.description,
        'imageUrl': product.imageUrl,
        'price': product.price,
        'isFavorite': product.isFavorite,
      }),
    );
    final data = json.decode(response.body);
    _products.insert(
      0,
      ProductProvider(
        id: data['name'],
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
