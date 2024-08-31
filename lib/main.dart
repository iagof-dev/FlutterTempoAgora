import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final txtCidade = TextEditingController();

    LocationData? _currentLocation;
    Location location = Location();

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

    Future<void> _getLocation() async {
      bool _serviceEnabled;
      PermissionStatus _permissionGranted;

      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          return;
        }
      }

      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          return;
        }
      }

      _currentLocation = await location.getLocation();
    }

    void getLocation() async {
      print('Obtendo localização do dispositivo...');
      // var url = Uri.https(
      //     'marciossupiais.shop', '/tcc/alunos/listar/', {'q': '{http}'});
      // var response = await http.get(url);
      // if (response.statusCode != 200 || response.body.isEmpty) {
      //   print('erro na requisição');
      //   return;
      // }
      // var jsonResponse =
      //     convert.jsonDecode(response.body) as Map<String, dynamic>;
      // for (var item in jsonResponse['DATA']) {
      //   print(item['nome']);
      // }
      await _getLocation();
      print(_currentLocation);
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
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 1, 0, 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                          width: 150,
                          child: ElevatedButton(
                              onPressed: () => verifyWeather(),
                              child: const Text('Buscar'))),
                      SizedBox(
                          width: 150,
                          child: ElevatedButton(
                              onPressed: () => getLocation(),
                              child: const Text('Localização')))
                    ],
                  ),
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
            ),
          ],
        ),
      ),
    );
  }
}
