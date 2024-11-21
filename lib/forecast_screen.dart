import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'config.dart';

class ForecastScreen extends StatelessWidget {
  Future<List<Map<String, dynamic>>> fetchWeatherForecast(String city) async {
    final response = await http.get(
      Uri.parse('https://api.openweathermap.org/data/2.5/forecast?q=$city&appid=$apiKey&units=metric'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> forecasts = json.decode(response.body)['list'];
      return forecasts
          .where((data) => data['dt_txt'].contains('12:00:00'))
          .take(3)
          .map((data) => data as Map<String, dynamic>)
          .toList();
    } else {
      throw Exception('Failed to load forecast data');
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
      appBar: AppBar(
        title: Text('3-Day Forecast for $city'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchWeatherForecast(city),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.red)));
          } else {
            final forecastData = snapshot.data!;
            return ListView.builder(
              itemCount: forecastData.length,
              itemBuilder: (context, index) {
                final dayData = forecastData[index];
                final weatherCondition = dayData['weather'][0]['main'];
                final backgroundImageUrl = _getBackgroundImageUrl(weatherCondition);
                final date = dayData['dt_txt'].split(' ')[0]; // Extracting only the date
                final temp = dayData['main']['temp'];
                final description = dayData['weather'][0]['description']; // No modification

                return Container(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4))],
                  ),
                  child: Stack(
                    children: [
                      // Background Image for each day's forecast
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          backgroundImageUrl,
                          fit: BoxFit.cover,
                          height: 150,
                          width: double.infinity,
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return Center(child: CircularProgressIndicator());
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Center(child: Text('Failed to load image', style: TextStyle(color: Colors.red)));
                          },
                        ),
                      ),
                      // Gradient overlay for readability
                      Container(
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          gradient: LinearGradient(
                            colors: [Colors.black.withOpacity(0.5), Colors.black.withOpacity(0.2)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                      // Weather info
                      Positioned(
                        top: 10,
                        left: 10,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              date,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              '$temp°C',
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              description, // Use description directly
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white70,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
