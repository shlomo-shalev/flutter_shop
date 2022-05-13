// packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// view widgets
import 'package:flutter_shop_app/widgets/product_block.dart';
// providers
import 'package:flutter_shop_app/providers/products_provider.dart';

class ProductsBlock extends StatelessWidget {
  final bool _onlyFavorites;

  const ProductsBlock(this._onlyFavorites, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);
    final products = _onlyFavorites
        ? productsProvider.favoriteProducts
        : productsProvider.products;
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: products.length,
      itemBuilder: (ctx, i) {
        return ChangeNotifierProvider.value(
          value: products[i],
          child: ProductBlock(key: ValueKey(products[i].id)),
        );
      },
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
