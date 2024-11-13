import 'dart:io';

import 'package:flutter/material.dart';

/// Pantalla que muestra la información de un oficial de seguridad,
/// incluyendo su imagen, nombre, matrícula y una cita relacionada con la seguridad

class AboutOfficerScreen extends StatelessWidget {
  /// Ruta de la imagen del oficial.
  final officerImagePath = 'assets/images/yo.png';

  /// Nombre del oficial.
  final officerName = 'RACHELY PÉREZ';

  /// Matrícula del oficial.
  final officerTuition = '2022-1856';

  /// Cita sobre la seguridad.
  final securityQuote =
      "El verdadero valor de la seguridad no está en la ausencia de peligros, sino en la presencia de quienes, con integridad y compromiso, velan por el bienestar de todos.";

  const AboutOfficerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 24),
              _buildOfficerImage(officerImagePath),
              Container(
                padding: const EdgeInsets.all(32),
                width: double.infinity,
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - 350,
                ),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 0, 18, 45),
                ),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildOfficerName(officerName),
                      const SizedBox(height: 8),
                      _buildOfficerTuition(officerTuition),
                      const SizedBox(height: 8),
                      _buildSecurityQuote(securityQuote),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOfficerImage(String imagePath) {
    return Container(
      width: 200,
      height: 200,
      child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.asset(imagePath, fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.broken_image,
                size: 50, color: Colors.amber);
          })),
    );
  }

  Widget _buildOfficerName(String name) {
    return Text(
      officerName,
      style: const TextStyle(
        color: Color.fromARGB(255, 121, 91, 0),
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    );
  }

  Widget _buildOfficerTuition(String tuition) {
    return Row(
      children: [
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.amber.shade300,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.numbers,
                  color: Color.fromARGB(255, 121, 91, 0),
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  tuition,
                  style: const TextStyle(
                      color: Color.fromARGB(255, 121, 91, 0),
                      fontSize: 12,
                      fontStyle: FontStyle.italic),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSecurityQuote(String quote) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.amber.shade300,
        borderRadius: BorderRadius.circular(8.0),
        border: const Border(
          left: BorderSide(color: Color.fromARGB(255, 121, 91, 0), width: 4.0),
        ),
      ),
      child: Text(
        quote,
        style: const TextStyle(
            color: Color.fromARGB(255, 121, 91, 0),
            fontSize: 12,
            fontStyle: FontStyle.italic),
        textAlign: TextAlign.left,
      ),
    );
  }
}
