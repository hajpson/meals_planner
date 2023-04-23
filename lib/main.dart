import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meals_planner/presentation/root_screen.dart';

import 'constants/colors.dart';
import 'helpers/material_color_generator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primarySwatch: MaterialColorGenerator.from(primaryColor),
          fontFamily: GoogleFonts.raleway().fontFamily,
          ),
        home: RootScreen(),
    );
  }
}
