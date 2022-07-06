// packages
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// dummies
// import 'package:flutter_shop_app/dummy/products.dart';
// providers
import 'package:flutter_shop_app/providers/product_provider.dart';
// exceptions
import 'package:flutter_shop_app/exceptions/http_exception.dart';

class ProductsProvider with ChangeNotifier {
  String? authToken;
  String? userId;
  List<ProductProvider> _products = []; //loadedProducts;

  void updateAuthToken(String? token, String? idOfUser) {
    authToken = token;
    userId = idOfUser;
  }

  List<ProductProvider> get products {
    return [..._products];
  }

  List<ProductProvider> get favoriteProducts {
    return _products.where((product) => product.isFavorite).toList();
  }

  ProductProvider findProduct(String id) {
    return _products.firstWhere((product) => product.id == id);
  }

  Future<void> fetchAndSetProducts([bool onlyOfThisUser = false]) async {
    final String filter =
        onlyOfThisUser ? 'orderBy="userId"&equalTo="$userId"' : '';
    String onlyUrl =
        'https://flutter-shop-50c56-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filter';
    final Uri url = Uri.parse(onlyUrl);
    final http.Response response = await http.get(url);
    final Map<String, dynamic> products = json.decode(response.body) ?? {};
    final List<ProductProvider> newProducts = [];

    Map<String, dynamic> favorites = {};
    final Uri favoritesUrl = Uri.parse(
        'https://flutter-shop-50c56-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$authToken');
    final http.Response favoriteResponse = await http.get(favoritesUrl);
    favorites = json.decode(favoriteResponse.body) ?? {};

    products.forEach((productId, productData) {
      newProducts.add(ProductProvider(
        id: productId,
        title: productData['title'],
        description: productData['description'],
        imageUrl: productData['imageUrl'],
        price: productData['price'],
        isFavorite: favorites[productId] ?? false,
      ));
    });
    _products = newProducts;
    notifyListeners();
  }

  Future<void> add(ProductProvider product) async {
    final Uri url = Uri.parse(
        'https://flutter-shop-50c56-default-rtdb.firebaseio.com/products.json?auth=$authToken');
    final http.Response response = await http.post(
      url,
      body: json.encode({
        'title': product.title,
        'description': product.description,
        'imageUrl': product.imageUrl,
        'price': product.price,
        'isFavorite': product.isFavorite,
        'userId': userId,
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

  Future<void> update(String id, ProductProvider product) async {
    final productIndex =
        _products.indexWhere((loopProduct) => loopProduct.id == product.id);
    final Uri url = Uri.parse(
        'https://flutter-shop-50c56-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');
    await http.patch(
      url,
      body: json.encode({
        'title': product.title,
        'description': product.description,
        'imageUrl': product.imageUrl,
        'price': product.price,
      }),
    );
    _products[productIndex] = product;
    notifyListeners();
  }

  Future<void> delete(String id) async {
    final productIndex = _products.indexWhere((product) => product.id == id);
    ProductProvider? product = _products[productIndex];
    _products.removeAt(productIndex);
    notifyListeners();
    try {
      final Uri url = Uri.parse(
          'https://flutter-shop-50c56-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');
      final response = await http.delete(url);
      if (response.statusCode >= 400) {
        throw HttpException('Could not delete product.');
      }
    } catch (error) {
      _products.insert(productIndex, product);
      notifyListeners();
      product = null;
      throw HttpException(error.toString());
    }
    product = null;
  }
}
