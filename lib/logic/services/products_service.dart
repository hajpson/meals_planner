import 'package:isar/isar.dart';
import 'package:meals_planner/logic/repository/initializer.dart';
import 'package:meals_planner/models/Product.dart';

Future<List<Product>> getProductsAsync() async {
  final isar = await initializeProductsInstance();
  List<Product> products = [];

  await isar.txn(() async {
    products = await isar.products.where().findAll();
  });

  return products;
}
