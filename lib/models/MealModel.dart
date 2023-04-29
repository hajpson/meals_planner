import 'package:isar/isar.dart';

part 'MealModel.g.dart';

@collection
class MealModel {
  Id id = Isar.autoIncrement;
  String? mealName;
  String? mealDescription;
  List<Product>? products;
}

@embedded
class Product {
  String? name;
  String? shortDescription;
  int? proteins;
  int? carbohydrates;
  int? fats;
  int? calories;
  int? price;
}