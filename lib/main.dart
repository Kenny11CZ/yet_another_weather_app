import 'package:flutter/material.dart';
import 'package:yet_another_weather_app/views/home_page.dart';
import 'package:yet_another_weather_app/views/settings_page.dart';
import 'package:yet_another_weather_app/objects/openweather.dart';
import 'package:yet_another_weather_app/objects/weather_provider.dart';
import 'package:yet_another_weather_app/objects/config.dart';

void main() => runApp(new WeatherApp());

class WeatherApp extends StatefulWidget {
	@override
	WeatherAppState createState() => new WeatherAppState();
}

class WeatherAppState extends State<WeatherApp> {
	WeatherProvider weather;
	ThemeData theme;
	Config config;



	@override
	void initState() {
		super.initState();
		weather = new OpenWeather()..location="Prague";
		theme = new ThemeData(
			primaryColor: Colors.blue,
			brightness: Brightness.dark
		);
		Config.readConfig().then((Config cfg) {
			config = cfg;
			WeatherProvider w = weather;
			w.location = cfg.location;
			w.tempUnits = cfg.tempUnits;
			weatherUpdater(w);
		});
	}

	void weatherUpdater(WeatherProvider val) {
		setState(() {
			weather = val;
		});
		if(config != null) {
			config.updateData(val);
			config.saveConfig();
		}
	}

	@override
	Widget build(BuildContext context) {
		return new MaterialApp(
			title: 'Yet Another Weather App',
			theme: theme,
			routes: <String, WidgetBuilder>{
				'/':         (BuildContext context) => new HomePage(title: "Yet Another Weather App", theme: theme, weather: weather,),
				'/settings': (BuildContext context) => new SettingsPage(title: "Settings", theme: theme, weather: weather, updater: weatherUpdater,)
			},
//			home: new HomePage(title: 'Yet Another Weather App', theme: theme),
		);
	}
}

