import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/providers/user_provider.dart';

final dioProvider = Provider<Dio>((ref) {

  final dio =  Dio(
    BaseOptions(
      baseUrl: 'http://10.0.2.2:8000/api',//here we change it to out base url
      connectTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Accept': 'application/json',}),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        final user = ref.read(UserProvider);
        final token = user?.token;

        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }

        return handler.next(options);
      },
    ),
  );

  return dio;
});