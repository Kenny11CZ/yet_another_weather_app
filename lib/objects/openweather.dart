import 'package:yet_another_weather_app/objects/weather_provider.dart';

import 'dart:io';
import 'dart:convert';
import 'dart:async';

class OpenWeather implements WeatherProvider {
	String location;
	String APPID = "edd82fca83eb34093d6d1100be727c34";
	TEMP tempUnits = TEMP.CELSIUS;
	Map data;

	OpenWeather() {
		this.location = location;
	}

	num getTemperature() {
		if (data == null) {
			return 0;
		}
		return convert(tempUnits, data['main']['temp']);
	}

	num getTemperatureMax() {
		if (data == null) {
			return 0;
		}
		return convert(tempUnits, data['main']['temp_max']);
	}

	num getTemperatureMin() {
		if (data == null) {
			return 0;
		}
		return convert(tempUnits, data['main']['temp_min']);
	}

	num getHumidity() {
		if (data == null) {
			return 0;
		}
		return data['main']['humidity'];
	}

	num getPressure() {
		if (data == null) {
			return 0;
		}
		return data['main']['pressure'];
	}

	num getWindSpeed() {
		if (data == null) {
			return 0;
		}
		return data['wind']['speed'];
	}

	String getWindDirection() {
		if (data == null) {
			return "-";
		}
		return degToCompass(data['wind']['deg']);
	}

	String getLocation() {
		if(this.location == null) {
			return "Not set";
		}
		return this.location;
	}

	num convert(TEMP desired, num numberInKelvin) {
		switch (desired) {
			case TEMP.KELVIN:
				return numberInKelvin;
			case TEMP.CELSIUS:
				return kelvinToCelsius(numberInKelvin);
			case TEMP.FAHRENHEIT:
				return kelvinToFahrenheit(numberInKelvin);
			default:
				return 0;
		}
	}

	void setData(Object data) {
		this.data = data;
	}

	Future get() async {
		if(this.location == null) {
			return null;
		}
		var httpClient = new HttpClient();
		var uri = new Uri.http(
			'api.openweathermap.org', 'data/2.5/weather',
			{'q': this.location, 'APPID': this.APPID});
		var request = await httpClient.getUrl(uri);
		var response = await request.close();
		var responseBody = await response.transform(UTF8.decoder).join();
		data = JSON.decode(responseBody);
		return data;
	}
}