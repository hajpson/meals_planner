import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../constants/colors.dart';
import '../../logic/products/products_cubit.dart';
import '../../logic/products/products_state.dart';
import '../shared/NoDataScreen.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return SafeArea(
      child: Scaffold(
        floatingActionButton: Material(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: primaryColor, width: 2)
          ),
          child: InkWell(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.add, size: 30, color: primaryColor,),
            ),
            onTap: () => {
              
            },
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        body: Center(
          child: Container(
            child: BlocBuilder<ProductsCubit, ProductsState>(
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
                  final products = state.products;

                  return ListView.builder(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 12),
                    physics: BouncingScrollPhysics(),
                    itemCount: products.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                      child: ListTile(
                        tileColor: lightGrayColor,
                        shape: RoundedRectangleBorder(
                        side: BorderSide(width: 0, color: lightGrayColor),
                        borderRadius: BorderRadius.circular(20)
                      ),
                      title: Text(
                        products[index].name,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: primaryColor,
                          fontSize: 20
                        ),
                      ),
                      subtitle: Text(
                        products[index].shortDescription,
                        style: TextStyle(
                          fontSize: 16
                        ),
                      ),
                    ),
                  )
                  );
                }
                else {
                  return NoDataScreen();
                }
              },
            ),
          )
        ),
      ),
    );
  }
}