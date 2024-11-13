// Rachely Esther Pérez Del Villar | 2022-1856

// Este archivo inicializa la aplicación Flutter y configura la base de datos local
// para ser utilizada en sistemas operativos Windows y Linux mediante sqflite con FFI.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:tarea_08/mainwrapper.dart';

void main() {
  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Incidencias_20221856',
      theme: ThemeData(
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(),
        scaffoldBackgroundColor: const Color.fromARGB(255, 0, 18, 45),
      ),
      home: const Banner(
        message: '',
        location: BannerLocation.topEnd,
        child: MainWrapper(),
      ),
    );
  }
}
