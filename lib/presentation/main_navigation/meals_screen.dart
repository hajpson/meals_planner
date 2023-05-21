import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:meals_planner/constants/colors.dart';
import 'package:meals_planner/constants/screen_indicator_enum.dart';
import '../../logic/providers/mealsProvider.dart';
import '../new_meal/new_meal_screen.dart';
import '../shared/NoDataScreen.dart';
import '../../models/MealModel.dart';

class MealsScreen extends ConsumerStatefulWidget {
  const MealsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends ConsumerState<MealsScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  Future<void> _navigateAndDisplayResultToast(BuildContext context) async {
    final result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NewMealScreen();
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
                'New meal added successfully',
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
                'Failed to add new meal - try again',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              )));

    if (result) {
      ref.invalidate(mealsController);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    AsyncValue<List<MealModel>> mealsProvider = ref.watch(mealsController);

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
                child: MealsList(
          controller: mealsProvider,
        ))),
      ),
    );
  }
}

String _getSumFromDoubleList(List<double?> list) {
  double sum = 0.0;
  list.forEach((element) {
    sum += element!;
  });

  return sum.toString();
}

class MealsList extends StatelessWidget {
  const MealsList({super.key, required this.controller});

  final AsyncValue<List<MealModel>> controller;

  @override
  Widget build(BuildContext context) {
    return controller.when(
      data: (controller) {
        if (controller.isEmpty) {
          return NoDataScreen(usedPage: ScreenIndicator.Meals);
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
                          controller[index].mealName!,
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: middleColor,
                              fontSize: 20),
                        ),
                        IconButton(
                          splashRadius: 20,
                          color: errorColor,
                          icon: Icon(Icons.delete),
                          onPressed: () => {},
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        controller[index].mealDescription!,
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
                              padding: const EdgeInsets.fromLTRB(0, 8, 0, 4),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                    width: 100,
                                    child: Column(
                                      children: [
                                        Text(
                                          'Proteins',
                                          style: TextStyle(
                                            color: middleColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          controller[index].products == null
                                              ? 0.toString()
                                              : _getSumFromDoubleList(
                                                  controller[index]
                                                      .products!
                                                      .map((product) =>
                                                          product.proteins)
                                                      .toList()),
                                          style: TextStyle(
                                            color: Colors.grey,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 100,
                                    child: Column(
                                      children: [
                                        Text(
                                          'Carbs',
                                          style: TextStyle(
                                            color: middleColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          controller[index].products == null
                                              ? 0.toString()
                                              : _getSumFromDoubleList(
                                                  controller[index]
                                                      .products!
                                                      .map((product) =>
                                                          product.carbohydrates)
                                                      .toList()),
                                          style: TextStyle(
                                            color: Colors.grey,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 100,
                                    child: Column(
                                      children: [
                                        Text(
                                          'Fats',
                                          style: TextStyle(
                                            color: middleColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          controller[index].products == null
                                              ? 0.toString()
                                              : _getSumFromDoubleList(
                                                  controller[index]
                                                      .products!
                                                      .map((product) =>
                                                          product.fats)
                                                      .toList()),
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
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      error: (error, stack) {
        return Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text('Something went wrong'), Icon(Icons.close)]),
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
