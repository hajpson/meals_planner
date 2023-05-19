import 'package:isar/isar.dart';

part 'Product.g.dart';

@collection
@Name("Products")
class Product {
  Id id = Isar.autoIncrement;
  String? name;
  String? description;
  double? proteins;
  double? carbohydrates;
  double? fats;
  double? calories;
  double? price;
}
