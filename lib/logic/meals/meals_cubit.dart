import 'package:bloc/bloc.dart';
import '../services/meals_service.dart';
import 'meals_state.dart';

class MealsCubit extends Cubit<MealsState> {
  MealsCubit() : super(InitialState()) {
    getMealsData();
  }

  void getMealsData() async {
    try {
      emit(LoadingState());
      final meals = await getMeals();
      emit(LoadedState(meals));
    } catch (_) {
      emit(ErrorState());
    }
  }
}