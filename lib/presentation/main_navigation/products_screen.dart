import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:meals_planner/constants/screen_indicator_enum.dart';
import 'package:meals_planner/logic/new_product/new_product_cubit.dart';
import 'package:meals_planner/presentation/new_product/new_product_screen.dart';

import '../../constants/colors.dart';
import '../../logic/products/products_cubit.dart';
import '../../logic/products/products_state.dart';
import '../../models/Product.dart';
import '../shared/NoDataScreen.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  Future<void> _showDeletionToast(
      BuildContext context, List<Product> products, int index) async {
    bool result =
        await context.read<ProductsCubit>().deleteProduct(products[index]);
    if (result) {
      setState(() {
        products.removeAt(index);
      });
    }
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
                'Product deleted successfully',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ))
          : SnackBar(
              showCloseIcon: true,
              closeIconColor: Colors.white,
              backgroundColor: errorColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16))),
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
              content: Text(
                'Failed to delete product - try again',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              )));
  }

  Future<void> _navigateAndDisplayResultToast(BuildContext context) async {
    final result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return BlocProvider<NewProductCubit>(
          create: (context) => NewProductCubit(), child: NewProductScreen());
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
      context.read<ProductsCubit>().getProductsData();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

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
        body: Center(child: Container(
          child: BlocBuilder<ProductsCubit, ProductsState>(
            builder: (context, state) {
              if (state is LoadingState) {
                return Center(
                  child: SpinKitThreeBounce(color: middleColor),
                );
              } else if (state is ErrorState) {
                return Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Something went wrong'),
                        Icon(Icons.close)
                      ]),
                );
              } else if (state is LoadedState) {
                final products = state.products;

                if (products.isEmpty) {
                  return NoDataScreen(usedPage: ScreenIndicator.Products);
                }

                return ListView.builder(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 12),
                    physics: BouncingScrollPhysics(),
                    itemCount: products.length,
                    itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: lightGreyColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      products[index].name!,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: primaryColor,
                                          fontSize: 20),
                                    ),
                                    IconButton(
                                      splashRadius: 20,
                                      color: errorColor,
                                      icon: Icon(Icons.delete),
                                      onPressed: () => _showDeletionToast(
                                          context, products, index),
                                    )
                                  ],
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    products[index].description!,
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 12),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 8, 0, 4),
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
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      products[index]
                                                                  .proteins ==
                                                              null
                                                          ? 0.toString()
                                                          : products[index]
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
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: primaryColor,
                                                      ),
                                                    ),
                                                    Text(
                                                      products[index]
                                                                  .carbohydrates ==
                                                              null
                                                          ? 0.toString()
                                                          : products[index]
                                                              .carbohydrates
                                                              .toString(),
                                                      style: TextStyle(
                                                          color: Colors.grey),
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
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      products[index].fats ==
                                                              null
                                                          ? 0.toString()
                                                          : products[index]
                                                              .fats
                                                              .toString(),
                                                      style: TextStyle(
                                                          color: Colors.grey),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Divider(),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 4, 0, 8),
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
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      products[index]
                                                                  .calories ==
                                                              null
                                                          ? 0.toString()
                                                          : products[index]
                                                              .calories
                                                              .toString(),
                                                      style: TextStyle(
                                                          color: Colors.grey),
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
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: primaryColor,
                                                      ),
                                                    ),
                                                    Text(
                                                      products[index].price ==
                                                              null
                                                          ? 0.toString()
                                                          : products[index]
                                                              .price
                                                              .toString(),
                                                      style: TextStyle(
                                                          color: Colors.grey),
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
              } else {
                return NoDataScreen(usedPage: ScreenIndicator.Products);
              }
            },
          ),
        )),
      ),
    );
  }
}
