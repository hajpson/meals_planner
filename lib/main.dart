import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meals_planner/logic/main_navigation/main_navigation_cubit.dart';
import 'package:meals_planner/presentation/root_screen.dart';

import 'constants/colors.dart';
import 'helpers/material_color_generator.dart';

void main() {
  runApp(MyApp());
}



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<MainNavigationCubit>(
      create: (context) => MainNavigationCubit(),
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: MaterialColorGenerator.from(primaryColor),
          fontFamily: GoogleFonts.raleway().fontFamily,
          ),
        home: RootScreen(),
      ),
    );
  }
}
