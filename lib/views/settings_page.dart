import 'package:flutter/material.dart';
import 'package:yet_another_weather_app/objects/weather_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SettingsPage extends StatefulWidget {
	SettingsPage(
		{Key key, String this.title, ThemeData this.theme, WeatherProvider this.weather, ValueChanged<
			WeatherProvider> this.updater})
		: super(key: key);
	final String title;
	final ThemeData theme;
	final WeatherProvider weather;
	final ValueChanged<WeatherProvider> updater;

	@override
	SettingsPageState createState() => new SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {

	@override
	void initState() {
		super.initState();
	}

	void changeLocation() {
		final TextEditingController textController = new TextEditingController();
		TextField textField = new TextField(
			maxLines: 1,
			decoration: new InputDecoration(
				hintText: widget.weather.getLocation()),
			controller: textController,
		);
		SimpleDialog inputDialog = new SimpleDialog(children: <Widget>[
			new SimpleDialogOption(
				child: textField,
			),
			new Row(children: <Widget>[
				new FlatButton(
					child: const Text('Cancel'),
					onPressed: () {
						Navigator.pop(context, null);
					}
				),
				new FlatButton(
					child: const Text('OK'),
					onPressed: () {
						Navigator.pop(context, textController.text);
					}
				),
			],
				crossAxisAlignment: CrossAxisAlignment.end,
				mainAxisAlignment: MainAxisAlignment.end,
			)
		],);
		showDialog(context: context, child: inputDialog).then((value) {
			if (value != "" && value != null) {
				WeatherProvider w = widget.weather;
				w.location = value;
				widget.updater(w);
			}
		});
	}

	void changeTempUnits() {
		WeatherProvider w = widget.weather;
		switch (w.tempUnits) {
			case TEMP.CELSIUS:
				w.tempUnits = TEMP.FAHRENHEIT;
				break;
			case TEMP.FAHRENHEIT:
				w.tempUnits = TEMP.KELVIN;
				break;
			case TEMP.KELVIN:
				w.tempUnits = TEMP.CELSIUS;
				break;
		}
		widget.updater(w);
	}

	@override
	Widget build(BuildContext context) {
		return new Scaffold(
			appBar: new AppBar(
				title: new Text(widget.title),
			),
			body: new ListView(
//				padding: const EdgeInsets.symmetric(vertical: 20.0),
				children: <Widget>[
					new ListTile(
						subtitle: new Text(widget.weather.getLocation()),
						title: new Text("Location"),
						onTap: changeLocation,
						leading: new Icon(FontAwesomeIcons.mapMarker,
							color: widget.theme.primaryColor),
					),
					new ListTile(
						subtitle: new Text(
							tempUnitToString(widget.weather.tempUnits)),
						title: new Text("Temperature units"),
						onTap: changeTempUnits,
						leading: new Icon(FontAwesomeIcons.lineChart,
							color: widget.theme.primaryColor),
					)
				],
			),
		);
	}
}
