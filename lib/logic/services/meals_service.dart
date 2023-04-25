import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:meals_planner/constants/appwrite_data.dart';
import 'package:meals_planner/logic/repository/initializer.dart';

import '../../models/MealModel.dart';

final client = prepareClient();
late final Databases _database;
late final DocumentList _result;

Future<List<MealModel>> getMeals() async {
  _database = Databases(client);
  List<MealModel> meals = [];

  try {
    _result = await _database.listDocuments(databaseId: DATABASE_ID, collectionId: MEALS_COLLECTION_ID);

    for (var document in _result.documents) {
      MealModel productToBeAdded = MealModel.fromMap(document.data);
      meals.add(productToBeAdded);
    }
  } catch (_) {
    throw new Exception('Failed to load data');
  }

  return meals;
}

