import 'package:flutter/material.dart';
import 'package:ft_tempoagora/helpers/db.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final txtLon = TextEditingController();
  final txtLat = TextEditingController();

  LocationData? currentLocation;
  Location location = Location();

  String temperature = '0 °C';
  String humidity = '0%';
  String wind = '0 KM/H';

  String lon = '';
  String lat = '';
  String apiKey = '';

  Future<List<Map<String, dynamic>>> historyWeather = Future.value([]);

  bool isLoading = false;

  void verifyWeather() async {
    if (isLoading) {
      Fluttertoast.showToast(
          msg: "Aguarde a busca da localização.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }

    if (lat.isEmpty || lon.isEmpty) {
      if (txtLat.text.isEmpty ||
          txtLat.text == '' && txtLon.text.isEmpty ||
          txtLon.text == '') {
        Fluttertoast.showToast(
            msg: "Houve um erro!\nLocalização não buscada/informada.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        return;
      }
      lat = txtLat.text;
      lon = txtLon.text;
    }

    Fluttertoast.showToast(
        msg: "Buscando clima...",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.orange,
        textColor: Colors.white,
        fontSize: 16.0);

    var url =
        'https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current=temperature_2m,relative_humidity_2m,apparent_temperature,wind_speed_10m';
    var response = await http.get(Uri.parse(url));
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode != 200 || response.body.isEmpty) {
      Fluttertoast.showToast(
          msg:
              "Houve um erro!\nRequisição falhou! (${response.statusCode})\n ${jsonResponse['reason']}.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }

    setState(() {
      temperature = '${jsonResponse['current']['temperature_2m'].round()} °C';
      humidity = '${jsonResponse['current']['relative_humidity_2m'].round()} %';
      wind = '${jsonResponse['current']['wind_speed_10m'].round()} KM/H';
    });
  }

  Future<void> getGeoLoc() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    currentLocation = await location.getLocation();
    setState(() {
      lat = currentLocation!.latitude.toString();
      lon = currentLocation!.longitude.toString();
    });
  }

  void getLocation() async {
    setState(() {
      isLoading = true;
    });
    Fluttertoast.showToast(
        msg: "Obtendo localização do dispositivo...",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.orange,
        textColor: Colors.white,
        fontSize: 16.0);

    await getGeoLoc();

    txtLat.text = lat;
    txtLon.text = lon;
    Fluttertoast.showToast(
        msg: "Localização Obtida com sucesso!\n($lat, $lon)",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);

    setState(() {
      isLoading = false;
    });
  }

  void SqlLiteTest_Insert() async {
    debugPrint('Inserindo...');
    if (DB.instance.database != null) {
      DB.instance.database.then((db) async {
        debugPrint('Banco de Dados está criado!');
        await DbController().insert('weatherHistory', {
          'temp': 25,
          'humidity': 80,
          'wind': 10,
          'time': DateTime.now().toIso8601String()
        });
      });
      debugPrint('Aparentemente inserido');
    } else {
      debugPrint('DB SQLITE não inicializado.');
    }
  }

  void SqlLiteTest_ListAll() async {
    debugPrint('Consultando...');
    if (DB.instance.database != null) {
      debugPrint('Banco de Dados está criado!');
      var response = await DbController().queryOrder('weatherHistory');
      debugPrint(response.toString());
    } else {
      debugPrint('DB SQLITE não inicializado.');
    }
    updateHistory();
  }

  void updateHistory() async {
    var result = await DbController().queryOrder('weatherHistory');
    setState(() {
      historyWeather = Future.value(result);
    });
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
            Row(
              children: [
                ElevatedButton(
                    onPressed: SqlLiteTest_Insert,
                    child: Text('SqlLiteTest_Insert')),
                ElevatedButton(
                    onPressed: SqlLiteTest_ListAll,
                    child: Text('SqlLiteTest_ListAll'))
              ],
            ),
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(children: [
                    TextField(
                      controller: txtLon,
                      decoration:
                          const InputDecoration(labelText: 'Longitude:'),
                    ),
                    TextField(
                      controller: txtLat,
                      decoration: const InputDecoration(labelText: 'Latitude:'),
                    ),
                  ]),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 1, 0, 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                          width: 200,
                          child: ElevatedButton(
                              onPressed: verifyWeather,
                              child: const Text('Buscar'))),
                      SizedBox(
                          width: 200,
                          child: ElevatedButton(
                              onPressed: getLocation,
                              child: const Text('Obter Localização')))
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
            const Text(
              'Histórico:',
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Temp',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    'Humidity',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    'Wind',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    'Tempo',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
            ),
            FutureBuilder(
                future: historyWeather,
                builder: (ctx, snp) {
                  if (snp.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snp.hasError) {
                    return Text("Erro: ${snp.error}");
                  } else if (!snp.hasData || snp.data!.isEmpty) {
                    return Text("Sem dados registrados");
                  }
                  final data = snp.data!;
                  return Expanded(
                    child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final row = data[index];
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(join(row['temp'].toString(), "°C")),
                            Text(row['humidity'].toString()),
                            Text(row['wind'].toString()),
                            Text(row['time'].toString()),
                          ],
                        );
                      },
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
