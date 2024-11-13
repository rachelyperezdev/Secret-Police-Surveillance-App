import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tarea_08/models/incidence.dart';

// Widget que representa una tarjeta con la información de una incidencia

class IncidenceCard extends StatefulWidget {
  final Incidence incidence;

  const IncidenceCard({super.key, required this.incidence});

  @override
  IncidenceState createState() => IncidenceState();
}

class IncidenceState extends State<IncidenceCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 2,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.blue.withOpacity(0.01)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Stack(
          children: [
            Positioned.fill(child: _buildImage(widget.incidence.imagePath)),
            _buildTitleContainer(widget.incidence.title),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(String imagePath) {
    if (File(imagePath).existsSync()) {
      return Image.file(
        File(imagePath),
        fit: BoxFit.cover,
      );
    } else {
      return const Icon(Icons.broken_image, size: 50, color: Colors.amber);
    }
  }

  Widget _buildTitleContainer(String title) {
    return Positioned(
        bottom: 10,
        right: 4,
        left: 4,
        child: Container(
          padding: const EdgeInsets.all(8.0),
          color: const Color.fromARGB(165, 0, 18, 45),
          child: Text(
            widget.incidence.title,
            style: const TextStyle(
                color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 12),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ));
  }
}
