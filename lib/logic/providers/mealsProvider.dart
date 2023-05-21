import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_planner/logic/services/meals_service.dart';
import 'package:meals_planner/models/MealModel.dart';

final mealsController =
    StateNotifierProvider<MealsAsyncNotifier, AsyncValue<List<MealModel>>>(
        (ref) => MealsAsyncNotifier());

class MealsAsyncNotifier extends StateNotifier<AsyncValue<List<MealModel>>> {
  MealsAsyncNotifier() : super(AsyncLoading()) {
    initialize();
  }

  void initialize() async {
    var mealsData = await getMealsAsync();
    state = AsyncData(mealsData);
  }

  Future<bool> deleteMeal(MealModel meal) async {
    bool hasBeenDeleted = await deleteMealAsync(meal);
    if (hasBeenDeleted) {
      var mealsData = await getMealsAsync();
      state = AsyncData(mealsData);
      
      return true;
    }

    return false;
  }
}
