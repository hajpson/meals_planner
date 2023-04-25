import 'package:equatable/equatable.dart';
import '../../models/Product.dart';

abstract class ProductsState extends Equatable {}

class InitialState extends ProductsState {
  @override
  List<Object> get props => [];
}

class LoadingState extends ProductsState {
  @override
  List<Object> get props => [];
}

class LoadedState extends ProductsState {
  LoadedState(this.products);

  final List<Product> products;

  @override
  List<Object> get props => [products];
}

class ErrorState extends ProductsState {
  @override
  List<Object> get props => [];
}
