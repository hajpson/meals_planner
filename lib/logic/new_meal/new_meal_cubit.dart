import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meals_planner/models/MealModel.dart';
import '../services/meals_service.dart';
import 'package:bloc/bloc.dart';
import 'new_meal_state.dart';

class NewMealCubit extends Cubit<NewMealState> {
  NewMealCubit() : super(InitialState()) {}

  Future<void> addNewMeal(MealModel newMeal) async {
    try {
      emit(LoadingState(newMeal));
      var hasAdded = await addNewMealAsync(newMeal);
      emit(hasAdded == true ? SuccessState() : ErrorState());
    } catch (_) {
      emit(ErrorState());
    }
  }
}
