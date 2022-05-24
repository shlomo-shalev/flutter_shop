// packages
import 'package:flutter/material.dart';
// providers
import 'package:flutter_shop_app/providers/cart_provider.dart';
import 'package:provider/provider.dart';

class CartItemBlock extends StatelessWidget {
  final CartItem cartItem;

  const CartItemBlock({
    Key? key,
    required this.cartItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CartProvider cart = Provider.of<CartProvider>(context, listen: false);
    return Dismissible(
      key: ValueKey(cartItem.id),
      direction: DismissDirection.endToStart,
      onDismissed: (dicrection) => cart.remove(cartItem),
      background: Container(
        color: Theme.of(context).errorColor,
        child: const Icon(
          Icons.delete,
          size: 40,
          color: Colors.white,
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: FittedBox(
                  child: Text('\$${cartItem.price.toStringAsFixed(2)}'),
                ),
              ),
            ),
            title: Text(cartItem.item.title),
            subtitle: Text(
                'Total: \$${(cartItem.price * cartItem.quantity).toStringAsFixed(2)}'),
            trailing: Text('${cartItem.quantity} x'),
          ),
        ),
      ),
    );
  }
}
