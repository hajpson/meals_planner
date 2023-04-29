import 'package:isar/isar.dart';
import 'package:meals_planner/logic/repository/initializer.dart';
import 'package:meals_planner/models/Product.dart';

Future<List<Product>> getProductsAsync() async {
  final isar = await initializeIsar();
  List<Product> meals = [];

  await isar.txn(() async {
    meals = await isar.products.where().findAll();
  });

  return meals;
}

