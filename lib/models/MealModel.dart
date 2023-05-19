import 'package:isar/isar.dart';

part 'MealModel.g.dart';

@collection
@Name("Meals")
class MealModel {
  Id id = Isar.autoIncrement;
  String? mealName;
  String? mealDescription;
  List<Product>? products;
}

@embedded
class Product {
  String? name;
  String? description;
  double? proteins;
  double? carbohydrates;
  double? fats;
  double? calories;
  double? price;
}
