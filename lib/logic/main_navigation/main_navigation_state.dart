part of 'main_navigation_cubit.dart';

class MainNavigationState extends Equatable {
  final NavbarItem navbarItem;
  final int index;

  MainNavigationState(this.navbarItem, this.index);

  @override
  List<Object> get props => [this.navbarItem, this.index];
}
