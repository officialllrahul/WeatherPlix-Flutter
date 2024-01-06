import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:weatherflix/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}

class WeatherApp extends StatefulWidget {
  @override
  _WeatherAppState createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  TextEditingController _cityController = TextEditingController(text: 'Patna');
  String _locationInfo = '';
  String _weather = '';
  String _temperature = '';
  String _humidity = '';
  String _backgroundImage = 'assets/default_background.jpg';
  String _minMaxTemperature = '';


  // Future<void> _getWeatherData(String location) async {
  //   final apiKey = 'c51704719f6e98cdd1abf98a4e40e6f6';
  //   String apiUrl;
  //
  //   if (location.contains(',')) {
  //     // City with state name
  //     List<String> locationParts = location.split(',');
  //     String city = locationParts[0].trim();
  //     String state = locationParts[1].trim();
  //     apiUrl = 'http://api.openweathermap.org/data/2.5/weather?q=$city,$state&appid=$apiKey';
  //   } else {
  //     // Just city name
  //     apiUrl = 'http://api.openweathermap.org/data/2.5/weather?q=$location&appid=$apiKey';
  //   }
  //
  //   final response = await http.get(Uri.parse(apiUrl));
  //
  //   if (response.statusCode == 200) {
  //     final data = json.decode(response.body);
  //     final temperatureInKelvin = data['main']['temp'];
  //     final temperatureInCelsius = temperatureInKelvin - 273.15;
  //
  //     setState(() {
  //       _locationInfo = 'Location: ${data['name']}';
  //       _weather = 'Weather: ${data['weather'][0]['main']}';
  //       _temperature = 'Temperature: ${temperatureInCelsius.toStringAsFixed(2)}°C';
  //       _humidity = 'Humidity: ${data['main']['humidity']}%';
  //
  //       // Set background image based on weather condition
  //       _setBackgroundImage(data['weather'][0]['main']);
  //     });
  //   } else {
  //     setState(() {
  //       _locationInfo = 'Invalid location';
  //       _weather = '';
  //       _temperature = '';
  //       _humidity = '';
  //     });
  //   }
  // }

  Future<void> _getWeatherData(String location) async {
    final apiKey = 'c51704719f6e98cdd1abf98a4e40e6f6';
    String apiUrl;

    if (location.contains(',')) {
      // City with state name
      List<String> locationParts = location.split(',');
      String city = locationParts[0].trim();
      String state = locationParts[1].trim();
      apiUrl = 'http://api.openweathermap.org/data/2.5/weather?q=$city,$state&appid=$apiKey';
    } else {
      // Just city name
      apiUrl = 'http://api.openweathermap.org/data/2.5/weather?q=$location&appid=$apiKey';
    }

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final temperatureInKelvin = data['main']['temp'];
      final minTemperatureInKelvin = data['main']['temp_min'];
      final maxTemperatureInKelvin = data['main']['temp_max'];

      final temperatureInCelsius = temperatureInKelvin - 273.15;
      final minTemperatureInCelsius = minTemperatureInKelvin - 273.15;
      final maxTemperatureInCelsius = maxTemperatureInKelvin - 273.15;

      setState(() {
        _locationInfo = 'Location: ${data['name']}';
        _weather = 'Weather: ${data['weather'][0]['main']}';
        _temperature = 'Temperature: ${temperatureInCelsius.toStringAsFixed(2)}°C';
        _humidity = 'Humidity: ${data['main']['humidity']}%';
        _minMaxTemperature = 'Min/Max: ${minTemperatureInCelsius.toStringAsFixed(2)}°C / ${maxTemperatureInCelsius.toStringAsFixed(2)}°C';

        // Set background image based on weather condition
        _setBackgroundImage(data['weather'][0]['main']);
      });
    } else {
      setState(() {
        _locationInfo = 'Invalid location';
        _weather = '';
        _temperature = '';
        _humidity = '';
        _minMaxTemperature = '';
      });
    }
  }
  @override
  void initState() {
    super.initState();
    _getDefaultCityWeather(); // Fetch weather data for default city on app start
  }
  Future<void> _getDefaultCityWeather() async {
    await _getWeatherData('Patna');
  }

  Future<void> _getLocationWeather() async {
    // For simplicity, this function is a placeholder.
    // In a real-world scenario, you would use a package like geolocator for accurate location detection.

    // For demonstration purposes, this example uses hardcoded location data (latitude and longitude for London).
    final latitude = 51.509865;
    final longitude = -0.118092;

    final apiKey = 'c51704719f6e98cdd1abf98a4e40e6f6';
    final apiUrl =
        'http://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final temperatureInKelvin = data['main']['temp'];
      final temperatureInCelsius = temperatureInKelvin - 273.15;

      setState(() {
        _locationInfo = 'Location: ${data['name']}';
        _weather = 'Weather: ${data['weather'][0]['main']}';
        _temperature = 'Temperature: ${temperatureInCelsius.toStringAsFixed(2)}°C';
        _humidity = 'Humidity: ${data['main']['humidity']}%';

        // Set background image based on weather condition
        _setBackgroundImage(data['weather'][0]['main']);
      });
    } else {
      setState(() {
        _locationInfo = 'Error fetching weather data';
        _weather = '';
        _temperature = '';
        _humidity = '';
      });
    }
  }

  void _setBackgroundImage(String weatherCondition) {
    switch (weatherCondition.toLowerCase()) {
      case 'clear':
        _backgroundImage = 'assets/clear_sky.jpg';
        break;
      case 'clouds':
        _backgroundImage = 'assets/cloudy_sky.jpg';
        break;
      case 'rain':
        _backgroundImage = 'assets/rainy_sky.jpg';
        break;
      case 'snow':
        _backgroundImage = 'assets/snowy_sky.jpg';
          break;
      case 'mist':
        _backgroundImage = 'assets/mist.jpg';
        break;
      case 'fog':
        _backgroundImage = 'assets/fog.jpg';
        break;
      case 'haze':
        _backgroundImage = 'assets/fog.jpg';
        break;
      default:
        _backgroundImage = 'assets/default_background.jpg';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text('Weather Plix',style: TextStyle(color: Colors.white),),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(_backgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _cityController,
                decoration: InputDecoration(
                  hintText: 'Enter City',
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.7),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _getWeatherData(_cityController.text);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: const Text('Get Weather', style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 20),
              // ElevatedButton(
              //   onPressed: () {
              //     _getLocationWeather();
              //   },
              //   style: ElevatedButton.styleFrom(
              //     primary: Colors.blue,
              //   ),
              //   child: const Text('Get Current Location Weather'),
              // ),
              const SizedBox(height: 20),
              Text(
                _locationInfo.isNotEmpty ? _locationInfo : 'Default City: Patna',
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
              Text(
                _weather,
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
              Text(
                _temperature,
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
              Text(
                _minMaxTemperature,
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
              Text(
                _humidity,
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
