// lib/current_weather_screen.dart
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'config.dart';

class CurrentWeatherScreen extends StatelessWidget {
  Future<Map<String, dynamic>> fetchCurrentWeather(String city) async {
    final response = await http.get(
      Uri.parse('https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric'),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  String _getBackgroundImageUrl(String weatherCondition) {
    switch (weatherCondition.toLowerCase()) {
      case 'clear':
        return 'https://media.istockphoto.com/id/947314334/photo/blue-sky-with-bright-sun.jpg?s=612x612&w=0&k=20&c=XUlLAWDXBLYdTGIl6g_qHQ9IBBw4fBvkVuvL2dmVXQw=';
      case 'clouds':
        return 'https://img.freepik.com/premium-photo/cloud-after-rain-summer-clear-blue-sky-beautiful-white-cumulus-clouds-summer-season-nature-background-cloudscape-abstract-wallpaper-heaven-pattern-warm-weather_156843-1347.jpg';
      case 'rain':
        return 'https://t4.ftcdn.net/jpg/03/66/90/39/360_F_366903907_RzCXMYTOdWnfEmm8wZ3fKnfEOLE2Qhmh.jpg';
      default:
        return 'https://img.freepik.com/premium-vector/day-with-clouds-weather-app-screen-mobile-interface-design-forecast-weather-background-time-concept-vector-banner_87946-4137.jpg';
    }
  }

  @override
  Widget build(BuildContext context) {
    final city = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchCurrentWeather(city),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.red)));
          } else {
            final weatherData = snapshot.data!;
            final weatherCondition = weatherData['weather'][0]['main'];
            final backgroundImageUrl = _getBackgroundImageUrl(weatherCondition);

            return Stack(
              fit: StackFit.expand,
              children: [
                // Background Image from URL
                Image.network(
                  backgroundImageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Center(child: Text('Failed to load image', style: TextStyle(color: Colors.red)));
                  },
                ),
                // Overlay with a gradient for readability
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.black.withOpacity(0.5), Colors.black.withOpacity(0.2)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                // Weather Info Card
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '$city',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [Shadow(blurRadius: 10, color: Colors.black45, offset: Offset(2, 2))],
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '${weatherData['main']['temp']}°C',
                        style: TextStyle(
                          fontSize: 80,
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        weatherData['weather'][0]['description'],
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white70,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      SizedBox(height: 30),
                      // Additional details like humidity, wind speed
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildInfoColumn(Icons.water_drop, '${weatherData['main']['humidity']}%', 'Humidity'),
                          SizedBox(width: 20),
                          _buildInfoColumn(Icons.air, '${weatherData['wind']['speed']} km/h', 'Wind'),
                        ],
                      ),
                      SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/forecast', arguments: city);
                        },
                        child: Text('Go to Forecast'),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildInfoColumn(IconData icon, String data, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 30),
        SizedBox(height: 5),
        Text(
          data,
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 16, color: Colors.white70),
        ),
      ],
    );
  }
}
