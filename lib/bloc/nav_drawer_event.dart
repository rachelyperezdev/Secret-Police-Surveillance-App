import 'package:equatable/equatable.dart';
import 'package:tarea_08/bloc/nav_drawer_state.dart';

// Clase base para los eventos relacionados con la navegación del drawer
sealed class NavDrawerEvent extends Equatable {
  const NavDrawerEvent();
}

// Evento que indica que se debe navegar a una nueva pantalla específica
class NavigateTo extends NavDrawerEvent {
  final NavItem destination;

  const NavigateTo(this.destination);

  @override
  List<Object?> get props => [destination];
}
