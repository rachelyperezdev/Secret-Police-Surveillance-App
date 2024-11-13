import 'package:flutter/material.dart';
import 'package:tarea_08/data/database_helper.dart';
import 'package:tarea_08/models/incidence.dart';

// Pantalla que permite eliminar todas las incidencias registradas
class RemoveAllIncidencesScreen extends StatefulWidget {
  const RemoveAllIncidencesScreen({super.key});

  @override
  RemoveAllIncidencesState createState() => RemoveAllIncidencesState();
}

class RemoveAllIncidencesState extends State<RemoveAllIncidencesScreen> {
  List<Incidence> incidences = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshIncidences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: isLoading
                ? _buildLoaderIndicator()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildTitle(),
                      const SizedBox(
                        height: 20,
                      ),
                      if (incidences.isEmpty)
                        const Center(
                          child: Text(
                            "No hay incidencias registradas",
                            style: TextStyle(fontSize: 16, color: Colors.amber),
                          ),
                        )
                      else
                        Column(
                          children: [
                            _buildRemoveButton(),
                            const SizedBox(height: 20),
                          ],
                        ),
                    ],
                  )));
  }

  Widget _buildLoaderIndicator() {
    return const Center(
      child: CircularProgressIndicator(
        color: Colors.amber,
      ),
    );
  }

  Widget _buildTitle() {
    return const Text(
      "Incidencias",
      style: TextStyle(
          color: Colors.amber, fontSize: 24, fontWeight: FontWeight.bold),
    );
  }

  Future<void> refreshIncidences() async {
    setState(() {
      isLoading = true;
    });

    final newIncidences = await DatabaseHelper.instance.getIncidences();

    setState(() {
      incidences = newIncidences;
      isLoading = false;
    });
  }

  Future<bool> deleteAllIncidences() async {
    await DatabaseHelper.instance.deleteAllIncidences();
    return true;
  }

  Widget _buildRemoveButton() {
    return ElevatedButton(
      onPressed: _showDeleteConfirmationDialog,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.amber,
      ),
      child: const Text(
        "Eliminar todas las incidencias",
        style: TextStyle(color: const Color.fromARGB(255, 0, 18, 45)),
      ),
    );
  }

  Future<void> _showDeleteConfirmationDialog() async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: const Color.fromARGB(255, 0, 18, 45),
            title: const Text(
              'Eliminar Todas las Incidencias',
              style:
                  TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
            ),
            content: Text(
              '¿Estás seguro que deseas eliminar todas las incidencias registradas?',
              style: TextStyle(color: Colors.amber.shade600),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancelar',
                    style: TextStyle(
                        color: Colors.amber.shade600,
                        fontWeight: FontWeight.bold),
                  )),
              ElevatedButton(
                  onPressed: () async {
                    await deleteAllIncidences();
                    Navigator.of(context).pop();

                    if (mounted) {
                      refreshIncidences();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                            'Todas las incidencias han sido eliminadas.',
                            style: TextStyle(
                                color: const Color.fromARGB(255, 0, 71, 61)),
                          ),
                          backgroundColor: Colors.tealAccent.shade400,
                        ),
                      );
                    }
                  },
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                  child: const Text(
                    'Eliminar',
                    style: TextStyle(color: Color.fromARGB(255, 121, 91, 0)),
                  ))
            ],
          );
        });
  }
}
