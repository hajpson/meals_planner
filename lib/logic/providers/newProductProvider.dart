import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_planner/constants/custom_provider_identifier.dart';

import '../../models/Product.dart';
import '../services/products_service.dart';

final newProductController = StateNotifierProvider.autoDispose<
    NewProductAsyncNotifier,
    CustomProviderIdentifier>((ref) => NewProductAsyncNotifier());

class NewProductAsyncNotifier extends StateNotifier<CustomProviderIdentifier> {
  NewProductAsyncNotifier() : super(CustomProviderIdentifier.Initial) {}

  void addProduct(Product product) async {
    state = CustomProviderIdentifier.Loading;
    bool hasAdded = await addNewProductAsync(product);
    state = hasAdded
        ? CustomProviderIdentifier.Success
        : CustomProviderIdentifier.Error;
  }
}
