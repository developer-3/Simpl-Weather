

class Main extends Object
{
    final double temp;
    final double feelsLike;
    final double tempMin;
    final double tempMax;
    final double pressure;
    final int humidity;
    final List<Weather> weather;

    Main({
        this.temp,
        this.feelsLike,
        this.tempMin,
        this.tempMax,
        this.pressure,
        this.humidity,
        this.weather, 
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


class Days extends Object
{
  final List<Weather> weather;
  final String base;
  final Main main;
  final int visibility;
  final int dt;
  final int id;
  final String name;

  Days({this.weather, this.base, this.main, this.visibility, this.dt, this.id, this.name});

  factory Days.fromJson(Map<String, dynamic> json )
  {
    return Days(
      weather: (json['weather'] as List).map((item) => Weather.fromJson(item)).toList(),
      base: json['base'],
      main: Main.fromJson(json['main']),
      dt: json['dt'],
      id: json['id'],
      name: json['name'],
    );
  }
}


class Weather extends Object
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


class ForecastModel extends Object
{
  final String cod;
  final int message;
  final int count;
  final List<Days> days;

  ForecastModel({this.days, this.cod, this.count, this.message});

  factory ForecastModel.fromJson(Map<String, dynamic> json )
  {
    return ForecastModel(
      days: (json['list'] as List).map((item) => Days.fromJson(item)).toList(),
      cod: json['cod'],
      message: json['message'],
      count: json['count']
    );
  }
}