import 'package:isar/isar.dart';
import 'package:meals_planner/logic/repository/initializer.dart';
import '../../models/MealModel.dart';

Future<List<MealModel>> getMealsAsync() async {
  List<MealModel> meals = [];
  final isar = await getOpenedMealsInstance();

  if (isar != null && isar.isOpen) {
    await isar.txn(() async {
      var result = await isar.mealModels.where().findAll();
      meals = result;
    });
  } else {
    final newIsar = await initializeMealsInstance();

    await newIsar.txn(() async {
      var result = await newIsar.mealModels.where().findAll();
      meals = result;
    });
  }

  return meals;
}

Future<bool> addNewMealAsync(MealModel meal) async {
  final isar = await getOpenedMealsInstance();

  if (isar == null) {
    return false;
  }

  bool hasAdded = false;

  await isar.writeTxn(() async {
    var userExists = await isar.mealModels.put(meal);
    hasAdded = !userExists.isNaN;
  });

  return hasAdded;
}

Future<bool> deleteMealAsync(MealModel meal) async {
  final isar = await getOpenedMealsInstance();

  if (isar == null) {
    return false;
  }

  bool hasBeenDeleted = false;

  await isar.writeTxn(() async {
    var deletedMeal = await isar.mealModels.delete(meal.id);
    hasBeenDeleted = deletedMeal;
  });

  return hasBeenDeleted;
}
