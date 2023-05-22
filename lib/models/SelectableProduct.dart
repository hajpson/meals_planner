import 'package:meals_planner/models/Product.dart';

class SelectableProduct {
  SelectableProduct({required this.product, required this.isSelected});

  Product product;
  bool isSelected;
}
