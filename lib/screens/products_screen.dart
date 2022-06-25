// packages
import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/products_provider.dart';
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
  bool _isInit = true;
  bool _isloeader = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<ProductsProvider>(context, listen: false)
          .fetchAndSetProducts()
          .then((_) {
        setState(() {
          _isloeader = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

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
      body: _isloeader
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const <Widget>[
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 10,
                  ),
                  Text('Importing products...'),
                ],
              ),
            )
          : ProductsBlock(_onlyFavorites),
    );
  }
}
