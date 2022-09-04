import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final voteController = ChangeNotifierProvider(((ref) => VoteController()));

class VoteController extends ChangeNotifier {
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
      final response = await Dio().post(
        "https://rate-the-shit.vercel.app/api/shit",
        data: <String, dynamic>{
          'value': value,
          'name': name,
        },
      );

      print(response.data);
    } catch (e) {
      print('Something went wrong $e');
    }
  }
}
