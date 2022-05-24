// packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// models
import 'package:flutter_shop_app/providers/product_provider.dart';
// providers
import 'package:flutter_shop_app/providers/products_provider.dart';

class ProductScreen extends StatelessWidget {
  static String routeName = '/product/';

  const ProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<dynamic, dynamic>;
    // ---- I know "arguments['product']" is Product but The goal is to see the listener: false
    final ProductProvider product =
        Provider.of<ProductsProvider>(context, listen: false)
            .findProduct(arguments['product'].id);
    // ----
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 300,
              width: double.infinity,
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '\$${product.price}',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Text(
                product.description,
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
