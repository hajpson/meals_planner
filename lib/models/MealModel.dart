import 'package:flutter/cupertino.dart';

class MealModel {
  late int id;
  late String mealName;
  late String mealDescription;
  late Icon icon;

  MealModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    mealName = map['mealName'];
    mealDescription = map['mealDescription'];
    icon = Icon(IconData(int.parse(map['icon']), fontFamily: 'MaterialIcons'));
  }

  MealModel(
    int id, 
    String mealName,
    String mealDesc,
    Icon icon) {
    this.id = id;
    this.mealName = mealName;
    this.mealDescription = mealDesc;
    this.icon = icon;
  }
}