import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarea_08/bloc/nav_drawer_bloc.dart';
import 'package:tarea_08/bloc/nav_drawer_state.dart';
import 'package:tarea_08/ui/screens/about_officer_screen.dart';
import 'package:tarea_08/ui/screens/add_incidence_screen.dart';
import 'package:tarea_08/ui/screens/home_screen.dart';
import 'package:tarea_08/ui/screens/remove_incidences_screen.dart';
import 'package:tarea_08/ui/widgets/nav_drawer_widget.dart';

// Rachely Esther Pérez Del Villar | 2022-1856

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  MainWrapperState createState() => MainWrapperState();
}

class MainWrapperState extends State<MainWrapper> {
  late NavDrawerBloc _bloc;

  late Widget _content;

  @override
  void initState() {
    super.initState();
    _bloc = NavDrawerBloc();
    _content = _getContentForState(_bloc.state.selectedItem);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NavDrawerBloc>(
      create: (BuildContext context) => _bloc,
      child: BlocConsumer<NavDrawerBloc, NavDrawerState>(
        listener: (BuildContext context, NavDrawerState state) {
          _content = _getContentForState(state.selectedItem);
        },
        buildWhen: (previous, current) {
          return previous.selectedItem != current.selectedItem;
        },
        listenWhen: (previous, current) {
          return previous.selectedItem != current.selectedItem;
        },
        builder: (BuildContext context, NavDrawerState state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                _getAppBarTitle(state.selectedItem),
                style: const TextStyle(
                    color: Colors.amber,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              iconTheme: const IconThemeData(color: Colors.amber),
              backgroundColor: const Color.fromARGB(255, 0, 24, 59),
            ),
            drawer: NavDrawerWidget(),
            body: AnimatedSwitcher(
              switchInCurve: Curves.fastLinearToSlowEaseIn,
              switchOutCurve: Curves.linearToEaseOut,
              duration: const Duration(milliseconds: 400),
              child: _content,
            ),
          );
        },
      ),
    );
  }

  Widget _getContentForState(NavItem selectedItem) {
    switch (selectedItem) {
      case NavItem.homeScreen:
        return const HomeScreen();
      case NavItem.addIncidenceScreen:
        return const AddIncidenceScreen();
      case NavItem.removeAllIncidencesScreen:
        return const RemoveAllIncidencesScreen();
      case NavItem.aboutOfficerScreen:
        return const AboutOfficerScreen();
      default:
        return Container();
    }
  }

  String _getAppBarTitle(NavItem selectedItem) {
    switch (selectedItem) {
      case NavItem.homeScreen:
        return "Incidencias";
      case NavItem.addIncidenceScreen:
        return "Añadir Incidencia";
      case NavItem.removeAllIncidencesScreen:
        return "Eliminar Incidencias";
      case NavItem.aboutOfficerScreen:
        return "Acerca del Oficial";
      default:
        return "Incidencias";
    }
  }
}
