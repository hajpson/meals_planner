import 'package:isar/isar.dart';
import 'package:meals_planner/logic/repository/initializer.dart';
import '../../models/MealModel.dart';

Future<List<MealModel>> getMealsAsync() async {
  final isar = await initializeIsar();
  List<MealModel> meals = [];

  await isar.txn(() async {
    meals = await isar.mealModels.where().findAll();
  });

  return meals;
}


