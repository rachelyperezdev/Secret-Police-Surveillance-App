import 'package:equatable/equatable.dart';

// Ítems de navegación disponibles en el Drawer
enum NavItem {
  homeScreen,
  addIncidenceScreen,
  removeAllIncidencesScreen,
  aboutOfficerScreen
}

// Representa el estado del Drawer de navegación, contiene el ítem seleccionado
class NavDrawerState extends Equatable {
  final NavItem selectedItem;

  const NavDrawerState(this.selectedItem);

  @override
  List<Object?> get props => [
        selectedItem,
      ];
}
