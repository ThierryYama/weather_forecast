import 'package:weather_app/core/config/api_config.dart';
import 'package:weather_app/core/errors/errors_classes.dart';
import 'package:weather_app/core/patterns/result.dart';
import 'package:weather_app/core/typesdef/types_defs.dart';
import 'package:weather_app/data/services/api_http_client_service.dart';
import 'package:weather_app/data/services/weather_service_contract.dart';
import 'package:weather_app/domain/models/weather.dart';

class WeatherApiService implements IWeatherService {
  // Buscar clima atual por nome da cidade
  @override
  Future<WeatherResult> getCurrentWeather(String cityName) async {
    try {
      final url = ApiConfig.buildCurrentWeatherUrl(cityName);
      final data = await ApiHttpClientService.get(url);

      final weather = Weather.fromJson(data);
      return Success(weather);
    } on ApiException catch (e) {
      return Error(ApiException(e.msg));
    } catch (e) {
      return Error(DefaultError('Erro ao buscar clima atual: $e.'));
    }
  }

  // Buscar previsão de 5 dias
  @override
  Future<ForecastResult> getForecast(String cityName) async {
    try {
      final url = ApiConfig.buildForecastUrl(cityName);
      final data = await ApiHttpClientService.get(url);

      final List<dynamic> forecastList = data['forecast']['forecastday'];
      final forecast =
          forecastList
              .take(5)
              .map((item) => WeatherForecast.fromJson(item))
              .toList();

      return Success(forecast);
    } on ApiException catch (e) {
      return Error(ApiException(e.msg));
    } catch (e) {
      return Error(DefaultError('Erro ao buscar previsão: $e.'));
    }
  }

  // Buscar clima por coordenadas (latitude, longitude)
  @override
  Future<WeatherResult> getWeatherByCoordinates(double lat, double lon) async {
    try {
      final url = ApiConfig.buildCurrentWeatherByCoordinatesUrl(lat, lon);
      final data = await ApiHttpClientService.get(url);

      final weather = Weather.fromJson(data);
      return Success(weather);
    } on ApiException catch (e) {
      return Error(ApiException(e.msg));
    } catch (e) {
      return Error(DefaultError('Erro ao buscar clima atual: $e.'));
    }
  }

  // Buscar previsão por coordenadas
  @override
  Future<ForecastResult> getForecastByCoordinates(
    double lat,
    double lon,
  ) async {
    try {
      final url = ApiConfig.buildForecastByCoordinatesUrl(lat, lon);
      final data = await ApiHttpClientService.get(url);

      final List<dynamic> forecastList = data['forecast']['forecastday'];
      final forecast =
          forecastList
              .take(5)
              .map((item) => WeatherForecast.fromJson(item))
              .toList();

      return Success(forecast);
    } on ApiException catch (e) {
      return Error(ApiException(e.msg));
    } catch (e) {
      return Error(DefaultError('Erro ao buscar previsão: $e.'));
    }
  }

  // A API WeatherAPI já retorna a previsão diária, então este método não é mais necessário.
  // static bool _isDailyForecast(String dateTime) {
  //   return dateTime.contains('12:00:00');
  // }
}
