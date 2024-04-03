import 'package:flutter/material.dart';
import 'package:gerenciador_tarefas/pages/filtro_pages.dart';
import 'package:gerenciador_tarefas/pages/lista_pages_tarefas.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gerenciador de Tarefas',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: ListaTarefaPage(),
      routes: {
        FiltroPage
            .ROUTE_NAME: (BuildContext context) => FiltroPage(),
      }
    );
  }
}
