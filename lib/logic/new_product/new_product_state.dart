import 'package:equatable/equatable.dart';
import 'package:meals_planner/models/Product.dart';

abstract class NewProductState extends Equatable {}

class InitialState extends NewProductState {
  @override
  List<Object> get props => [];
}

class LoadingState extends NewProductState {
  LoadingState(this.newProduct);

  final Product newProduct;

  @override
  List<Object> get props => [];
}

class SuccessState extends NewProductState {
  @override
  List<Object> get props => [];
}

class ErrorState extends NewProductState {
  @override
  List<Object> get props => [];
}
