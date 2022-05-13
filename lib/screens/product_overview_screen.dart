// packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// models
import 'package:flutter_shop_app/providers/product.dart';
// providers
import 'package:flutter_shop_app/providers/products_provider.dart';

class ProductOverviewScreen extends StatelessWidget {
  static String routeName = '/product/';

  const ProductOverviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<dynamic, dynamic>;
    // ---- I know "arguments['product']" is Product but The goal is to see the listener: false
    final String productId = arguments['product'].id;
    final Product product =
        Provider.of<ProductsProvider>(context, listen: false)
            .findProduct(productId);
    // ----
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
    );
  }
}
