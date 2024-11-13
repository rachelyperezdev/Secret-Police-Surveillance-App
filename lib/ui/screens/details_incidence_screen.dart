import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import 'package:record/record.dart';
import 'package:tarea_08/models/incidence.dart';

/// Pantalla que muestra los detalles de una incidencia, incluyendo su
/// imagen, título, fecha, descripción y controles de reproducción de audio.
/// Recibe una incidencia como parámetro para mostrar su información

class DetailsIncidenceScreen extends StatefulWidget {
  final Incidence incidence;

  const DetailsIncidenceScreen({super.key, required this.incidence});

  @override
  DetailsIncidenceState createState() => DetailsIncidenceState();
}

class DetailsIncidenceState extends State<DetailsIncidenceScreen> {
  final AudioRecorder audioRecorder = AudioRecorder();
  bool isRecording = false;
  String? _recordingPath;
  bool isPlaying = false;
  final AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();

    if (widget.incidence.audioPath.isNotEmpty) {
      setState(() {
        _recordingPath = widget.incidence.audioPath;
      });
    }

    audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        if (mounted) {
          setState(() {
            isPlaying = false;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(widget.incidence.title),
      body: Column(
        children: [
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 220,
                  child:
                      ClipRRect(child: _buildImage(widget.incidence.imagePath)),
                ),
                Container(
                  padding: const EdgeInsets.all(32),
                  width: double.infinity,
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height - 350,
                  ),
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 0, 18, 45)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTitle(widget.incidence.title),
                      const SizedBox(
                        height: 14,
                      ),
                      _buildDate(widget.incidence.date),
                      const SizedBox(
                        height: 14,
                      ),
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(8.0)),
                        child: SizedBox(
                          width: MediaQuery.sizeOf(context).width,
                          child: _buildAudioControls(),
                        ),
                      ),
                      const SizedBox(
                        height: 14,
                      ),
                      _buildDescription(widget.incidence.description),
                      const SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                )
              ],
            ),
          ))
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(String title) {
    return AppBar(
      title: Text(
        title,
        style:
            const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
      ),
      backgroundColor: const Color.fromARGB(255, 0, 18, 45),
      iconTheme: const IconThemeData(color: Colors.amber),
    );
  }

  Widget _buildImage(String imagePath) {
    if (File(imagePath).existsSync()) {
      return Image.file(
        File(imagePath),
        fit: BoxFit.cover,
      );
    } else {
      return const Icon(Icons.broken_image, size: 50, color: Colors.grey);
    }
  }

  Widget _buildTitle(String title) {
    return Text(
      title.toUpperCase(),
      style: const TextStyle(
          color: Colors.amber, fontSize: 24, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildDate(DateTime date) {
    return Text(
      DateFormat('dd/MM/yyyy').format(date),
      style:
          TextStyle(color: Colors.amber.shade100, fontStyle: FontStyle.italic),
    );
  }

  Widget _buildAudioControls() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (_recordingPath != null)
          MaterialButton(
            onPressed: () async {
              if (isPlaying) {
                await audioPlayer.stop();
                setState(() {
                  isPlaying = false;
                });
              } else {
                await audioPlayer.stop();
                await audioPlayer.setFilePath(_recordingPath!);
                audioPlayer.play();
                setState(() {
                  isPlaying = true;
                });
              }
            },
            color: Colors.amber.shade300,
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
            child: Text(
              isPlaying ? 'Detener audio' : 'Reproduce audio de la incidencia',
              style: const TextStyle(color: Color.fromARGB(255, 121, 91, 0)),
            ),
          ),
        if (_recordingPath == null)
          const Text("Esta incidencia no contiene audio",
              style: TextStyle(color: Colors.white)),
      ],
    );
  }

  Widget _buildDescription(String description) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
          color: Colors.amber, borderRadius: BorderRadius.circular(8.0)),
      child: Text(
        description,
        style: const TextStyle(
            color: Color.fromARGB(255, 121, 91, 0), fontSize: 14, height: 2),
        textAlign: TextAlign.left,
      ),
    );
  }
}
