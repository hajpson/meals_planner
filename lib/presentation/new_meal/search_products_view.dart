import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:meals_planner/logic/providers/productsProvider.dart';

import '../../constants/colors.dart';
import '../../models/Product.dart';

class SearchProductsView extends ConsumerWidget {
  const SearchProductsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<List<Product>> productsProvider = ref.watch(productsController);

    return Dialog.fullscreen(
      child: Container(
        width: double.maxFinite,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Go back'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: SelectableProducts(
                controller: productsProvider,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SelectableProducts extends StatelessWidget {
  SelectableProducts({super.key, required this.controller});

  final AsyncValue<List<Product>> controller;

  @override
  Widget build(BuildContext context) {
    return controller.when(
      data: (controller) {
        return ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          padding: EdgeInsets.all(12),
          physics: BouncingScrollPhysics(),
          itemCount: controller.length,
          itemBuilder: (context, index) => Container(
            decoration: BoxDecoration(
                color: lightGreyColor,
                borderRadius: BorderRadius.all(Radius.circular(12))),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Divider(height: 4),
                  Text(controller[index].name ?? ""),
                  Divider(height: 10),
                  Text('${controller[index].proteins}g proteins'),
                  Text('${controller[index].carbohydrates}g carbs'),
                  Text('${controller[index].fats}g fats'),
                ],
              ),
            ),
          ),
        );
      },
      error: (error, stack) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Something went wrong'),
              Icon(Icons.close),
            ],
          ),
        );
      },
      loading: () {
        return Center(
          child: SpinKitThreeBounce(color: middleColor),
        );
      },
    );
  }
}
