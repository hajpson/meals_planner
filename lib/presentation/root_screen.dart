import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meals_planner/logic/meals/meals_cubit.dart';
import 'package:meals_planner/models/NavbarItem.dart';
import 'package:meals_planner/logic/main_navigation/main_navigation_cubit.dart';
import 'package:meals_planner/presentation/main_navigation/meals_screen.dart';
import 'package:meals_planner/presentation/main_navigation/settings_screen.dart';
import 'package:meals_planner/presentation/main_navigation/products_screen.dart';

import '../constants/colors.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: Container(
        color: Colors.transparent,
        padding: EdgeInsets.all(10),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          child: BlocBuilder<MainNavigationCubit, MainNavigationState>(
              builder: (context, state) {
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.topRight,
              stops: [0, 1],
              tileMode: TileMode.clamp,
              colors: [
                Color.fromARGB(255, 202, 109, 255),
                Color.fromARGB(255, 23, 151, 255)
              ]
            )
          ),
          child: BottomNavigationBar(
            currentIndex: state.index,
            showUnselectedLabels: false,
            backgroundColor: Colors.transparent,
            selectedLabelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16
            ),
            iconSize: 28,
            unselectedItemColor: lightWhiteColor,
            selectedItemColor: Colors.white,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            items: bottomAppBarItems,
            onTap: (index) => {
              if (index == 0) {
                BlocProvider.of<MainNavigationCubit>(context)
                  .setNavBartItem(NavbarItem.meals)
              } else if (index == 1) {
                BlocProvider.of<MainNavigationCubit>(context)
                  .setNavBartItem(NavbarItem.settings)
              } else {
                BlocProvider.of<MainNavigationCubit>(context)
                  .setNavBartItem(NavbarItem.products)
              }
            }),
        );
        }),
      ),
    ),
    body: BlocBuilder<MainNavigationCubit, MainNavigationState>(
      builder: (context, state) {
        if (state.navbarItem == NavbarItem.meals) {
          return BlocProvider<MealsCubit>(
            create: (context) => MealsCubit(),
            child: MealsScreen(),
          );
        } else if (state.navbarItem == NavbarItem.settings) {
          return ProductsScreen();
        } else {
          return SettingsScreen() ;
        }
      }),
    );
  }
}

const bottomAppBarItems = [
  BottomNavigationBarItem(icon: Icon(Icons.fastfood), label: 'Meals'),
  BottomNavigationBarItem(icon: Icon(Icons.shopping_basket), label: 'Products'),
  BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings')
];
