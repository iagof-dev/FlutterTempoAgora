import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final txtCidade = TextEditingController();

  void verifyWeather() {
    print('Verificando clima...');
    print(txtCidade.text);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Tempo Agora'),
        ),
        body: Center(
          child: Column(
            children: [
              const Text('Digite a cidade:'),
              TextField(
                controller: txtCidade,
                decoration: const InputDecoration(labelText: 'Digite a cidade'),
              ),
              ElevatedButton(
                  onPressed: () => verifyWeather(), child: const Text('Buscar'))
            ],
          ),
        ),
      ),
    );
  }
}
