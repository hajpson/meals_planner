import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meals_planner/logic/products/products_state.dart';
import 'package:meals_planner/logic/services/products_service.dart';
import 'package:meals_planner/models/Product.dart';

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit() : super(InitialState()) {
    getProductsData();
  }

  void getProductsData() async {
    try {
      emit(LoadingState());
      final products = await getProductsAsync();
      emit(LoadedState(products));
    } catch (_) {
      emit(ErrorState());
    }
  }

  Future<bool> deleteProduct(Product product) async {
    return await deleteProductAsync(product);
  }
}
