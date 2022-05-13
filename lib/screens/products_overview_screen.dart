import 'package:flutter/material.dart';
import 'package:flutter_shop_app/widgets/products_block.dart';

enum _FiltersOptions {
  favorites,
  all,
}

class ProductsOverviewScreen extends StatefulWidget {
  const ProductsOverviewScreen({Key? key}) : super(key: key);

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _onlyFavorites = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        ],
      ),
      body: ProductsBlock(_onlyFavorites),
    );
  }
}
