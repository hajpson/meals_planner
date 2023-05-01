import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:meals_planner/constants/colors.dart';
import 'package:meals_planner/logic/new_meal/new_meal_cubit.dart';
import 'package:meals_planner/logic/new_meal/new_meal_state.dart';
import 'package:meals_planner/models/MealModel.dart';
import 'package:meals_planner/presentation/new_meal/search_products_view.dart';

class NewMealScreen extends StatefulWidget {
  const NewMealScreen({super.key});

  @override
  State<NewMealScreen> createState() => _NewMealScreen();
}

class _NewMealScreen extends State<NewMealScreen> {
  final mealNameController = TextEditingController();
  final mealDescController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocBuilder<NewMealCubit, NewMealState>(
          builder: (context, state) {
            if (state is LoadingState) {
              return Center(
                child: SpinKitThreeBounce(color: middleColor),
              );
            } else if (state is InitialState) {
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
                                    backgroundColor: secondaryColor,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
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
                                            color: Color.fromARGB(
                                                212, 255, 255, 255)),
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
                                    color: lightGrayColor,
                                    borderRadius:
                                        new BorderRadius.circular(16)),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 15, right: 15, top: 5),
                                  child: TextFormField(
                                    controller: mealNameController,
                                    cursorColor: secondaryColor,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        labelText: 'Meal name',
                                        labelStyle:
                                            TextStyle(color: secondaryColor)),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: lightGrayColor,
                                    borderRadius:
                                        new BorderRadius.circular(16)),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 15, right: 15, top: 5),
                                  child: TextFormField(
                                    controller: mealDescController,
                                    maxLength: 10000,
                                    maxLines: 10,
                                    cursorColor: secondaryColor,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        alignLabelWithHint: true,
                                        labelText: 'Meal short description',
                                        labelStyle:
                                            TextStyle(color: secondaryColor)),
                                  ),
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
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      shadowColor: Color.fromARGB(53, 0, 0, 0)),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return SearchProductsView();
                                        });
                                  },
                                  child: Text(
                                    'Press to add product for meal',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color:
                                            Color.fromARGB(212, 255, 255, 255)),
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
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        shadowColor:
                                            Color.fromARGB(53, 0, 0, 0)),
                                    onPressed: () async {
                                      final newMeal = MealModel()
                                        ..mealName = mealNameController.text
                                        ..mealDescription =
                                            mealDescController.text;
                                      final newMealsCubit =
                                          context.read<NewMealCubit>();
                                      await newMealsCubit.addNewMeal(newMeal);
                                    },
                                    child: Text(
                                      'Add new meal',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: Color.fromARGB(
                                              212, 255, 255, 255)),
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
            } else if (state is ErrorState) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).pop(false);
              });
            } else if (state is SuccessState) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).pop(true);
              });
            }
            return Center();
          },
        ),
      ),
    );
  }
}
