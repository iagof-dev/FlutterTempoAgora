import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final txtCidade = TextEditingController();

    String temperature = '0 °C';
    String humidity = '0%';
    String wind = '0 KM/H';

    void verifyWeather() {
      if (txtCidade.text.isEmpty) {
        print('Cidade não informada');
        return;
      }
      print('Verificando clima...');
      print(txtCidade.text);
    }

    void getLocation() {
      print('Obtendo localização do dispositivo...');
    }

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Tempo Agora'),
        ),
        body: Column(
          children: [
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: txtCidade,
                    decoration:
                        const InputDecoration(labelText: 'Digite a cidade'),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        onPressed: () => verifyWeather(),
                        child: const Text('Buscar')),
                    ElevatedButton(
                        onPressed: () => getLocation(),
                        child: const Text('Localização'))
                  ],
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 120,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey),
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      const Icon(Icons.thermostat, color: Colors.white),
                      const Text(
                        'Temperatura:',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        temperature,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 120,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey),
                  child: Column(
                    children: [
                      const Icon(Icons.water, color: Colors.white),
                      const Text(
                        'Umidade:',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        humidity,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 120,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey),
                  child: Column(
                    children: [
                      const Icon(Icons.cloud, color: Colors.white),
                      const Text(
                        'Vento:',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        wind,
                        style: const TextStyle(color: Colors.white),
                      ),
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
