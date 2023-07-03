import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:meals_planner/constants/screen_indicator_enum.dart';
import 'package:meals_planner/logic/providers/productsProvider.dart';
import 'package:meals_planner/presentation/new_product/new_product_screen.dart';
import 'package:meals_planner/presentation/shared/NoDataScreen.dart';

import '../../constants/colors.dart';
import '../../models/Product.dart';

class ProductsScreen extends ConsumerStatefulWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends ConsumerState<ProductsScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  Future<void> _navigateAndDisplayResultToast(BuildContext context) async {
    final result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NewProductScreen();
    }));

    if (!mounted) return;

    if (result == null) return;

    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(result == true
          ? SnackBar(
              showCloseIcon: true,
              closeIconColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16))),
              backgroundColor: successColor,
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
              content: Text(
                'New product added successfully',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ))
          : SnackBar(
              showCloseIcon: true,
              closeIconColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16))),
              backgroundColor: errorColor,
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
              content: Text(
                'Failed to add new product - try again',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              )));

    if (result) {
      ref.invalidate(productsController);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    AsyncValue<List<Product>> productsProvider = ref.watch(productsController);

    return SafeArea(
      child: Scaffold(
        floatingActionButton: Material(
          color: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(color: primaryColor, width: 2)),
          child: InkWell(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.add,
                size: 30,
                color: primaryColor,
              ),
            ),
            onTap: () => {_navigateAndDisplayResultToast(context)},
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        body: Center(
          child: Container(
            child: ProductsList(
              controller: productsProvider,
              widgetRef: ref,
            ),
          ),
        ),
      ),
    );
  }
}

class ProductsList extends StatelessWidget {
  const ProductsList(
      {super.key, required this.controller, required this.widgetRef});

  final AsyncValue<List<Product>> controller;
  final WidgetRef widgetRef;

  @override
  Widget build(BuildContext context) {
    return controller.when(
      data: (controller) {
        if (controller.isEmpty) {
          return NoDataScreen(usedPage: ScreenIndicator.Products);
        }

        return ListView.builder(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 12),
            physics: BouncingScrollPhysics(),
            itemCount: controller.length,
            itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                child: Container(
                  decoration: BoxDecoration(
                      color: lightGreyColor,
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              controller[index].name!,
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: primaryColor,
                                  fontSize: 20),
                            ),
                            IconButton(
                              splashRadius: 20,
                              color: errorColor,
                              icon: Icon(Icons.delete),
                              onPressed: () async {
                                bool hasBeenDeleted = await widgetRef
                                    .read(productsController.notifier)
                                    .deleteProduct(controller[index]);

                                if (hasBeenDeleted) {
                                  controller.removeAt(index);
                                }

                                ScaffoldMessenger.of(context)
                                  ..removeCurrentSnackBar()
                                  ..showSnackBar(hasBeenDeleted
                                      ? SnackBar(
                                          showCloseIcon: true,
                                          closeIconColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(16))),
                                          backgroundColor: successColor,
                                          behavior: SnackBarBehavior.floating,
                                          margin: EdgeInsets.fromLTRB(
                                              20, 0, 20, 20),
                                          content: Text(
                                            'Product deleted successfully',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ))
                                      : SnackBar(
                                          showCloseIcon: true,
                                          closeIconColor: Colors.white,
                                          backgroundColor: errorColor,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(16))),
                                          behavior: SnackBarBehavior.floating,
                                          margin: EdgeInsets.fromLTRB(
                                              20, 0, 20, 20),
                                          content: Text(
                                            'Failed to delete product - try again',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          )));
                              },
                            )
                          ],
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            controller[index].description!,
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12)),
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 8, 0, 4),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      SizedBox(
                                        width: 100,
                                        child: Column(
                                          children: [
                                            Text(
                                              "Proteins",
                                              style: TextStyle(
                                                color: primaryColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              controller[index].proteins == null
                                                  ? 0.toString()
                                                  : controller[index]
                                                      .proteins
                                                      .toString(),
                                              style: TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 100,
                                        child: Column(
                                          children: [
                                            Text(
                                              "Carbs",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: primaryColor,
                                              ),
                                            ),
                                            Text(
                                              controller[index].carbohydrates ==
                                                      null
                                                  ? 0.toString()
                                                  : controller[index]
                                                      .carbohydrates
                                                      .toString(),
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 100,
                                        child: Column(
                                          children: [
                                            Text(
                                              "Fats",
                                              style: TextStyle(
                                                color: primaryColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              controller[index].fats == null
                                                  ? 0.toString()
                                                  : controller[index]
                                                      .fats
                                                      .toString(),
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Divider(),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 4, 0, 8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      SizedBox(
                                        width: 100,
                                        child: Column(
                                          children: [
                                            Text(
                                              "Calories",
                                              style: TextStyle(
                                                color: primaryColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              controller[index].calories == null
                                                  ? 0.toString()
                                                  : controller[index]
                                                      .calories
                                                      .toString(),
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 100,
                                        child: Column(
                                          children: [
                                            Text(
                                              "Price (\$)",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: primaryColor,
                                              ),
                                            ),
                                            Text(
                                              controller[index].price == null
                                                  ? 0.toString()
                                                  : controller[index]
                                                      .price
                                                      .toString(),
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )));
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
