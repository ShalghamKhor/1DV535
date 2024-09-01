import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Weather App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const WeatherHomePage(title: 'Weather App'),
    );
  }
}

class WeatherHomePage extends StatefulWidget {
  const WeatherHomePage({super.key, required this.title});

  final String title;

  @override
  State<WeatherHomePage> createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  Weather? _weather;
  bool _loading = false;
  String? _location;
  String? _errorMessage;
  final WeatherService _weatherService = WeatherService();

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  void _fetchWeather() async {
    setState(() {
      _loading = true;
      _location = null;
      _weather = null;
      _errorMessage = null;
    });

    try {
      Position position = await _determinePosition();
      print('Position: ${position.latitude}, ${position.longitude}');
      String location =
          await _getLocationName(position.latitude, position.longitude);
      final weather = await _weatherService.fetchWeatherByCoordinates(
          position.latitude, position.longitude);
      setState(() {
        _location = location;
        _weather = weather;
      });
    } catch (e) {
      print("Error: $e");
      setState(() {
        _errorMessage = "Error in getting weather: $e";
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<String> _getLocationName(double lat, double lon) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        print('Placemark: ${place.toJson()}');
        String locality = place.locality ?? "Unknown locality";
        String country = place.country ?? "Unknown country";
        return "$locality, $country";
      }
      return "Unknown location";
    } catch (e) {
      print("Error in _getLocationName: $e");
      throw Exception("Error in getting location: $e");
    }
  }

  void _navigateToAbout(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const AboutPage()));
  }

  @override
  Widget build(BuildContext context) {
    String date = DateFormat('EEE, MMM d, yyyy').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: () => _navigateToAbout(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _weather == null
                ? _errorMessage != null
                    ? Center(
                        child: Text(
                          _errorMessage!,
                          style:
                              const TextStyle(color: Colors.red, fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : const Center(child: Text('No weather data available'))
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$_location',
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Image.network(
                          'https://openweathermap.org/img/wn/${_weather?.icon}@2x.png',
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.error);
                          },
                        ),
                        const SizedBox(height: 20),
                        Text(date, style: const TextStyle(fontSize: 15)),
                        Text(
                          _weather?.description ?? 'N/A',
                          style: const TextStyle(fontSize: 15),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.thermostat_outlined,
                                size: 30, color: Colors.red),
                            const SizedBox(width: 8),
                            Text(
                              '${_weather?.temperature ?? 'N/A'}°C',
                              style: const TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.compress,
                                size: 30, color: Colors.black),
                            const SizedBox(width: 8),
                            Text(
                              '${_weather?.pressure ?? 'N/A'} hPa',
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.water_drop,
                                size: 30, color: Colors.black),
                            const SizedBox(width: 8),
                            Text(
                              '${_weather?.humidity ?? 'N/A'}%',
                              style: const TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Current'),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'About'),
        ],
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            _navigateToAbout(context);
          }
        },
      ),
    );
  }
}

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Project Weather'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            'This is an app that is developed for the course 1DV535 at Linnaeus University using Flutter and the OpenWeatherMap API.\n\nDeveloped by Mujtaba Mohsini',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Current'),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'About'),
        ],
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}

class Weather {
  final String description;
  final int temperature;
  final int pressure;
  final int humidity;
  final String icon;

  Weather({
    required this.description,
    required this.temperature,
    required this.pressure,
    required this.humidity,
    required this.icon,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      description: json['weather'][0]['description'],
      temperature: (json['main']['temp'] as num).toDouble().toInt(),
      pressure: json['main']['pressure'],
      humidity: json['main']['humidity'],
      icon: json['weather'][0]['icon'],
    );
  }
}

class WeatherService {
  static const String apiKey = 'f2d052354c9b7ac73586016aa0b939b4';
  static const String apiUrl =
      'https://api.openweathermap.org/data/2.5/weather';

  Future<Weather> fetchWeatherByCoordinates(double lat, double lon) async {
    final response = await http
        .get(Uri.parse('$apiUrl?lat=$lat&lon=$lon&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      return Weather.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
