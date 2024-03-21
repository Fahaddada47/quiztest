import 'package:dio/dio.dart';
import 'package:quiztest/features/data/repository/network_response.dart';

class NetworkExecutor {
  final Dio _dio;

  NetworkExecutor(this._dio);

  Future<NetworkResponse> getRequest({
    required String path,
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? headers,
    Options? options,
  }) async {
    Response? response;
    try {
      response = await _dio.get(
        path,
        queryParameters: queryParams,
        options: options,
      );
      return NetworkResponse(
        response.statusCode ?? -1,
        response.data,
        response.headers,
        response.statusMessage ?? '',
      );
    } catch (e) {
      return NetworkResponse(
        response?.statusCode ?? -1,
        response?.data ??
            {
              'success': false,
              'message': 'Something went wrong',
              'response_code': -1
            },
        response?.headers ?? <String, dynamic>{},
        response?.statusMessage ?? '',
      );
    }
  }

  Future<NetworkResponse> postRequest({
    required String path,
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? headers,
    dynamic data,
    Options? options,
  }) async {
    Response? response;
    try {
      response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParams,
        options: options,
      );
      return NetworkResponse(
        response.statusCode ?? -1,
        response.data,
        response.headers,
        response.statusMessage ?? '',
      );
    } catch (e) {
      return NetworkResponse(
        response?.statusCode ?? -1,
        response?.data ??
            {
              'success': false,
              'message': 'Something went wrong',
              'response_code': -1
            },
        response?.headers ?? {},
        response?.statusMessage ?? '',
      );
    }
  }
}
