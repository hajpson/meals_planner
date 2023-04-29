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
                            maxLength: 10000,
                            maxLines: 10,
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
                        alignment: Alignment.center,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            backgroundColor: secondaryColor,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)
                            ),
                            shadowColor: Color.fromARGB(53, 0, 0, 0)
                          ),
                          onPressed: () {
                            showDialog(
                              context: context, 
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: Stack(
                                    children: [
                                      Positioned(
                                        right: -40,
                                        top: -40,
                                        child: InkResponse(
                                          onTap: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: CircleAvatar(
                                            child: Icon(Icons.close),
                                            backgroundColor: Colors.red,
                                          ),
                                        )
                                      ),
                                      Form(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: TextFormField(),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: TextFormField(),
                                            ),
                                    ],
                                  ),
                                )
                              ]
                            )
                          );
                        }
                      );
                    },
                    child: Text(
                      'Press to add product for meal',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color.fromARGB(212, 255, 255, 255)
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