import 'package:equatable/equatable.dart';
import '../../models/MealModel.dart';

abstract class MealsState extends Equatable {}

class InitialState extends MealsState {
  @override
  List<Object> get props => [];
}

class LoadingState extends MealsState {
  @override
  List<Object> get props => [];
}

class LoadedState extends MealsState {
  LoadedState(this.meals);

  final List<MealModel> meals;

  @override
  List<Object> get props => [meals];
}

class ErrorState extends MealsState {
  @override
  List<Object> get props => [];
}
