import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:weather_app/core/errors/errors_classes.dart';

class ApiHttpClientService {
  static const Duration _timeout = Duration(seconds: 30);

  // Método genérico para GET requests
  static Future<Map<String, dynamic>> get(
    String url, {
    Map<String, String>? headers,
  }) async {
    try {
      // Descomente as linhas abaixo para usar dados de teste (mock)
      // await Future.delayed(const Duration(seconds: 2));
      // return _mockResponse(url);

      final response = await http
          .get(
            Uri.parse(url),
            headers: {'Content-Type': 'application/json', ...?headers},
          )
          .timeout(_timeout);

      return _handleResponse(response);
    } on SocketException {
      throw ApiException('Sem conexão com a internet');
    } on HttpException {
      throw ApiException('Erro na requisição HTTP');
    } catch (e) {
      throw ApiException('Erro inesperado: $e');
    }
  }

  // Método genérico para POST requests
  static Future<Map<String, dynamic>> post(
    String url, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse(url),
            headers: {'Content-Type': 'application/json', ...?headers},
            body: body != null ? json.encode(body) : null,
          )
          .timeout(_timeout);

      return _handleResponse(response);
    } on SocketException {
      throw ApiException('Sem conexão com a internet');
    } on HttpException {
      throw ApiException('Erro na requisição HTTP');
    } catch (e) {
      throw ApiException('Erro inesperado: $e');
    }
  }

  static Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return {};
      return json.decode(response.body);
    } else {
      switch (response.statusCode) {
        case 400:
          throw ApiException('Requisição inválida');
        case 401:
          throw ApiException('Não autorizado');
        case 403:
          throw ApiException('Acesso negado');
        case 404:
          throw ApiException('Recurso não encontrado');
        case 500:
          throw ApiException('Erro interno do servidor');
        default:
          throw ApiException('Erro na API: ${response.statusCode}');
      }
    }
  }

  static Map<String, dynamic> _mockResponse(String url) {
    if (url.contains('current.json')) {
      // Mock para clima atual
      const jsonString = '''
      {
        "location": {
          "name": "Futsal City"
        },
        "current": {
          "temp_c": 24.5,
          "pressure_mb": 1013,
          "humidity": 60,
          "wind_kph": 5.5,
          "condition": {
            "text": "Sunny"
          }
        }
      }
      ''';
      return json.decode(jsonString);
    } else {
      // Mock para previsão
      const jsonString = '''
      {
        "forecast": {
          "forecastday": [
            {
              "date": "2025-08-16",
              "day": {
                "maxtemp_c": 25.0,
                "mintemp_c": 17.0,
                "condition": {
                  "text": "Sunny"
                }
              }
            },
            {
              "date": "2025-08-17",
              "day": {
                "maxtemp_c": 21.0,
                "mintemp_c": 15.0,
                "condition": {
                  "text": "Partly cloudy"
                }
              }
            },
            {
              "date": "2025-08-18",
              "day": {
                "maxtemp_c": 18.0,
                "mintemp_c": 13.0,
                "condition": {
                  "text": "Patchy rain possible"
                }
              }
            },
            {
              "date": "2025-08-19",
              "day": {
                "maxtemp_c": 24.0,
                "mintemp_c": 16.0,
                "condition": {
                  "text": "Cloudy"
                }
              }
            },
            {
              "date": "2025-08-20",
              "day": {
                "maxtemp_c": 28.0,
                "mintemp_c": 20.0,
                "condition": {
                  "text": "Clear"
                }
              }
            }
          ]
        }
      }
      ''';
      return json.decode(jsonString);
    }
  }
}
