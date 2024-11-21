// lib/main.dart
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'current_weather_screen.dart';
import 'forecast_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/current': (context) => CurrentWeatherScreen(),
        '/forecast': (context) => ForecastScreen(),
      },
    );
  }
}
