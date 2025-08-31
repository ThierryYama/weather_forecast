// Configurações da API
class ApiConfig {
  // WeatherAPI
  static const String baseUrl = 'https://api.weatherapi.com/v1';
  static const String apiKey = 'bc7d49d9085643c9961143704253108'; // Substitua pela sua chave
  
  // URLs de endpoints
  static const String currentWeatherEndpoint = '/current.json';
  static const String forecastEndpoint = '/forecast.json';
  
  // Parâmetros padrão
  static const String language = 'pt'; // Português
  
  // Timeouts
  static const Duration requestTimeout = Duration(seconds: 30);
  static const Duration connectionTimeout = Duration(seconds: 15);
  
  // Métodos auxiliares
  static String buildCurrentWeatherUrl(String cityName) {
    return '$baseUrl$currentWeatherEndpoint'
           '?key=$apiKey'
           '&q=$cityName'
           '&lang=$language';
  }
  
  static String buildForecastUrl(String cityName, {int days = 5}) {
    return '$baseUrl$forecastEndpoint'
           '?key=$apiKey'
           '&q=$cityName'
           '&days=$days'
           '&lang=$language';
  }
  
  static String buildCurrentWeatherByCoordinatesUrl(double lat, double lon) {
    return '$baseUrl$currentWeatherEndpoint'
           '?key=$apiKey'
           '&q=$lat,$lon'
           '&lang=$language';
  }
  
  static String buildForecastByCoordinatesUrl(double lat, double lon, {int days = 5}) {
    return '$baseUrl$forecastEndpoint'
           '?key=$apiKey'
           '&q=$lat,$lon'
           '&days=$days'
           '&lang=$language';
  }
}