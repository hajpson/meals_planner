import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meals_planner/models/Product.dart';
import '../services/products_service.dart';
import 'new_product_state.dart';

class NewProductCubit extends Cubit<NewProductState> {
  NewProductCubit() : super(InitialState()) {}

  Future<void> addNewProduct(Product newProduct) async {
    try {
      emit(LoadingState(newProduct));
      var hasAdded = await addNewProductAsync(newProduct);
      emit(hasAdded ? SuccessState() : ErrorState());
    } catch (_) {
      emit(ErrorState());
    }
  }
}
