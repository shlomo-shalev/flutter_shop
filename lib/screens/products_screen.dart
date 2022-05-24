// packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// widgets
import 'package:flutter_shop_app/widgets/badge.dart';
import 'package:flutter_shop_app/widgets/products_block.dart';
import 'package:flutter_shop_app/widgets/app_drawer.dart';
// providers
import 'package:flutter_shop_app/providers/cart_provider.dart';
// screens
import 'package:flutter_shop_app/screens/cart_screen.dart';

enum _FiltersOptions {
  favorites,
  all,
}

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  bool _onlyFavorites = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('myShop'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (_FiltersOptions option) {
              setState(() {
                _onlyFavorites = option == _FiltersOptions.favorites;
              });
            },
            icon: const Icon(Icons.more_vert),
            itemBuilder: (_) => const [
              PopupMenuItem(
                child: Text('Only Favorites'),
                value: _FiltersOptions.favorites,
              ),
              PopupMenuItem(
                child: Text('Show all'),
                value: _FiltersOptions.all,
              ),
            ],
          ),
          Consumer<CartProvider>(
            builder: (_, CartProvider cart, child) => Badge(
              child: child as Widget,
              color: Colors.red,
              value: cart.count.toString(),
            ),
            child: IconButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed(CartScreen.routeName),
              icon: const Icon(
                Icons.shopping_cart,
              ),
            ),
          ),
        ],
      ),
      body: ProductsBlock(_onlyFavorites),
    );
  }
}
