import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:meals_planner/constants/colors.dart';
import 'package:meals_planner/logic/meals/meals_cubit.dart';
import '../../logic/meals/meals_state.dart';

class MealsScreen extends StatefulWidget {
  const MealsScreen({super.key});

  @override
  State<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Container(
           child : BlocBuilder<MealsCubit, MealsState>(
            builder: (context, state) {
              if (state is LoadingState) {
                return Center(
                  child: SpinKitThreeBounce(
                    color: middleColor
                  ),
                );
              } else if (state is ErrorState) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Something went wrong'),
                      Icon(Icons.close)
                    ]
                  ),
                );
              } else if (state is LoadedState) {
                final meals = state.meals;

                return ListView.builder(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 12),
                  physics: BouncingScrollPhysics(),
                  itemCount: meals.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.fromLTRB(12,12,12,0),
                    child: ListTile(
                      tileColor: lightGrayColor,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 0, color: lightGrayColor),
                        borderRadius: BorderRadius.circular(20)
                      ),
                      title: Text(
                        meals[index].mealName,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: primaryColor,
                          fontSize: 20
                        ),
                      ),
                      subtitle: Text(
                        meals[index].mealDescription,
                        style: TextStyle(
                          fontSize: 16
                        ),
                      ),
                      trailing: SizedBox(
                        child: meals[index].icon,
                      ),
                    ),
                  )
                );
              } else {
                return Container();
              }
            },
           ),
          )
        ),
      ),
    );
  }
}