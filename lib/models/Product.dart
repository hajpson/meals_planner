import 'package:isar/isar.dart';

part 'Product.g.dart';

@collection
class Product {
  Id id = Isar.autoIncrement;
  String? name;
  String? shortDescription;
  int? proteins;
  int? carbohydrates;
  int? fats;
  int? calories;
  int? price;
}