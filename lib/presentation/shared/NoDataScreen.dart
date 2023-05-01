import 'package:flutter/material.dart';
import 'package:meals_planner/constants/colors.dart';

class NoDataScreen extends StatefulWidget {
  const NoDataScreen({super.key, required String this.usedPage});

  final String usedPage;

  @override
  State<NoDataScreen> createState() => _NoDataScreenState();
}

class _NoDataScreenState extends State<NoDataScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    controller.forward();

    controller.addListener(() {
      if (controller.isCompleted) {
        Future.delayed(Duration(seconds: 2), () {
          controller.reverse();
        });
      }

      if (controller.isDismissed) {
        controller.forward();
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  double shake(double value) =>
      2 * (0.5 - (0.5 - Curves.easeInSine.transform(value).abs()));

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
                animation: controller,
                builder: (context, child) => Transform.translate(
                    offset: Offset(0, 5 * shake(controller.value)),
                    child: child),
                child: Padding(
                  padding: EdgeInsets.only(bottom: 50),
                  child: Image(
                      width: 100,
                      image: widget.usedPage == "Meals"
                          ? AssetImage('images/no_data_image.png')
                          : AssetImage('images/shopping_basket_cross.png')),
                )),
            Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: Text(
                widget.usedPage == "Meals"
                    ? "Oops!\nLooks like your meals list is empty.\nTry to add new meal first 😊"
                    : "Hmm ...\nYou haven't added any product yet.\nAdd new product first 😊",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(192, 65, 65, 65)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
