import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meals_planner/models/NavbarItem.dart';

part 'main_navigation_state.dart';

class MainNavigationCubit extends Cubit<MainNavigationState> {
  MainNavigationCubit() : super(MainNavigationState(NavbarItem.meals, 0));

  void setNavBartItem(NavbarItem navbarItem) {
    switch (navbarItem) {
      case NavbarItem.meals:
        emit(MainNavigationState(NavbarItem.meals, 0));
        break;
      case NavbarItem.settings:
        emit(MainNavigationState(NavbarItem.settings, 1));
        break;
      case NavbarItem.products:
        emit(MainNavigationState(NavbarItem.products, 2));
        break;
    }
  }
}
