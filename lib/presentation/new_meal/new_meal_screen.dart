import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:meals_planner/constants/colors.dart';
import 'package:meals_planner/constants/custom_provider_identifier.dart';
import 'package:meals_planner/logic/providers/newMealProvider.dart';
import 'package:meals_planner/models/MealModel.dart';
import 'package:meals_planner/presentation/new_meal/search_products_view.dart';

import '../../models/SelectableProduct.dart';

class NewMealScreen extends ConsumerWidget {
  NewMealScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomProviderIdentifier newMealProvider = ref.watch(newMealController);

    return SafeArea(
      child: Scaffold(
        body: NewMealLayout(controller: newMealProvider, widgetRef: ref),
      ),
    );
  }
}

class NewMealLayout extends StatefulWidget {
  NewMealLayout({super.key, required this.controller, required this.widgetRef});

  final CustomProviderIdentifier controller;
  final WidgetRef widgetRef;

  @override
  State<NewMealLayout> createState() => _NewMealLayoutState();
}

class _NewMealLayoutState extends State<NewMealLayout> {
  final mealNameController = TextEditingController();
  final mealDescController = TextEditingController();
  late List<SelectableProduct> selectedProducts = [];

  @override
  Widget build(BuildContext context) {
    if (widget.controller == CustomProviderIdentifier.Loading) {
      return Center(
        child: SpinKitThreeBounce(color: middleColor),
      );
    } else if (widget.controller == CustomProviderIdentifier.Success) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pop(true);
        return;
      });
    } else if (widget.controller == CustomProviderIdentifier.Error) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pop(false);
        widget.widgetRef.read(newMealController.notifier).dispose();
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
                        borderRadius: new BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 15, right: 15, top: 5, bottom: 5),
                        child: TextFormField(
                          controller: mealNameController,
                          cursorColor: secondaryColor,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Meal name',
                            labelStyle: TextStyle(
                              color: secondaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
                          controller: mealDescController,
                          maxLength: 10000,
                          maxLines: 10,
                          cursorColor: secondaryColor,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              alignLabelWithHint: true,
                              labelText: 'Meal description',
                              labelStyle: TextStyle(
                                color: secondaryColor,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: !selectedProducts.isEmpty,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        selectedProducts.length == 1
                            ? 'Selected 1 product'
                            : 'Selected ${selectedProducts.length} products',
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Container(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            backgroundColor: secondaryColor,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            shadowColor: Color.fromARGB(53, 0, 0, 0)),
                        onPressed: () async {
                          List<SelectableProduct>? result =
                              await showDialog<List<SelectableProduct>>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return SearchProductsView(
                                      alreadySelectedItems: selectedProducts,
                                    );
                                  });

                          if (result == null || result.isEmpty) {
                            setState(() {
                              selectedProducts = [];
                            });

                            return;
                          }

                          setState(() {
                            selectedProducts = result;
                          });
                        },
                        child: Text(
                          'Press to add products',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Color.fromARGB(212, 255, 255, 255)),
                        ),
                      ),
                    ),
                  ),
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
                            final newMeal = MealModel()
                              ..mealName = mealNameController.text
                              ..mealDescription = mealDescController.text;

                            await widget.widgetRef
                                .read(newMealController.notifier)
                                .addMeal(newMeal);
                          },
                          child: Text(
                            'Add new meal',
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
