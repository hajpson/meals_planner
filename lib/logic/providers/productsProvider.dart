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

  Future<bool> deleteProduct(Product product) async {
    bool hasBeenDeleted = await deleteProductAsync(product);
    if (hasBeenDeleted) {
      var productsData = await getProductsAsync();
      state = AsyncData(productsData);

      return true;
    }

    return false;
  }

  void getSearchedProducts(String phrase) async {
    state = AsyncLoading();
    var filteredProducts = await getFilteredProductsAsync(phrase);
    state = AsyncData(filteredProducts);
  }
}
