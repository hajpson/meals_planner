import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:meals_planner/logic/services/products_service.dart';

import '../../constants/colors.dart';
import '../../models/SelectableProduct.dart';

class SearchProductsView extends StatefulWidget {
  SearchProductsView({Key? key}) : super(key: key);

  @override
  State<SearchProductsView> createState() => _SearchProductsViewState();
}

class _SearchProductsViewState extends State<SearchProductsView> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: SelectableProducts(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SelectableProducts extends StatefulWidget {
  SelectableProducts({super.key});

  @override
  State<SelectableProducts> createState() => _SelectableProductsState();
}

class _SelectableProductsState extends State<SelectableProducts> {
  late final Future<List<SelectableProduct>> selectableProductsFuture;
  var allItems = List<SelectableProduct>.empty(growable: true);
  var selectedItems = List<SelectableProduct>.empty(growable: true);
  final TextEditingController inputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectableProductsFuture = initialize();
    inputController.addListener(_handleOnTextChange);
  }

  @override
  void dispose() {
    inputController.dispose();
    super.dispose();
  }

  Future<List<SelectableProduct>> initialize() async {
    var productsData = await getProductsAsync();

    for (var product in productsData) {
      allItems.add(SelectableProduct(product: product, isSelected: false));
    }

    selectedItems = allItems;

    return allItems;
  }

  void _handleItemTap(SelectableProduct item) {
    setState(() {
      item.isSelected = !item.isSelected;
    });
  }

  void _handleOnTextChange() {
    var filteredItems = allItems
        .where(
            (element) => element.product.name!.contains(inputController.text))
        .toList();

    setState(() {
      selectedItems = filteredItems;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SelectableProduct>>(
      future: selectableProductsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: SpinKitThreeBounce(color: middleColor),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Something went wrong'),
                Icon(Icons.close),
              ],
            ),
          );
        } else {
          return Column(children: [
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
              child: allItems.isEmpty
                  ? Align(
                      alignment: Alignment.center,
                      child: Center(
                        child: Text(
                          'Seems like you have no products.\nTry to add some first and then come back here 😊',
                        ),
                      ),
                    )
                  : selectedItems.isEmpty
                      ? Center(
                          child: Text(
                            'No results found, try with different search.',
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: ListView.separated(
                            separatorBuilder: (context, index) => Padding(
                              padding: EdgeInsets.fromLTRB(0, 6, 0, 6),
                            ),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            padding: EdgeInsets.fromLTRB(6, 0, 6, 0),
                            physics: BouncingScrollPhysics(),
                            itemCount: selectedItems.length,
                            itemBuilder: (context, index) => InkWell(
                              onTap: () => _handleItemTap(selectedItems[index]),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: selectedItems[index].isSelected
                                        ? selectedColor
                                        : lightGreyColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12))),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          selectedItems[index].product.name ??
                                              "",
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
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 8, 0, 4),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        'Proteins',
                                                        style: TextStyle(
                                                          color: primaryColor,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        '${selectedItems[index].product.proteins} g',
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
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        '${selectedItems[index].product.carbohydrates} g',
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
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        '${selectedItems[index].product.fats} g',
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
                            ),
                          ),
                        ),
            ),
          ]);
        }
      },
    );
  }
}
