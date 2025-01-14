import 'package:flutter/material.dart';
import 'package:clima_flutter_1/utilities/constants.dart';
import 'package:clima_flutter_1/services/weather.dart';
import 'city_screen.dart';


class LocationScreen extends StatefulWidget {
  final locationWeather;

  const LocationScreen({Key? key, this.locationWeather}) : super(key: key);
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  WeatherModel weather = WeatherModel();
  int? temperature;
  String? weatherIcon;
  String? cityName;
  String? weatherMessage;
  void updateUI(dynamic weatherData) {
    setState(() {
      if(weatherData==null){
        temperature =0;
        weatherIcon = 'ERROR';
        weatherMessage = 'Unable to get weather data';
        cityName = '';
        return;

      }
      double temp = weatherData['main']['temp'];
      temperature = temp.toInt();
      dynamic condition = weatherData['weather'][0]['id'];
      cityName = weatherData['name'];
      weatherIcon = weather.getWeatherIcon(condition);
      weatherMessage = weather.getMessage(temperature!);
    });
  }

  @override
  void initState() {
    super.initState();
    updateUI(widget.locationWeather);
    print(widget.locationWeather);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/location_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        updateUI(widget.locationWeather);//calling widget directly
                      },
                      child: Icon(
                        Icons.near_me,
                        size: 50.0,
                      ),
                    ),
                  ),
                  Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      dynamic typeName;
                      setState(() async{
                        typeName = await Navigator.push(context, MaterialPageRoute(builder: (context){
                          return CityScreen();
                        },
                        ),
                        );
                        if(typeName!=null){

                          dynamic weatherData = await weather.getCityWeather(typeName);
                          updateUI(weatherData);
                        }
                      });

                    },
                    child: Icon(
                      Icons.location_city,
                      size: 50.0,
                    ),
                  ),
                  ),
                ],
              ),

                 Padding(
                  padding: EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                    child:Text(
                      '$temperature°C',
                      style: kTempTextStyle,
                    ),
                    ),
                    Expanded(
                    child:Text(
                      weatherIcon!,
                      style: kConditionTextStyle,
                    ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsets.all(15.0),
                  child:Text(
                  "$weatherMessage  $cityName!",
                  textAlign: TextAlign.right,
                  style: kMessageTextStyle,
                ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
