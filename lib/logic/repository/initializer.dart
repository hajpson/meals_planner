import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../models/MealModel.dart';
import '../../models/Product.dart' as Products;

// Client prepareClient() {
//   Client client = Client();

//   client
//   .setEndpoint(API_URL)
//   .setProject(PROJECT_ID)
//   .setSelfSigned(status: true);

//   return client;
// }

Future<Isar> initializeMealsInstance() async {
  final directory = await getApplicationDocumentsDirectory();

  final isar = await Isar.open([MealModelSchema],
      directory: directory.path, name: "Meals");

  return isar;
}

Future<Isar?> getOpenedMealsInstance() async {
  final isar = await Isar.getInstance("Meals");

  return isar;
}

Future<Isar> initializeProductsInstance() async {
  final directory = await getApplicationDocumentsDirectory();

  final isar = await Isar.open([Products.ProductSchema],
      directory: directory.path, name: "Products");

  return isar;
}

Future<Isar?> getOpenedProductsInstance() async {
  final isar = await Isar.getInstance("Products");

  return isar;
}
