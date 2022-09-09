import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile/src/home/vote/vote_view.dart';

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
  int get currentPage => pageController.page?.round() ?? 1;

  int _shitsVotedOn = 0;
  bool get noMoreShits => _shitsVotedOn >= VoteView.shits.length;

  void nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> vote(int value, String name) async {
    try {
      _shitsVotedOn++;
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
    } finally {
      if (!noMoreShits) {
        nextPage();
      }
      notifyListeners();
    }
  }
}
