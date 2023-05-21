import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_planner/constants/custom_provider_identifier.dart';
import 'package:meals_planner/logic/services/meals_service.dart';
import 'package:meals_planner/models/MealModel.dart';

final newMealController = StateNotifierProvider.autoDispose<
    NewMealAsyncNotifier,
    CustomProviderIdentifier>((ref) => NewMealAsyncNotifier());

class NewMealAsyncNotifier extends StateNotifier<CustomProviderIdentifier> {
  NewMealAsyncNotifier() : super(CustomProviderIdentifier.Initial);

  Future<void> addMeal(MealModel meal) async {
    state = CustomProviderIdentifier.Loading;
    bool hasAdded = await addNewMealAsync(meal);
    state = hasAdded
        ? CustomProviderIdentifier.Success
        : CustomProviderIdentifier.Error;
  }
}
