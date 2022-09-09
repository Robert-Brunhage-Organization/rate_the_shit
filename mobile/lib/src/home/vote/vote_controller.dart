import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final voteController = ChangeNotifierProvider(((ref) {
  return VoteController(
    ref.watch(dioProvider),
  );
}));

final dioProvider = Provider((ref) {
  return Dio(
    BaseOptions(
      baseUrl: kReleaseMode
          ? 'https://rate-the-shit.vercel.app/api'
          : Platform.isAndroid
              ? 'http://10.0.2.2:3000/api'
              : 'http://localhost:3000/api',
    ),
  );
});

class VoteController extends ChangeNotifier {
  VoteController(this._dio);
  final Dio _dio;

  late final _pageController = PageController();
  PageController get pageController => _pageController;

  void nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> vote(int value, String name) async {
    try {
      final response = await _dio.post(
        "/shit",
        data: <String, dynamic>{
          'value': value,
          'name': name,
        },
      );
      debugPrint(response.statusMessage);
    } on DioError catch (e) {
      debugPrint('Something went wrong $e');
    }
  }
}
