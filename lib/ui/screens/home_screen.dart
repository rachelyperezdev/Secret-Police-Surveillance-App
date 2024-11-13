import 'package:flutter/material.dart';
import 'package:tarea_08/data/database_helper.dart';
import 'package:tarea_08/models/incidence.dart';
import 'package:tarea_08/ui/screens/add_incidence_screen.dart';
import 'package:tarea_08/ui/screens/details_incidence_screen.dart';
import 'package:tarea_08/ui/widgets/incidence_card_widget.dart';

// Pantalla principal que muestra la lista de incidencias registradas
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<HomeScreen> {
  List<Incidence> incidences = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshIncidences();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const SizedBox(
            height: 4,
          ),
          Expanded(
              child: isLoading
                  ? _buildLoaderIndicator()
                  : incidences.isEmpty
                      ? _buildEmptyMessage()
                      : _buildAllIncidences()),
          const SizedBox(
            height: 4,
          ),
        ],
      ),
    );
  }

  //

  Widget _buildLoaderIndicator() {
    return const Center(
      child: CircularProgressIndicator(
        color: Colors.amber,
      ),
    );
  }

  Widget _buildEmptyMessage() {
    return const Center(
      child: Text(
        'No hay incidencias registradas',
        style: TextStyle(color: Colors.amber),
      ),
    );
  }

  _buildAllIncidences() => GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: (100 / 140),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12),
      scrollDirection: Axis.vertical,
      itemCount: incidences.length,
      itemBuilder: (context, index) {
        final incidence = incidences[index];

        return GestureDetector(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetailsIncidenceScreen(
                        incidence: incidence,
                      ))),
          child: IncidenceCard(
            incidence: incidence,
          ),
        );
      });

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
}
