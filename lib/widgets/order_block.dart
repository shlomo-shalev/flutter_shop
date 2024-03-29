// core
import 'dart:math';
// packages
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// providers
import '../providers/orders_provider.dart';

class OrderBlock extends StatefulWidget {
  final Order order;

  const OrderBlock(this.order, {Key? key}) : super(key: key);

  @override
  State<OrderBlock> createState() => _OrderBlockState();
}

class _OrderBlockState extends State<OrderBlock> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('\$${widget.order.total.toStringAsFixed(2)}'),
            subtitle: Text(
                DateFormat('dd/MM/yyyy HH:mm').format(widget.order.dateTime)),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          AnimatedContainer(
            duration: const Duration(
              milliseconds: 300,
            ),
            curve: Curves.easeIn,
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 10,
            ),
            height:
                _expanded ? min(widget.order.items.length * 20.0 + 30, 100) : 0,
            child: ListView(
              children: widget.order.items
                  .map(
                    (item) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          item.item.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${item.quantity}x \$${item.price}',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                  .toList(),
            ),
          )
        ],
      ),
    );
  }
}
