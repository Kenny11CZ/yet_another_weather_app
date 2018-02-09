import 'dart:async';

abstract class WeatherProvider {
	String location;
	TEMP tempUnits = TEMP.CELSIUS;

	WeatherProvider();

	num getTemperature();

	num getTemperatureMax();

	num getTemperatureMin();

	num getHumidity();

	num getPressure();

	num getWindSpeed();

	String getWindDirection();

	String getLocation();

	void setData(Object data);

	Future get() async{}
}

enum TEMP { KELVIN, CELSIUS, FAHRENHEIT }

num kelvinToCelsius(num kelvin) {
	return kelvin - 273.15;
}

num kelvinToFahrenheit(num kelvin) {
	return (kelvin - 273.15) * (9 / 5) + 32;
}

String tempUnitToString(TEMP temp) {
	switch (temp) {
		case TEMP.CELSIUS:
			return "°C";
		case TEMP.FAHRENHEIT:
			return "°F";
		case TEMP.KELVIN:
			return "K";
		default:
			return "";
	}
}

int tempUnitToNum(TEMP temp) {
	return temp.index;
}

TEMP numToTempUnit(int n) {
	if(n < 0 || n >= TEMP.values.length) {
		return TEMP.CELSIUS;
	}
	return TEMP.values[n];
}

String degToCompass(num deg) {
	num index = (deg / 22.5) + 0.5;
	List<String> arr = [
		"N",
		"NNE",
		"NE",
		"ENE",
		"E",
		"ESE",
		"SE",
		"SSE",
		"S",
		"SSW",
		"SW",
		"WSW",
		"W",
		"WNW",
		"NW",
		"NNW"
	];
	return arr[(index % 16).round()];
}
