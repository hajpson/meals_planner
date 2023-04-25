import 'package:flutter/material.dart';
import 'package:meals_planner/constants/colors.dart';

class NewMealScreen extends StatefulWidget {
  const NewMealScreen({super.key});

  @override
  State<NewMealScreen> createState() => _NewMealScreen();
}

class _NewMealScreen extends State<NewMealScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
          physics: BouncingScrollPhysics(),
          children: [Column(
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
                          borderRadius: BorderRadius.circular(12)
                        ),
                        shadowColor: Color.fromARGB(53, 0, 0, 0)
                      ),
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
                                color: Color.fromARGB(212, 255, 255, 255)
                              ),
                            ),
                          ),
                        ],
                      )
                    ),
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
                          borderRadius: new BorderRadius.circular(16)
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(left: 15, right: 15, top: 5),
                          child: TextFormField(
                            cursorColor: secondaryColor,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              labelText: 'Meal name',
                              labelStyle: TextStyle(
                                color: secondaryColor
                              )
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: lightGrayColor,
                          borderRadius: new BorderRadius.circular(16)
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(left: 15, right: 15, top: 5),
                          child: TextFormField(
                            maxLength: 250,
                            maxLines: 4,
                            cursorColor: secondaryColor,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              alignLabelWithHint: true,
                              labelText: 'Meal short description',
                              labelStyle: TextStyle(
                                color: secondaryColor
                              )
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: lightGrayColor,
                          borderRadius: new BorderRadius.circular(16)
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(left: 15, right: 15, top: 5),
                          child: TextFormField(
                            maxLength: 10000,
                            maxLines: 12,
                            cursorColor: secondaryColor,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              labelText: 'Meal long description',
                              alignLabelWithHint: true,
                              labelStyle: TextStyle(
                                color: secondaryColor
                              )
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          )],
        ),
      ),
    );
  }
}