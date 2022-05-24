// pachages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// screens widgets
import 'package:flutter_shop_app/screens/products_screen.dart';
import 'package:flutter_shop_app/screens/product_screen.dart';
import 'package:flutter_shop_app/screens/cart_screen.dart';
import 'package:flutter_shop_app/screens/orders_screen.dart';
// providers
import 'package:flutter_shop_app/providers/products_provider.dart';
import 'package:flutter_shop_app/providers/cart_provider.dart';
import 'package:flutter_shop_app/providers/orders_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProductsProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CartProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => OrdersProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.purple,
          ),
          primarySwatch: Colors.purple,
          colorScheme: const ColorScheme.light().copyWith(
            secondary: Colors.deepOrange,
          ),
          fontFamily: 'Lato',
        ),
        home: const ProductsScreen(),
        routes: {
          ProductScreen.routeName: (_) => const ProductScreen(),
          CartScreen.routeName: (_) => const CartScreen(),
          OrdersScreen.routeName: (_) => const OrdersScreen(),
        },
      ),
    );
  }
}
