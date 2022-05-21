// pachages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// screens widgets
import 'package:flutter_shop_app/screens/products_overview_screen.dart';
import 'package:flutter_shop_app/screens/product_overview_screen.dart';
import 'package:flutter_shop_app/screens/cart_overview_screen.dart';
// providers
import 'package:flutter_shop_app/providers/products_provider.dart';
import 'package:flutter_shop_app/providers/cart_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: ProductsProvider(),
        ),
        ChangeNotifierProvider.value(
          value: CartProvider(),
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
        home: const ProductsOverviewScreen(),
        routes: {
          ProductOverviewScreen.routeName: (_) => const ProductOverviewScreen(),
          CartOverviewScreen.routeName: (_) => const CartOverviewScreen(),
        },
      ),
    );
  }
}
