import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meals_planner/constants/colors.dart';

import '../../models/MealModel.dart';
import 'meals_state.dart';

class MealsCubit extends Cubit<MealsState> {
  MealsCubit() : super(InitialState()) {
    getFakeMealsData();
  }

  void getFakeMealsData() async {
    try {
      emit(LoadingState());
      await Future.delayed(Duration(milliseconds: 1500));

      final meals = [
        MealModel(
          0, 
          'First meal',
          'This is short description for first meal',
          Icon(Icons.emoji_emotions, color: primaryColor,)),
        MealModel(
          1, 
          'Second meal',
          'This however is rather longer description for second meal to show example of long text on list tile ...',
          Icon(Icons.cabin, color: secondaryColor,)),
          MealModel(
          2, 
          'Lorem meal',
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur vel sollicitudin diam, quis finibus diam. Sed feugiat luctus nunc ac iaculis. Nam sollicitudin rutrum leo. Donec non velit ut lacus mattis scelerisque nec eget mauris. Sed dictum ante sed dolor pharetra, a interdum ante feugiat. Fusce dapibus, est blandit vestibulum ultricies, leo ante sagittis nisl, in pharetra velit odio non purus. Curabitur dignissim porttitor mauris, eget egestas odio feugiat ac. Phasellus et turpis quis arcu feugiat ultrices id ut velit. Curabitur feugiat aliquam orci. Praesent eu sodales erat. Proin quis nisl orci. Maecenas vulputate nibh vitae nulla facilisis, venenatis cursus massa commodo. Nullam rutrum tempus lectus sit amet tincidunt. Praesent ornare sem nec augue sodales, vel egestas ligula convallis. Morbi et dui scelerisque, dictum mi sit amet, dapibus nibh.',
          Icon(Icons.list)),
          MealModel(
          3, 
          'Another Lorem meal',
          'Yet another Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur vel sollicitudin diam, quis finibus diam. Sed feugiat luctus nunc ac iaculis. Nam sollicitudin rutrum leo. Donec non velit ut lacus mattis scelerisque nec eget mauris. Sed dictum ante sed dolor pharetra, a interdum ante feugiat. Fusce dapibus, est blandit vestibulum ultricies, leo ante sagittis nisl, in pharetra velit odio non purus. Curabitur dignissim porttitor mauris, eget egestas odio feugiat ac. Phasellus et turpis quis arcu feugiat ultrices id ut velit. Curabitur feugiat aliquam orci. Praesent eu sodales erat. Proin quis nisl orci. Maecenas vulputate nibh vitae nulla facilisis, venenatis cursus massa commodo. Nullam rutrum tempus lectus sit amet tincidunt. Praesent ornare sem nec augue sodales, vel egestas ligula convallis. Morbi et dui scelerisque, dictum mi sit amet, dapibus nibh.',
          Icon(Icons.list))
      ];

      emit(LoadedState(meals));
    } catch (e) {
      emit(ErrorState());
    }
  }
}