import 'package:flutter/material.dart';
import 'package:flutter_shop_app/screens/products_overview_screen.dart';

void main() {
  runApp(const MyApp());
}

// dd
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        colorScheme: const ColorScheme.light().copyWith(
          secondary: Colors.deepOrange,
        ),
        fontFamily: 'Lato',
      ),
      home: const ProductsOverviewScreen(),
    );
  }
}
