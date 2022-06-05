// packeges
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// providers
import 'package:flutter_shop_app/providers/product_provider.dart';
import 'package:flutter_shop_app/providers/products_provider.dart';
// widgets
import 'package:flutter_shop_app/widgets/app_drawer.dart';
import 'package:flutter_shop_app/widgets/user_product_block.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  const UserProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProductsProvider productsProvider =
        Provider.of<ProductsProvider>(context);
    final List<ProductProvider> products = productsProvider.products;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your prodcuts'),
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (_, i) => Column(
          children: [
            UserProductBlock(
              product: products[i],
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}