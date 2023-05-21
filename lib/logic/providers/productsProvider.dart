import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_planner/logic/services/products_service.dart';
import 'package:meals_planner/models/Product.dart';

final productsController =
    StateNotifierProvider<ProductsAsyncNotifier, AsyncValue<List<Product>>>(
        (ref) => ProductsAsyncNotifier());

class ProductsAsyncNotifier extends StateNotifier<AsyncValue<List<Product>>> {
  ProductsAsyncNotifier() : super(AsyncLoading()) {
    initialize();
  }

  void initialize() async {
    var productsData = await getProductsAsync();
    state = AsyncData(productsData);
  }
}
