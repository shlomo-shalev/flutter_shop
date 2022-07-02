// packages
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// exceptions
import 'package:flutter_shop_app/exceptions/http_exception.dart';

class ProductProvider with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  ProductProvider({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  Map toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
    };
  }

  Future<void> toogleFavoriteStatus() async {
    isFavorite = !isFavorite;
    notifyListeners();
    try {
      final Uri url = Uri.parse(
          'https://flutter-shop-50c56-default-rtdb.firebaseio.com/products/$id.json');
      final response = await http.patch(
        url,
        body: json.encode({
          'isFavorite': isFavorite,
        }),
      );
      if (response.statusCode >= 400) {
        throw HttpException(
            'Could not change favorite status of this product.');
      }
    } catch (error) {
      isFavorite = !isFavorite;
      notifyListeners();
      throw HttpException(error.toString());
    }
  }
}
