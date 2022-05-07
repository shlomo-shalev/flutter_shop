import 'package:flutter/material.dart';
import 'package:flutter_shop_app/models/product.dart';

class ProductOverviewScreen extends StatelessWidget {
  static String routeName = '/product/';

  const ProductOverviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<dynamic, dynamic>;
    final Product product = arguments['product'];
    return Scaffold(
      appBar: AppBar(
        title: const Text('title'),
      ),
    );
  }
}
