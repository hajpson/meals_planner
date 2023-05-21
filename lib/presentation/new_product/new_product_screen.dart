import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:meals_planner/constants/colors.dart';
import 'package:meals_planner/logic/providers/newProductProvider.dart';
import 'package:meals_planner/logic/services/products_service.dart';
import 'package:meals_planner/models/Product.dart';
import '../../constants/custom_provider_identifier.dart';
import '../shared/MacroCard.dart';
import '../shared/MacroSummaryCard.dart';

class NewProductScreen extends ConsumerWidget {
  NewProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomProviderIdentifier newProductProvider =
        ref.watch(newProductController);

    return SafeArea(
      child: Scaffold(
          body: NewProductLayout(
        controller: newProductProvider,
      )),
    );
  }
}

class NewProductLayout extends StatelessWidget {
  NewProductLayout({super.key, required this.controller});

  final CustomProviderIdentifier controller;

  final productNameController = TextEditingController();
  final productDescController = TextEditingController();
  final productProteinsController = TextEditingController();
  final productCarbsController = TextEditingController();
  final productFatsController = TextEditingController();
  final productCaloriesController = TextEditingController();
  final productPriceController = TextEditingController();

  Product _prepareNewProduct() {
    final newProduct = Product();

    final productProteins = productProteinsController.text.isEmpty
        ? 0.0
        : double.parse(productProteinsController.text);
    final productCarbs = productCarbsController.text.isEmpty
        ? 0.0
        : double.parse(productCarbsController.text);
    final productFats = productFatsController.text.isEmpty
        ? 0.0
        : double.parse(productFatsController.text);
    final productCalories = productCaloriesController.text.isEmpty
        ? 0.0
        : double.parse(productCaloriesController.text);
    final productPrice = productPriceController.text.isEmpty
        ? 0.0
        : double.parse(productPriceController.text);

    newProduct
      ..name = productNameController.text
      ..description = productDescController.text
      ..proteins = productProteins
      ..carbohydrates = productCarbs
      ..fats = productFats
      ..calories = productCalories
      ..price = productPrice;

    return newProduct;
  }

  @override
  Widget build(BuildContext context) {
    if (controller == CustomProviderIdentifier.Loading) {
      return Center(
        child: SpinKitThreeBounce(color: middleColor),
      );
    } else if (controller == CustomProviderIdentifier.Success) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pop(true);
        return;
      });
    } else if (controller == CustomProviderIdentifier.Error) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pop(false);
        return;
      });
    }
    return ListView(
      physics: BouncingScrollPhysics(),
      children: [
        Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 15),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          shadowColor: Color.fromARGB(53, 0, 0, 0)),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.arrow_back,
                            color: Color.fromARGB(212, 255, 255, 255),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              'Go back',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Color.fromARGB(212, 255, 255, 255)),
                            ),
                          ),
                        ],
                      )),
                ),
              ],
            ),
            Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Container(
                      decoration: BoxDecoration(
                          color: lightGreyColor,
                          borderRadius: new BorderRadius.circular(16)),
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 15, right: 15, top: 5, bottom: 5),
                        child: TextFormField(
                          controller: productNameController,
                          cursorColor: secondaryColor,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              labelText: 'Product name',
                              labelStyle: TextStyle(
                                  color: secondaryColor,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Container(
                      decoration: BoxDecoration(
                          color: lightGreyColor,
                          borderRadius: new BorderRadius.circular(16)),
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 15, right: 15, top: 5, bottom: 5),
                        child: TextFormField(
                          controller: productDescController,
                          maxLength: 10000,
                          maxLines: 10,
                          cursorColor: secondaryColor,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              alignLabelWithHint: true,
                              labelText: 'Product description',
                              labelStyle: TextStyle(
                                  color: secondaryColor,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: Container(
                        decoration: BoxDecoration(
                            color: lightGreyColor,
                            borderRadius: new BorderRadius.circular(16)),
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: 0, right: 0, top: 10, bottom: 10),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  MacroCard(
                                      name: 'Proteins',
                                      controller: productProteinsController),
                                  MacroCard(
                                      name: 'Carbs',
                                      controller: productCarbsController),
                                  MacroCard(
                                      name: 'Fats',
                                      controller: productFatsController),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 10, left: 10, right: 10),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          new BorderRadius.circular(16)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        MacroSummaryCard(
                                            name: 'KCal',
                                            controller:
                                                productCaloriesController),
                                        MacroSummaryCard(
                                            name: "\$",
                                            controller: productPriceController)
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Container(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(50),
                              backgroundColor: primaryColor,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              shadowColor: Color.fromARGB(53, 0, 0, 0)),
                          onPressed: () async {
                            final newProduct = _prepareNewProduct();
                            await addNewProductAsync(newProduct);

                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              Navigator.of(context).pop(true);
                            });
                          },
                          child: Text(
                            'Add new product',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Color.fromARGB(212, 255, 255, 255)),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}
