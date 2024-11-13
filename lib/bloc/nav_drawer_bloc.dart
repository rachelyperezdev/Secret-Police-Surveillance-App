import 'package:bloc/bloc.dart';
import 'package:tarea_08/bloc/nav_drawer_event.dart';
import 'package:tarea_08/bloc/nav_drawer_state.dart';

// BloC que maneja los eventos y el estado relacionados con la navegación del drawer
class NavDrawerBloc extends Bloc<NavDrawerEvent, NavDrawerState> {
  NavDrawerBloc() : super(NavDrawerState(NavItem.homeScreen)) {
    on<NavigateTo>((event, emit) {
      if (event.destination != state.selectedItem) {
        emit(NavDrawerState(event.destination));
      }
    });
  }
}
