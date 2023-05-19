import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:meals_planner/constants/colors.dart';
import 'package:meals_planner/constants/screen_indicator_enum.dart';
import 'package:meals_planner/logic/meals/meals_cubit.dart';
import 'package:meals_planner/logic/new_meal/new_meal_cubit.dart';
import '../../logic/meals/meals_state.dart';
import '../new_meal/new_meal_screen.dart';
import '../shared/NoDataScreen.dart';
import '../../models/MealModel.dart';

class MealsScreen extends StatefulWidget {
  const MealsScreen({super.key});

  @override
  State<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  Future<void> _showDeletionToast(
      BuildContext context, List<MealModel> meals, int index) async {
    bool result = await context.read<MealsCubit>().deleteMeal(meals[index]);
    if (result) {
      setState(() {
        meals.removeAt(index);
      });
    }

    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(
        result == true
            ? SnackBar(
                showCloseIcon: true,
                closeIconColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16))),
                backgroundColor: successColor,
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
                content: Text(
                  'Meal deleted successfully',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : SnackBar(
                showCloseIcon: true,
                closeIconColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16))),
                backgroundColor: errorColor,
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
                content: Text(
                  'Failed to delete meal - try again',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
      );
  }

  Future<void> _navigateAndDisplayResultToast(BuildContext context) async {
    final result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return BlocProvider<NewMealCubit>(
          create: (context) => NewMealCubit(), child: NewMealScreen());
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
      context.read<MealsCubit>().getMealsData();
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
          child: BlocBuilder<MealsCubit, MealsState>(
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
                final meals = state.meals;

                if (meals.isEmpty) {
                  return NoDataScreen(usedPage: ScreenIndicator.Meals);
                }

                return ListView.builder(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 12),
                  physics: BouncingScrollPhysics(),
                  itemCount: meals.length,
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
                                  meals[index].mealName!,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: middleColor,
                                      fontSize: 20),
                                ),
                                IconButton(
                                  splashRadius: 20,
                                  color: errorColor,
                                  icon: Icon(Icons.delete),
                                  onPressed: () =>
                                      _showDeletionToast(context, meals, index),
                                ),
                              ],
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                meals[index].mealDescription!,
                                style:
                                    TextStyle(fontSize: 16, color: Colors.grey),
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
                                                  'Proteins',
                                                  style: TextStyle(
                                                    color: middleColor,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  meals[index].products == null
                                                      ? 0.toString()
                                                      : _getSumFromDoubleList(
                                                          meals[index]
                                                              .products!
                                                              .map((product) =>
                                                                  product
                                                                      .proteins)
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
                                                  meals[index].products == null
                                                      ? 0.toString()
                                                      : _getSumFromDoubleList(
                                                          meals[index]
                                                              .products!
                                                              .map((product) =>
                                                                  product
                                                                      .carbohydrates)
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
                                                  meals[index].products == null
                                                      ? 0.toString()
                                                      : _getSumFromDoubleList(
                                                          meals[index]
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
              } else {
                return NoDataScreen(usedPage: ScreenIndicator.Meals);
              }
            },
          ),
        )),
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
