import 'package:flutter/material.dart';
import 'package:flutter_shop_app/widgets/products_block.dart';

class ProductsOverviewScreen extends StatelessWidget {
  const ProductsOverviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('myShop'),
      ),
      body: const ProductsBlock(),
    );
  }
}
