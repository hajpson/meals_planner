import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:meals_planner/logic/services/products_service.dart';

import '../../constants/colors.dart';
import '../../models/SelectableProduct.dart';

class SearchProductsView extends StatefulWidget {
  SearchProductsView({Key? key, this.alreadySelectedItems}) : super(key: key);

  List<SelectableProduct>? alreadySelectedItems;

  @override
  State<SearchProductsView> createState() => _SearchProductsViewState();
}

class _SearchProductsViewState extends State<SearchProductsView> {
  late final Future<List<SelectableProduct>> selectableProductsFuture;
  var allItems = List<SelectableProduct>.empty(growable: true);
  var selectableItems = List<SelectableProduct>.empty(growable: true);
  final TextEditingController inputController = TextEditingController();
  bool isInitializing = true;

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

    var alreadySelectedProducts = widget.alreadySelectedItems;

    for (var product in productsData) {
      allItems.add(SelectableProduct(product: product, isSelected: false));
    }

    if (alreadySelectedProducts != null && !alreadySelectedProducts.isEmpty) {
      for (var selectedProduct in alreadySelectedProducts) {
        allItems
            .singleWhere((selectableProduct) =>
                selectableProduct.product.id == selectedProduct.product.id)
            .isSelected = true;
      }
    }

    selectableItems = allItems;

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
      selectableItems = filteredItems;
    });
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
              child: Row(
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
                          var initialItems = widget.alreadySelectedItems;

                          Navigator.pop(context, initialItems);
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
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: FutureBuilder<List<SelectableProduct>>(
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
                              : selectableItems.isEmpty
                                  ? Center(
                                      child: Text(
                                        'No results found, try with different search.',
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.only(top: 12),
                                      child: ListView.separated(
                                        separatorBuilder: (context, index) =>
                                            Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 6, 0, 6),
                                        ),
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        padding:
                                            EdgeInsets.fromLTRB(6, 0, 6, 0),
                                        physics: BouncingScrollPhysics(),
                                        itemCount: selectableItems.length,
                                        itemBuilder: (context, index) =>
                                            InkWell(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12)),
                                          onTap: () => _handleItemTap(
                                              selectableItems[index]),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: selectableItems[index]
                                                        .isSelected
                                                    ? selectedColor
                                                    : lightGreyColor,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(12))),
                                            child: Padding(
                                              padding: const EdgeInsets.all(12),
                                              child: Column(
                                                children: [
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      selectableItems[index]
                                                              .product
                                                              .name ??
                                                          "",
                                                      style: TextStyle(
                                                        color: primaryColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 8),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      12)),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                0, 8, 0, 4),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            Expanded(
                                                              child: Column(
                                                                children: [
                                                                  Text(
                                                                    'Proteins',
                                                                    style:
                                                                        TextStyle(
                                                                      color:
                                                                          primaryColor,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    '${selectableItems[index].product.proteins} g',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .grey,
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
                                                                    style:
                                                                        TextStyle(
                                                                      color:
                                                                          primaryColor,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    '${selectableItems[index].product.carbohydrates} g',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .grey,
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
                                                                    style:
                                                                        TextStyle(
                                                                      color:
                                                                          primaryColor,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    '${selectableItems[index].product.fats} g',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .grey,
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
                      backgroundColor: primaryColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      shadowColor: Color.fromARGB(53, 0, 0, 0)),
                  onPressed: () {
                    var selectedItems = selectableItems
                        .where((element) => element.isSelected)
                        .toList();

                    Navigator.pop(context, selectedItems);
                  },
                  child: Text(
                    'Add products',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color.fromARGB(212, 255, 255, 255)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
