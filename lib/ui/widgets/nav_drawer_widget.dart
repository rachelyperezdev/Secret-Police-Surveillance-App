import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarea_08/bloc/nav_drawer_bloc.dart';
import 'package:tarea_08/bloc/nav_drawer_event.dart';
import 'package:tarea_08/bloc/nav_drawer_state.dart';

// Representa el elemento de navegación
class _NavigationItem {
  final NavItem item;
  final String title;
  final IconData icon;

  _NavigationItem(this.item, this.title, this.icon);
}

class NavDrawerWidget extends StatelessWidget {
  NavDrawerWidget({super.key});

  // Lista de los ítems que aparecerán en el drawer. Cada ítem tiene un NavItem, un título y un ícono
  final List<_NavigationItem> _listItems = [
    _NavigationItem(NavItem.homeScreen, "Incidencias", Icons.home),
    _NavigationItem(NavItem.addIncidenceScreen, "Añadir Incidencia", Icons.add),
    _NavigationItem(NavItem.removeAllIncidencesScreen, "Eliminar Incidencias",
        Icons.delete),
    _NavigationItem(NavItem.aboutOfficerScreen, "Acerca del Oficial",
        Icons.admin_panel_settings_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color.fromARGB(255, 0, 18, 45),
      child: Column(
        children: [
          const UserAccountsDrawerHeader(
            accountName: Text('Rachely Pérez',
                style: TextStyle(
                    color: Colors.amber, fontWeight: FontWeight.bold)),
            accountEmail: Text(
              '2022-1856',
              style: TextStyle(
                  color: Color.fromARGB(255, 255, 230, 155),
                  fontStyle: FontStyle.italic),
            ),
            decoration:
                BoxDecoration(color: const Color.fromARGB(255, 0, 18, 45)),
          ),
          ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: _listItems.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) =>
                  BlocBuilder<NavDrawerBloc, NavDrawerState>(
                      builder: (BuildContext context, NavDrawerState state) =>
                          _buildItem(_listItems[index], state)))
        ],
      ),
    );
  }

  Widget _buildItem(_NavigationItem data, NavDrawerState state) =>
      _makeListItem(data, state);

  Widget _makeListItem(_NavigationItem data, NavDrawerState state) => Card(
        color: const Color.fromARGB(255, 0, 18, 45),
        shape: const ContinuousRectangleBorder(borderRadius: BorderRadius.zero),
        borderOnForeground: true,
        elevation: 0,
        margin: EdgeInsets.zero,
        child: Builder(
            builder: (BuildContext context) => ListTile(
                  title: Text(
                    data.title,
                    style: TextStyle(
                        fontWeight: data.item == state.selectedItem
                            ? FontWeight.bold
                            : FontWeight.w300,
                        color: data.item == state.selectedItem
                            ? Colors.amber
                            : Colors.amber.shade100),
                  ),
                  leading: Icon(
                    data.icon,
                    color: data.item == state.selectedItem
                        ? Colors.amber
                        : Colors.amber.shade100,
                  ),
                  onTap: () => _handleItemClick(context, data.item),
                )),
      );

  void _handleItemClick(BuildContext context, NavItem item) {
    BlocProvider.of<NavDrawerBloc>(context).add(NavigateTo(item));
    Navigator.pop(context);
  }
}
