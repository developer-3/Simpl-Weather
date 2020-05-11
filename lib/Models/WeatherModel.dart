import 'package:flutter/material.dart';

class Main 
{
    final double temp;
    final double feelsLike;
    final double tempMin;
    final double tempMax;
    final double pressure;
    final int humidity;

    Main({
        this.temp,
        this.feelsLike,
        this.tempMin,
        this.tempMax,
        this.pressure,
        this.humidity,
    });

    factory Main.fromJson(Map<String, dynamic> json) 
    {
    return Main(
      temp: json["temp"].toDouble(),
      feelsLike: json["feels_like"].toDouble(),
      tempMin: json["temp_min"].toDouble(),
      tempMax: json["temp_max"].toDouble(),
      pressure: json["pressure"].toDouble(),
      humidity: json["humidity"]);
    }
}

class Weather 
{
  final int id;
  final String main;
  final String description;
  final String icon;

  Weather({
      this.id,
      this.main,
      this.description,
      this.icon,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      id: json["id"],
      main: json["main"],
      description: json["description"],
      icon: json["icon"]);
    }
}

class Coord 
{
    final double lon;
    final double lat;

    Coord({
        this.lon,
        this.lat,
    });

    factory Coord.fromJson(Map<String, dynamic> json) {
      return Coord(
        lon: json["lon"].toDouble(),
        lat: json["lat"].toDouble());
    }
}

class Clouds 
{
    final int all;

    Clouds({
        this.all,
    });

    factory Clouds.fromJson(Map<String, dynamic> json) 
    {
      return Clouds(
        all: json["all"]);
    }

}

class Wind 
{
    final double speed;
    final int deg;

    Wind({
        this.speed,
        this.deg,
    });

    factory Wind.fromJson(Map<String, dynamic> json) 
    {
      return Wind(
        speed: json["speed"],
        deg: json["deg"]);
    }
}

class Sys
{
    final double message;
    final String country;
    final int sunrise;
    final int sunset;

  Sys({this.message, this.country, this.sunrise, this.sunset});
  factory Sys.fromJson(Map<String, dynamic> json )
  {
    return Sys(
      message: json['message'], 
      country: json['country'], 
      sunrise: json['sunrise'], 
      sunset: json['sunset']);
  }
}

class WeatherModel
{
  final Coord coord;
  final List<Weather> weather;
  final String base;
  final Main main;
  final int visibility;
  final Wind wind;
  final Clouds clouds;
  final int dt;
  final Sys sys;
  final int id;
  final String name;
  final int cod;

  WeatherModel({this.coord, this.weather, this.base, this.main, this.visibility, this.wind, this.clouds, this.dt, this.sys, this.id, this.cod, this.name});

  factory WeatherModel.fromJson(Map<String, dynamic> json )
  {
    return WeatherModel(
      coord: Coord.fromJson(json['coord']),
      weather: (json['weather'] as List).map((item) => Weather.fromJson(item)).toList(),
      base: json['base'],
      main: Main.fromJson(json['main']),
      wind: Wind.fromJson(json['wind']),
      clouds: Clouds.fromJson(json['clouds']),
      dt: json['dt'],
      sys: Sys.fromJson(json['sys']),
      id: json['id'],
      name: json['name'],
      cod: json['cod']
    );
  }


}