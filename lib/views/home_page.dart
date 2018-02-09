import 'package:flutter/material.dart';
import 'package:yet_another_weather_app/objects/weather_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:weather_icons_flutter/weather_icons_flutter.dart';
//import 'package:YAWA/objects/weathericons.dart';

class HomePage extends StatefulWidget {
	HomePage(
		{Key key, String this.title, ThemeData this.theme, WeatherProvider this.weather})
		: super(key: key);
	final String title;
	final ThemeData theme;
	final WeatherProvider weather;

	@override
	HomePageState createState() => new HomePageState(theme);
}

class HomePageState extends State<HomePage> {
	HomePageState(ThemeData this.theme);

	final ThemeData theme;

//	Openwidget.weather widget.weather = new Openwidget.weather()..location="Prague";

	@override
	void initState() {
		super.initState();
		try {
			widget.weather.get().then((d) {
				setState(() {
					widget.weather.setData(d);
				});
			});
		} catch (e) {

		}
	}

	reloadData() async {
		try {
			var d = await widget.weather.get();
			setState(() {
				widget.weather.setData(d);
			});
		} catch (e) {

		}
	}

	void showSettings() {
		Navigator.pushNamed(context, "/settings");
	}

	@override
	Widget build(BuildContext context) {
		List<Widget> tiles = initTiles();
		return new Scaffold(
			appBar: new AppBar(
				title: new Text(widget.title),
				actions: <Widget>[new IconButton(
					icon: new Icon(Icons.settings), onPressed: showSettings)
				],
			),
			body: new RefreshIndicator(
				child: new ListView(
					children: tiles,
					physics: new AlwaysScrollableScrollPhysics(),
				), onRefresh: reloadData),
			floatingActionButton: null,
		);
	}

	List<Widget> initTiles() {
		ListTile location = new ListTile(
			title: new Text(widget.weather.getLocation()),
			subtitle: new Text("Location"),
			leading: new Icon(
				FontAwesomeIcons.mapMarker, color: theme.primaryColor),
		);
		ListTile temp = new ListTile(
			title: new Text(widget.weather.getTemperature().toStringAsFixed(2) +
				tempUnitToString(widget.weather.tempUnits)),
			subtitle: new Text("Temperature"),
			leading: new Icon(
				FontAwesomeIcons.thermometerFull, color: theme.primaryColor),
		);
		ListTile tempMax = new ListTile(
			title: new Text(
				"Max:" + widget.weather.getTemperatureMax().toStringAsFixed(2) +
					tempUnitToString(widget.weather.tempUnits) +
					" Min:" +
					widget.weather.getTemperatureMax().toStringAsFixed(2) +
					tempUnitToString(widget.weather.tempUnits)),
			subtitle: new Text("Temperature"),
			leading: new Icon(
				FontAwesomeIcons.lineChart, color: theme.primaryColor),
		);
		ListTile tempMin = new ListTile(
			title: new Text(
				widget.weather.getHumidity().toStringAsFixed(2) + "%"),
			subtitle: new Text("Humidity"),
			leading: new Icon(FontAwesomeIcons.tint, color: theme.primaryColor),
		);
		ListTile pressure = new ListTile(
			title: new Text(
				widget.weather.getPressure().toStringAsFixed(2) + " hPa"),
			subtitle: new Text("Pressure"),
			leading: new Icon(
				FontAwesomeIcons.tachometer, color: theme.primaryColor),
		);
		ListTile wind = new ListTile(
			title: new Text(
				widget.weather.getWindSpeed().toStringAsFixed(2) + " m/s"),
			subtitle: new Text(widget.weather.getWindDirection() + " Wind"),
			leading: new Icon(Icons.adjust, color: theme.primaryColor),
		);
		List<ListTile> res = new List<ListTile>();
		res.add(location);
		res.add(temp);
		res.add(tempMax);
		res.add(tempMin);
		res.add(pressure);
		res.add(wind);


		return res;
	}
}
