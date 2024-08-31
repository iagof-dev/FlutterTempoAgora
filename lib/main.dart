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
        body: Column(
          children: [
            Column(
              children: [
                const Text('Digite a cidade:'),
                TextField(
                  controller: txtCidade,
                  decoration:
                      const InputDecoration(labelText: 'Digite a cidade'),
                ),
                ElevatedButton(
                    onPressed: () => verifyWeather(),
                    child: const Text('Buscar'))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  color: Colors.grey,
                  child: const Column(
                    children: [
                      Text(
                        'Temperatura:',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      Text('0°C'),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  color: Colors.grey,
                  child: const Column(
                    children: [
                      Text(
                        'Umidade:',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      Text('0%'),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  color: Colors.grey,
                  child: const Column(
                    children: [
                      Text(
                        'Vento:',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      Text('0 Km/h'),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
