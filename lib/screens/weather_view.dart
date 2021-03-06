import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/Models/WeatherModel.dart';
import 'package:weather_app/Models/ForecastModel.dart';
import 'package:weather_app/screens/weather_report.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:sprintf/sprintf.dart';


class WeatherView extends StatefulWidget {
  @override
  _WeatherViewState createState() => _WeatherViewState();
}

class _WeatherViewState extends State<WeatherView> {
  String url;
  String forecastURL;
  Position userPosition;
  WeatherModel weatherModel;
  ForecastModel forecast;
  var _height = 320.0;
  var _icon = Icons.arrow_downward;
  bool _visible = true;
  final List days = [];
  Address location;


  // Init
  @override
  void initState() {
    super.initState();
    getLocation().then((position) { 
      userPosition = position;
      var lat = userPosition.latitude;
      var lon = userPosition.longitude;
      var coordinates = Coordinates(lat, lon);

      Geocoder.local.findAddressesFromCoordinates(coordinates).then((address) {
          location = address.first;
          print(location.subAdminArea);
        });
      createURL().then((url) {
        url = url;
        getWeatherData(url).then((model) {
          setState(() {
            weatherModel = model;
          });
        });
      });
      createURLForecast().then((url) {
        forecastURL = url;
        getForecastData(url).then((model) {
          setState(() {
            forecast = model;
          });
        });
      });
    });
  }

  // Get weather data
  Future<WeatherModel> getWeatherData(String url) async{
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      var model = WeatherModel.fromJson(result);
      return model;
    }
    else 
      throw Exception('Failed to load Weather data.');
  }

  Future<ForecastModel> getForecastData(String url) async{
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      var model = ForecastModel.fromJson(result);
      return model;
    }
    else 
      throw Exception('Failed to load Weather data.');
  }

  // Get location
  Future<Position> getLocation() async {
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    return position;
  }

  // Animate container
  double _updateState() {
    if (_height == 320) {
      setState(() {
        _height = MediaQuery.of(context).size.height - 180;
        _icon = Icons.arrow_upward;
        _visible = !_visible;
      });
    } else {
      setState(() {
        _height = 320.0;
        _icon = Icons.arrow_downward;
        _visible = !_visible;
      });
    }
  }

  // Get weather data with user position
  Future<String> createURL() async {
    var lon = userPosition.longitude;
    var lat = userPosition.latitude;

    return sprintf("https://api.openweathermap.org/data/2.5/weather?lat=%s&lon=%s&units=imperial&appid=5a0d734f091ed7c17268f3fe9718a279", [lat, lon]);

  }
  Future<String> createURLForecast() async {
    var lon = userPosition.longitude;
    var lat = userPosition.latitude;

    return sprintf("https://api.openweathermap.org/data/2.5/forecast?lat=%s&lon=%s&units=imperial&appid=5a0d734f091ed7c17268f3fe9718a279", [lat, lon]);

  }

  @override
  Widget build(BuildContext context) {

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('MMMMEEEEd').format(now);
    for (var i = 1; i <= 6; i++) {
      DateTime day = DateTime.now().add(Duration(days: i));
      String format = DateFormat('EEEE').format(day);
      days.add(format);
    }
    while (weatherModel == null || forecast == null ) {
      return Center(child: new Container(child: CircularProgressIndicator()));
    }
    
    var sunrise = new DateTime.fromMillisecondsSinceEpoch(weatherModel.sys.sunrise * 1000).toUtc();
    var sunriseLocal = sunrise.toLocal();
    String formatSunrise = DateFormat('jm').format(sunriseLocal);
    var sunset = new DateTime.fromMillisecondsSinceEpoch(weatherModel.sys.sunset * 1000);
    var sunsetLocal = sunset.toLocal();
    String formatSunset = DateFormat('jm').format(sunsetLocal);

    return Scaffold(
      backgroundColor: const Color(0xFF06304B),
      body: Container(
        child: Stack(
          children: <Widget>[
            Container(
              color: const Color(0xFF06304B),
            ),
            new Positioned(
              top: 380,
              child: Container(
                child: AnimatedOpacity(
                  duration: Duration(milliseconds: 500),
                  opacity: _visible ? 1.0 : 0.0,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(32.0, 0, 32.0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              child: Text("Your Week", style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 35,
                                  fontWeight: FontWeight.w600,
                                  textBaseline: TextBaseline.alphabetic
                                ),),
                            ),
                          ),
                          SizedBox(height: 10,),
                          Container(width: MediaQuery.of(context).size.width/1.2, height: 3,color: Colors.white,),
                          SizedBox(height: 10,),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                WeatherReport(days[0], '${(forecast.days[0].main.tempMax).round()}º', '${(forecast.days[1].main.tempMin).round()-4}º'),
                                WeatherReport(days[1], '${(forecast.days[8].main.tempMax).round()}º', '${(forecast.days[9].main.tempMin).round()-4}º'),
                                WeatherReport(days[2], '${(forecast.days[16].main.tempMax).round()}º', '${(forecast.days[17].main.tempMin).round()-4}º'),
                                WeatherReport(days[3], '${(forecast.days[24].main.tempMax).round()}º', '${(forecast.days[25].main.tempMin).round()-4}º'),
                                WeatherReport(days[4], '${(forecast.days[32].main.tempMax).round()}º', '${(forecast.days[33].main.tempMin).round()-4}º'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                ),
              ),
            ),
            AnimatedContainer(
              width: MediaQuery.of(context).size.width,
              height: _height,
              duration: Duration(milliseconds: 1000),
              curve: Curves.linear,
              decoration: BoxDecoration(
                color: Colors.lightBlue,
                borderRadius: new BorderRadius.only(
                  bottomLeft:  const  Radius.circular(45.0),
                  bottomRight: const  Radius.circular(45.0))
              ),
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment(-0.8, -0.45),
                    child: AnimatedOpacity(
                      duration: Duration(milliseconds: 500),
                      opacity: _visible ? 1.0 : 0.0,
                      child: Text("Welcome", style: TextStyle(
                        color: Colors.white,
                        fontSize: 45,
                        fontWeight: FontWeight.w600,
                      )),
                    ),
                  ),
                  Align(
                    alignment: Alignment(-0.8, -0.1),
                    child: AnimatedOpacity(
                      duration: Duration(milliseconds: 500),
                      opacity: _visible ? 1.0 : 0.0,
                      child: Text(formattedDate, style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w300
                      )),
                    ),
                  ),
                  AnimatedPositioned(
                    right: 30,
                    bottom: _visible ? 16 : 75,
                    duration: Duration(milliseconds: 1000),
                    child: Text('${(weatherModel.main.feelsLike).round()}º', style: TextStyle(
                      color: Colors.white,
                      fontSize: 55,
                      fontWeight: FontWeight.w600,
                    ))
                    ),
                  Positioned(
                    bottom: 28,
                    right: 30,
                    child: AnimatedOpacity(
                      duration: Duration(milliseconds: 1000),
                      opacity: _visible ? 0.0 : 0.5,
                      child: Text("${(weatherModel.main.tempMin).round()}º", style: TextStyle(color: Colors.white, fontSize: 45)),
                    ),
                  )
                ],
              )
            ),
            AnimatedPositioned(
              duration: Duration(milliseconds: 800),
              top: _visible ? 150 : 75, 
              left: 16,
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 600),
                opacity: _visible ? 0.0 : 1.0,
                  child: Container(
                    child: Text("${location.subAdminArea},\n${location.adminArea}", style: TextStyle(color: Colors.white, fontSize: 45, fontWeight: FontWeight.w600),)),
                ),
              ),
            Positioned(
              top: 230,
              left: 25, 
              right: 25,
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 1200),
                opacity: _visible ? 0.0 : 1.0,
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Opacity(
                            opacity: 0.5,
                            child: Text("Sunrise", style: TextStyle(color: Colors.white, fontSize: 25))),
                          Text("${(formatSunrise)}", style: TextStyle(fontSize: 35, color: Colors.white)),
                          SizedBox(height: 55),
                          Opacity(
                            opacity: 0.5,
                            child: Text("Humidity", style: TextStyle(color: Colors.white, fontSize: 25))),
                          Text("${(weatherModel.main.humidity)}%", style: TextStyle(fontSize: 35, color: Colors.white)),
                        ],
                      ),
                      // SizedBox(width: MediaQuery.of(context).size.width/5.5),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Opacity(
                            opacity: 0.5,
                            child: Text("Sunset", style: TextStyle(color: Colors.white, fontSize: 25))),
                          Text("${(formatSunset)}", style: TextStyle(fontSize: 35, color: Colors.white)),
                          SizedBox(height: 55),
                          Opacity(
                            opacity: 0.5,
                            child: Text("Wind Speed", style: TextStyle(color: Colors.white, fontSize: 25))),
                          Text("${(weatherModel.wind.speed).round()} mph", style: TextStyle(fontSize: 35, color: Colors.white)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            AnimatedPositioned(
              duration: Duration(milliseconds: 1000),
              top: _visible ? 290 : MediaQuery.of(context).size.height-210, 
              right: MediaQuery.of(context).size.width/2-45,
              child: RawMaterialButton(
                onPressed: () {
                  _updateState();
                },
                elevation: 5.0,
                fillColor: Colors.white,
                child: Icon(
                  _icon,
                  size: 35.0,
                ),
                padding: EdgeInsets.all(15.0),
                shape: CircleBorder(),
              ),
            ),
            Positioned(
              bottom: 32,
              left: MediaQuery.of(context).size.width/4,
              child: Container(
                margin: const EdgeInsets.all(0.0),
                child: AnimatedOpacity(
                  duration: Duration(milliseconds: 1000),
                  opacity: _visible ? 0.0 : 1.0,
                    child: Text('© Adam Anderson 2020', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w300))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
