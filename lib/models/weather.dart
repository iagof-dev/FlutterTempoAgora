class WeatherModel {
  final int id;
  final int temperature;
  final int humidity;
  final int wind;

  const WeatherModel({
    required this.id,
    required this.temperature,
    required this.humidity,
    required this.wind,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'temperature': temperature,
      'humidity': humidity,
      'wind': wind,
    };
  }

  @override
  String toString() {
    return 'Weather{id: $id, temperature: $temperature, humidity: $humidity, wind: $wind}';
  }
}
