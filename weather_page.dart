import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WeatherPage extends StatefulWidget {
  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  List<dynamic> weatherData = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
  }

  // Function to fetch weather data from the API
  Future<void> _fetchWeatherData() async {
    const url =
        'https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/Bristol?unitGroup=metric&include=days&key=64YD4JMWZBBMEZKMXE8M87AGV&contentType=json';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          weatherData = json.decode(response.body)['days']; // Get weather days data
          _isLoading = false; // Update loading state
        });
      } else {
        // Handle error response
        throw Exception('Failed to load weather data');
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather Forecast'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: weatherData.length,
        itemBuilder: (context, index) {
          final day = weatherData[index];
          return ListTile(
            title: Text('Date: ${day['datetime']}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Max Temp: ${day['tempmax']}°C'),
                Text('Min Temp: ${day['tempmin']}°C'),
                Text('Temp: ${day['temp']}°C'),
                Text('Feels Like: ${day['feelslike']}°C'),
                Text('Humidity: ${day['humidity']}%'),
                Text('Precipitation: ${day['precip']} mm'),
                Text('Precip Probability: ${day['precipprob']}%'),
                Text('Wind Speed: ${day['windspeed']} km/h'),
                Text('Wind Gust: ${day['windgust']} km/h'),
                Text('Wind Direction: ${day['winddir']}°'),
                Text('UV Index: ${day['uvindex']}'),
                Text('Severe Risk: ${day['severerisk']}'),
                Text('Moon Phase: ${day['moonphase']}'),
                Text('Cloud Cover: ${day['cloudcover']}%'),
                Text('Visibility: ${day['visibility']} km'),
              ],
            ),
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: WeatherPage(),
  ));
}
