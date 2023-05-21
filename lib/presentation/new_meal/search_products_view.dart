import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:meals_planner/helpers/debouncer.dart';
import 'package:meals_planner/logic/providers/newProductProvider.dart';
import 'package:meals_planner/logic/providers/productsProvider.dart';

import '../../constants/colors.dart';
import '../../models/Product.dart';

class SearchProductsView extends ConsumerStatefulWidget {
  SearchProductsView({Key? key}) : super(key: key);

  @override
  ConsumerState<SearchProductsView> createState() => _SearchProductsViewState();
}

class _SearchProductsViewState extends ConsumerState<SearchProductsView> {
  final TextEditingController inputController = TextEditingController();
  final Debouncer debouncer = Debouncer(Duration(milliseconds: 300));
  bool isVisible = true;

  @override
  void dispose() {
    inputController.dispose();
    debouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AsyncValue<List<Product>> productsProvider = ref.watch(productsController);
    final productsReader = ref.read(productsController.notifier);

    return Dialog.fullscreen(
      child: Opacity(
        opacity: isVisible ? 1 : 0,
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
                      isVisible = false;
                      productsReader.initialize();
                    },
                    child: Text('Go back'),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
                child: Container(
                  decoration: BoxDecoration(
                      color: lightGreyColor,
                      borderRadius: new BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 15, right: 15, top: 5, bottom: 5),
                    child: TextField(
                      controller: inputController,
                      onChanged: (value) {
                        debouncer(() {
                          productsReader.getSearchedProducts(value);
                        });
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Product name',
                        labelStyle: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SelectableProducts(
                    controller: productsProvider,
                  ),
                ),
              ),
            ],
          ),
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
        if (controller.isEmpty) {
          return Center(
            child: Text('No results found'),
          );
        }

        return ListView.separated(
          separatorBuilder: (context, index) => Padding(
            padding: EdgeInsets.fromLTRB(0, 6, 0, 6),
          ),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          padding: EdgeInsets.fromLTRB(6, 0, 6, 0),
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
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      controller[index].name ?? "",
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 8, 0, 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    'Proteins',
                                    style: TextStyle(
                                      color: primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${controller[index].proteins} g',
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    'Carbs',
                                    style: TextStyle(
                                      color: primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${controller[index].carbohydrates} g',
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    'Fats',
                                    style: TextStyle(
                                      color: primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${controller[index].fats} g',
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
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
