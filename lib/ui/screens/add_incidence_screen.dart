import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:record/record.dart';
import 'package:tarea_08/data/database_helper.dart';
import 'package:tarea_08/mainwrapper.dart';
import 'package:tarea_08/models/incidence.dart';

// Pantalla para agregar una nueva incidencia
class AddIncidenceScreen extends StatefulWidget {
  const AddIncidenceScreen({super.key});

  @override
  AddIncidenceState createState() => AddIncidenceState();
}

class AddIncidenceState extends State<AddIncidenceScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _selectedDate;
  String _imagePath = '';

  final AudioRecorder audioRecorder = AudioRecorder();
  bool isRecording = false;
  String? _recordingPath;
  bool isPlaying = false;
  final AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                buildTextField(
                    controller: _titleController,
                    labelText: "Título",
                    errorText: "Debe ingresar un título"),
                const SizedBox(height: 4),
                buildTextField(
                    controller: _descriptionController,
                    labelText: "Descripción",
                    errorText: "Debe ingresar una descripción"),
                const SizedBox(height: 20),
                buildDatePicker(),
                const SizedBox(
                  height: 20,
                ),
                buildImageSelector(),
                const SizedBox(
                  height: 20,
                ),
                buildAudioControls(),
                const SizedBox(
                  height: 20,
                ),
                buildSaveButton(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: _recordingButton(),
    );
  }

  Widget buildTextField(
      {required TextEditingController controller,
      required String labelText,
      required String errorText}) {
    return TextFormField(
      controller: controller,
      maxLines: null,
      cursorColor: Colors.amber,
      style: TextStyle(color: Colors.amber.shade100),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.amber),
        enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.amber)),
        focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.amber, width: 3.0)),
      ),
      validator: (title) {
        if (title == null || title.isEmpty) {
          return errorText;
        }

        return null;
      },
    );
  }

  Widget buildDatePicker() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
            child: Text(
          _selectedDate == null
              ? 'No ha seleccionado una fecha'
              : DateFormat('dd/MM/yyyy').format(_selectedDate!),
          style: TextStyle(
              color:
                  _selectedDate == null ? Colors.red.shade400 : Colors.amber),
        )),
        const SizedBox(
          width: 6,
        ),
        Expanded(
            child: TextButton(
                onPressed: _selectDate,
                child: const Text(
                  'Seleccione una fecha',
                  style: TextStyle(
                      color: Colors.amber, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.right,
                )))
      ],
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picker = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.amber,
              onPrimary: Color.fromARGB(255, 0, 18, 45),
              surface: Color.fromARGB(255, 0, 18, 45),
              onSurface: Colors.amber,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.amber,
              ),
            ),
            dialogBackgroundColor: const Color.fromARGB(255, 0, 18, 45),
          ),
          child: child!,
        );
      },
    );

    if (picker != null) {
      setState(() {
        _selectedDate = picker;
      });
    }
  }

  Widget buildImageSelector() {
    return GestureDetector(
      onTap: _selectImage,
      child: Container(
          width: double.infinity,
          height: 300,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              border: const Border(
                top: BorderSide(color: Colors.amber),
                left: BorderSide(color: Colors.amber),
                right: BorderSide(color: Colors.amber),
                bottom: BorderSide(color: Colors.amber),
              ),
              color: const Color.fromARGB(255, 0, 18, 65)),
          child: _imagePath.isEmpty
              ? const Center(
                  child: Text(
                    "Seleccione una imagen",
                    style: TextStyle(
                        color: Colors.amber, fontWeight: FontWeight.bold),
                  ),
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: ClipRRect(
                    child: Image.file(
                      File(_imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                )),
    );
  }

  Widget buildAudioControls() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (_recordingPath != null)
            MaterialButton(
              onPressed: _tooglePlayback,
              color: Colors.amber.shade300,
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: Text(
                isPlaying
                    ? 'Detener audio'
                    : 'Reproduce audio de la incidencia',
                style: const TextStyle(color: Color.fromARGB(255, 121, 91, 0)),
              ),
            ),
          if (_recordingPath == null)
            const Text("Ingrese un audio",
                style: TextStyle(color: Colors.amber)),
        ],
      ),
    );
  }

  Widget _recordingButton() {
    return FloatingActionButton(
      onPressed: _toogleRecording,
      backgroundColor: Colors.amber,
      child: Icon(
        isRecording ? Icons.stop : Icons.mic,
        color: const Color.fromARGB(255, 0, 18, 85),
      ),
    );
  }

  Future<void> _tooglePlayback() async {
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
  }

  Future<void> _toogleRecording() async {
    if (isRecording) {
      String? filePath = await audioRecorder.stop();

      if (filePath != null) {
        setState(() {
          isRecording = false;
          _recordingPath = filePath;
        });
      }
    } else {
      if (await audioRecorder.hasPermission()) {
        final Directory appDocumentDir =
            await getApplicationDocumentsDirectory();
        final String timestamp =
            DateTime.now().millisecondsSinceEpoch.toString();
        final String filePath =
            p.join(appDocumentDir.path, "recording_$timestamp.wav");
        await audioRecorder.start(const RecordConfig(), path: filePath);
        setState(() {
          isRecording = true;
          _recordingPath = null;
        });
      }
    }
  }

  Widget buildSaveButton() {
    return MaterialButton(
      onPressed: _addIncidence,
      color: Colors.amber,
      child: const Text(
        'Guardar',
        style: TextStyle(color: Color.fromARGB(255, 0, 18, 45)),
      ),
    );
  }

  Future<void> _addIncidence() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Por favor, seleccione una fecha."),
          backgroundColor: Colors.red.shade400,
        ),
      );
      return;
    }

    if (_recordingPath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Por favor, grabe un audio para la incidencia."),
          backgroundColor: Colors.red.shade400,
        ),
      );
      return;
    }

    final Incidence incidence = Incidence(
      title: _titleController.text,
      description: _descriptionController.text,
      date: _selectedDate!,
      imagePath: _imagePath,
      audioPath: _recordingPath!,
    );

    await DatabaseHelper.instance.insertIncidence(incidence);
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const MainWrapper()),
      (Route<dynamic> route) => false,
    );
  }

  Future<void> _selectImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _imagePath = image.path;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("No se seleccionó ninguna imagen."),
          backgroundColor: Colors.red.shade400,
        ),
      );
    }
  }
}
