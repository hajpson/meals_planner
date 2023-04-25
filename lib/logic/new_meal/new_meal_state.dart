import 'package:equatable/equatable.dart';
import '../../models/MealModel.dart';

abstract class NewMealState extends Equatable {}

class InitialState extends NewMealState {
  @override
  List<Object> get props => [];
}

class LoadingState extends NewMealState {
  LoadingState(this.newMeal);

  final MealModel newMeal;

  @override
  List<Object> get props => [newMeal];
}

class SuccessState extends NewMealState {
  @override
  List<Object> get props => [];
}

class ErrorState extends NewMealState {
  @override
  List<Object> get props => [];
}