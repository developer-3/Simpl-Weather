import 'package:flutter/material.dart';


class WeatherReport extends StatelessWidget {
  final String _day;
  final String _tempMax;
  final String _tempMin;

  
  WeatherReport(this._day, this._tempMax, this._tempMin);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(_day, style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.w300
              )
              ),
            ),
            SizedBox(width: 70),
            Expanded(
              child: Container(
                child: Row(children: <Widget>[
                  Text(_tempMax + " | ", style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w300
                    )
                  ),
                  Opacity(
                    opacity: 0.5,
                    child: Text(_tempMin, style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w300
                      )
                      ),
                    ),
                ],),
              ),
            ),
          ],
        ),
      );
  }
}