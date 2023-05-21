import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
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

    _pages = [MealsScreen(), ProductsScreen(), SettingsScreen()];

    _pageController = PageController(initialPage: _selectedPageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  final bottomAppBarItems = [
    CustomNavigationBarItem(
        icon: Icon(Icons.fastfood),
        title: Text('Meals'),
        selectedTitle: Text(
          'Meals',
          style: TextStyle(
              color: primaryColor, fontWeight: FontWeight.bold, fontSize: 17),
        )),
    CustomNavigationBarItem(
        icon: Icon(Icons.shopping_basket),
        title: Text('Products'),
        selectedTitle: Text(
          'Products',
          style: TextStyle(
              color: primaryColor, fontWeight: FontWeight.bold, fontSize: 17),
        )),
    CustomNavigationBarItem(
        icon: Icon(Icons.settings),
        title: Text('Settings'),
        selectedTitle: Text(
          'Settings',
          style: TextStyle(
              color: primaryColor, fontWeight: FontWeight.bold, fontSize: 17),
        ))
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        body: PageView(
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          children: _pages,
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: CustomNavigationBar(
            items: bottomAppBarItems,
            isFloating: true,
            iconSize: 30,
            strokeColor: Colors.transparent,
            selectedColor: primaryColor,
            unSelectedColor: Color.fromARGB(133, 99, 99, 99),
            scaleFactor: 0.1,
            scaleCurve: Curves.easeOutExpo,
            blurEffect: true,
            backgroundColor: lightWhiteColor,
            elevation: 1,
            borderRadius: Radius.circular(16),
            currentIndex: _selectedPageIndex,
            onTap: (selectedPageIndex) {
              setState(() {
                _selectedPageIndex = selectedPageIndex;
                _pageController.jumpToPage(_selectedPageIndex);
              });
            },
          ),
        ));
  }
}
