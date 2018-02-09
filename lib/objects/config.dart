import 'weather_provider.dart';
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';


class Config{

	String location;
	TEMP tempUnits;

	static Future<File> getConfigFile() async {
		String dir = (await getApplicationDocumentsDirectory()).path;
		return new File('$dir/config.json');
	}

	static Future<Config> readConfig() async {
		Config cfg = new Config();
		try {
			File file = await getConfigFile();
			String contents = await file.readAsString();
			Map res = JSON.decode(contents);
			cfg.tempUnits = numToTempUnit(res['tempUnits'] ?? 0);
			cfg.location = res['location'] ?? "Prague";
		} on FileSystemException {
			cfg.tempUnits = TEMP.CELSIUS;
			cfg.location = "Prague";
		}
		return cfg;
	}

	void updateData(WeatherProvider w) {
		location = w.location;
		tempUnits = w.tempUnits;
	}

	void saveConfig() {
		getConfigFile().then((File file) {
			Map config = new Map();
			config['location'] = location;
			config['tempUnits'] = tempUnitToNum(tempUnits);
			file.writeAsString(JSON.encode(config));
		});
	}
}