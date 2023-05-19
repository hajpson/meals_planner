import 'package:flutter/material.dart';

class SearchProductsView extends StatelessWidget {
  const SearchProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Container(
        width: double.maxFinite,
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Go back'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: ListView(
                shrinkWrap: true,
                children: [
                  Text('data'),
                  Text('data2'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
