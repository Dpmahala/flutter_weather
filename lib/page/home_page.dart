import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:weather_app/page/additionsl_page.dart';
import 'package:weather_app/page/hourlyforcast.dart';
import 'package:weather_app/secrets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<Map<String, dynamic>> weather;

  // get the data from api

  Future<Map<String, dynamic>> getCrrentWeather() async {
    try {
      String cityName = 'London';
      final res = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$openWeatherAPIKey',
        ),
      );
      final data = jsonDecode(res.body);

      if (data['cod'] != '200') {
        throw 'An unexpected error occured';
      }
      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  // refresh all intiar whole page and upadte the data of owr app

  @override
  void initState() {
    super.initState();
    weather = getCrrentWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                // this is refresh all page
                weather = getCrrentWeather();
              });
            },
            icon: const Icon(
              Icons.refresh,
            ),
          ),
        ],
        title: const Text(
          'Weather App',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: weather,
        builder: (context, snapdhot) {
          if (snapdhot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          if (snapdhot.hasError) {
            return Center(
              child: Text(
                snapdhot.hasError.toString(),
              ),
            );
          }

          final data = snapdhot.data!;

          final currentWeatherData = data['list'][0];
          final currentTemp = currentWeatherData['main']['temp'];
          final currentSky = currentWeatherData['weather'][0]['main'];
          final curentPressure = currentWeatherData['main']['pressure'];
          final currentWindSpeed = currentWeatherData['wind']['speed'];
          final currentHumidity = currentWeatherData['main']['humidity'];
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                "$currentTemp K",
                                style: const TextStyle(
                                  fontSize: 32.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Icon(
                                currentSky == 'Clouds' || currentSky == 'Rain'
                                    ? Icons.cloud
                                    : Icons.sunny,
                                size: 64,
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Text(
                                currentSky,
                                style: const TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Weather Forecast',
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                const SizedBox(
                  height: 16,
                ),
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      final hourlyForcast = data['list'][index + 1];
                      final hourltSky = data['list'][index + 1]['weather'][0]
                                      ['main'] ==
                                  'Clouds' ||
                              data['list'][index + 1]['weather'][0]['main'] ==
                                  'Rain'
                          ? Icons.cloud
                          : Icons.sunny;
                      final time = DateTime.parse(hourlyForcast['dt_txt']);
                      return HourlyForeCast(
                        icon: hourltSky,
                        lable: DateFormat.jm().format(time),
                        value: hourlyForcast['main']['temp'].toString(),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Additional Information',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Additional(
                      icon: Icons.water_drop,
                      lable: 'Humidity',
                      value: currentHumidity.toString(),
                    ),
                    Additional(
                      icon: Icons.air_sharp,
                      lable: 'Wind Speed',
                      value: currentWindSpeed.toString(),
                    ),
                    Additional(
                      icon: Icons.beach_access,
                      lable: 'Pressure',
                      value: curentPressure.toString(),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
