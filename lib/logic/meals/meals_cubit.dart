import 'package:bloc/bloc.dart';
import '../../models/MealModel.dart';
import '../services/meals_service.dart';
import 'meals_state.dart';

class MealsCubit extends Cubit<MealsState> {
  MealsCubit() : super(InitialState()) {
    getMealsData();
  }

  void getMealsData() async {
    try {
      emit(LoadingState());
      final meals = await getMealsAsync();
      emit(LoadedState(meals));
    } catch (_) {
      emit(ErrorState());
    }
  }

  Future<bool> deleteMeal(MealModel meal) async {
    return await deleteMealAsync(meal);
  }
}
