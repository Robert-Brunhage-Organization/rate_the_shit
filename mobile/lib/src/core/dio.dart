import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile/src/app.dart';
import 'package:mobile/src/styles.dart';

final dioProvider = Provider((ref) {
  final key = ref.watch(messengerKeyProvider);

  final dio = Dio(
    BaseOptions(
      baseUrl: kReleaseMode
          ? 'https://rate-the-shit.vercel.app/api'
          : Platform.isAndroid
              ? 'http://10.0.2.2:3000/api'
              : 'http://localhost:3000/api',
    ),
  );

  dio.interceptors.add(CustomInterceptors(key));

  return dio;
}, dependencies: [messengerKeyProvider]);

class CustomInterceptors extends Interceptor {
  CustomInterceptors(this.key);
  GlobalKey<ScaffoldMessengerState> key;

  @override
  onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint('REQUEST[${options.method}] => PATH: ${options.path}');
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint(
      'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
    );
    debugPrint('RESPONSE VALUE: ${response.data}');
    return super.onResponse(response, handler);
  }

  @override
  onError(DioError err, ErrorInterceptorHandler handler) {
    debugPrint(
      'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',
    );
    key.currentState!.showSnackBar(
      SnackBar(
        content: Text(
          dioMapper(err),
          style: $styles.text.body.copyWith(
            color: $styles.colors.white,
          ),
        ),
        backgroundColor: Colors.red,
      ),
    );
    return super.onError(err, handler);
  }
}

String dioMapper(DioError e) {
  if (e.type == DioErrorType.connectTimeout) {
    return 'Connection timed out';
  }

  if (e.type == DioErrorType.receiveTimeout) {
    return 'Unable to connect to the server';
  }

  return 'Hold up! Having some issues on our end';
}
