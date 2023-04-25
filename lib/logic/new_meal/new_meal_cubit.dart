

import 'package:flutter_bloc/flutter_bloc.dart';
import 'new_meal_state.dart';

class NewMealCubit extends Cubit<NewMealState> {
  NewMealCubit() : super(InitialState()) {}
}