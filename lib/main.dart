import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:math';

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
          ],
        ),
      ),
    );
  }
}
