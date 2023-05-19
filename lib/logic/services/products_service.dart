import 'package:isar/isar.dart';
import 'package:meals_planner/logic/repository/initializer.dart';
import 'package:meals_planner/models/Product.dart';

Future<List<Product>> getProductsAsync() async {
  List<Product> products = [];
  final isar = await getOpenedProductsInstance();

  if (isar != null && isar.isOpen) {
    await isar.txn(() async {
      var result = await isar.products.where().findAll();
      products = result;
    });
  } else {
    final newIsar = await initializeProductsInstance();

    await newIsar.txn(() async {
      var result = await newIsar.products.where().findAll();
      products = result;
    });
  }

  return products;
}

Future<bool> addNewProductAsync(Product product) async {
  final isar = await getOpenedProductsInstance();

  if (isar == null) {
    return false;
  }

  bool hasAdded = false;

  await isar.writeTxn(() async {
    var itemCreated = await isar.products.put(product);
    hasAdded = !itemCreated.isNaN;
  });

  return hasAdded;
}

Future<bool> deleteProductAsync(Product product) async {
  final isar = await getOpenedProductsInstance();

  if (isar == null) {
    return false;
  }

  bool hasBeenDeleted = false;

  await isar.writeTxn(() async {
    var deletedMeal = await isar.products.delete(product.id);
    hasBeenDeleted = deletedMeal;
  });

  return hasBeenDeleted;
}
