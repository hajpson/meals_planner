import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meals_planner/logic/meals/meals_cubit.dart';
import 'package:meals_planner/presentation/main_navigation/meals_screen.dart';
import 'package:meals_planner/presentation/main_navigation/settings_screen.dart';
import 'package:meals_planner/presentation/main_navigation/products_screen.dart';

import '../constants/colors.dart';

class RootScreen extends StatefulWidget {
  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  var _selectedPageIndex;
  late List<Widget> _pages;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();

    _selectedPageIndex = 0;

    _pages = [
      BlocProvider<MealsCubit>(
            create: (context) => MealsCubit(),
            child: MealsScreen()
      ),
      ProductsScreen(),
      SettingsScreen()
    ];

    _pageController = PageController(initialPage: _selectedPageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: _pages,
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20)
        ),
        child: Container(
          decoration: BoxDecoration(
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
            showUnselectedLabels: false,
            iconSize: 28,
            unselectedItemColor: lightWhiteColor,
            selectedItemColor: Colors.white,
            elevation: 0,
            backgroundColor: Colors.transparent,
            selectedLabelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16
            ),
            items: bottomAppBarItems,
            currentIndex: _selectedPageIndex,
            onTap: (selectedPageIndex) {
              setState(() {
                _selectedPageIndex = selectedPageIndex;
                _pageController.jumpToPage(_selectedPageIndex);
              });
            },
          ),
        ),
      ),
    );
  }
}

const bottomAppBarItems = [
  BottomNavigationBarItem(icon: Icon(Icons.fastfood), label: 'Meals'),
  BottomNavigationBarItem(icon: Icon(Icons.shopping_basket), label: 'Products'),
  BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings')
];
