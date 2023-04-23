import 'package:flutter/material.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: const Scaffold(
        body: Center(child: Text('Products')),
      ),
    );
  }
}