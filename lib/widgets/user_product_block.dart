// packages
import 'package:flutter/material.dart';
// providers
import 'package:flutter_shop_app/providers/product_provider.dart';
import 'package:flutter_shop_app/providers/products_provider.dart';
// screens
import 'package:flutter_shop_app/screens/edit_product_screen.dart';
import 'package:provider/provider.dart';

class UserProductBlock extends StatelessWidget {
  final ProductProvider product;

  const UserProductBlock({
    required this.product,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ScaffoldMessengerState scaffoldMessenger =
        ScaffoldMessenger.of(context);
    return ListTile(
      title: Text(product.title),
      subtitle: Text(product.description),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductScreen.routeName, arguments: product);
              },
              color: Theme.of(context).primaryColor,
              icon: const Icon(Icons.edit),
            ),
            IconButton(
              onPressed: () async {
                try {
                  await Provider.of<ProductsProvider>(context, listen: false)
                      .delete(product.id);
                } catch (error) {
                  scaffoldMessenger.showSnackBar(
                    SnackBar(
                      content: Text(
                        error.toString(),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
              },
              icon: const Icon(Icons.delete),
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
