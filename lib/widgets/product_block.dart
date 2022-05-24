// packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// providers
import 'package:flutter_shop_app/providers/product_provider.dart';
import 'package:flutter_shop_app/providers/cart_provider.dart';
// screens widgets
import 'package:flutter_shop_app/screens/product_screen.dart';

class ProductBlock extends StatelessWidget {
  const ProductBlock({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProductProvider product =
        Provider.of<ProductProvider>(context, listen: false);
    final CartProvider cart = Provider.of<CartProvider>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductScreen.routeName,
              arguments: {
                'product': product,
              },
            );
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<ProductProvider>(
            builder: (context, product, _) => IconButton(
              color: Theme.of(context).colorScheme.secondary,
              icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border),
              onPressed: () => product.toogleFavoriteStatus(),
            ),
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            color: Theme.of(context).colorScheme.secondary,
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => cart.toggleItem(product),
          ),
        ),
      ),
    );
  }
}
