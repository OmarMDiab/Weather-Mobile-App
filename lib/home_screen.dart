import 'package:flutter/material.dart';
import 'config.dart'; // contains cities and countries and API key

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCountry = 'Egypt';
  String selectedCity = 'Cairo';
  List<String> cities = countriesWithCities['Egypt']!;

  @override
  void initState() {
    super.initState();
    // Initialize the city list based on the default selected country
    cities = countriesWithCities[selectedCountry]!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.purple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              'Weather App',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            centerTitle: true,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage('https://www.vmcdn.ca/f/files/powellriverpeak/images/stock-images/2519_lets_talk_trash_earth.jpg;w=960'),
            fit: BoxFit.fitHeight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Welcome to the Weather App',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(color: Colors.blueAccent.withOpacity(0.7), offset: Offset(0, 0), blurRadius: 10.0),
                      Shadow(color: Colors.lightBlueAccent.withOpacity(0.5), offset: Offset(0, 0), blurRadius: 20.0),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40),

                // Country Selector
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blueAccent, Colors.lightBlueAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4)),
                    ],
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: DropdownButton<String>(
                    value: selectedCountry,
                    dropdownColor: Colors.white,
                    style: TextStyle(color: Colors.black, fontSize: 16),
                    items: countriesWithCities.keys.map((country) {
                      return DropdownMenuItem(
                        value: country,
                        child: Text(country, style: TextStyle(fontSize: 18)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCountry = value!;
                        selectedCity = countriesWithCities[selectedCountry]!.first; // Reset city to the first option
                        cities = countriesWithCities[selectedCountry]!;
                      });
                    },
                    underline: SizedBox(),
                    iconEnabledColor: Colors.white,
                    icon: Icon(Icons.arrow_drop_down),
                  ),
                ),

                SizedBox(height: 10),

                // City Selector
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blueAccent, Colors.lightBlueAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4)),
                    ],
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: DropdownButton<String>(
                    value: selectedCity,
                    dropdownColor: Colors.white,
                    style: TextStyle(color: Colors.black, fontSize: 16),
                    items: cities.map((city) {
                      return DropdownMenuItem(
                        value: city,
                        child: Text(city, style: TextStyle(fontSize: 18)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCity = value!;
                      });
                    },
                    underline: SizedBox(),
                    iconEnabledColor: Colors.white,
                    icon: Icon(Icons.arrow_drop_down),
                  ),
                ),

                SizedBox(height: 50),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/current',
                      arguments: selectedCity,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'Current Weather',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/forecast',
                      arguments: selectedCity,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    '3-Day Forecast',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
