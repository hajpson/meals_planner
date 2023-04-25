import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:meals_planner/constants/appwrite_data.dart';
import 'package:meals_planner/logic/repository/initializer.dart';
import 'package:meals_planner/models/Product.dart';

final client = prepareClient();
late final Databases _database;
late final DocumentList _result;

Future<List<Product>> getProducts() async {
  _database = Databases(client);
  List<Product> products = [];

  try {
    _result = await _database.listDocuments(databaseId: DATABASE_ID, collectionId: PRODUCTS_COLLECTION_ID);

    for (var document in _result.documents) {
      Product productToBeAdded = Product.fromMap(document.data);
      products.add(productToBeAdded);
    }
  } catch (_) {
    throw new Exception('Failed to load data');
  }

  return products;
}

