import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile/src/home/vote/vote_service.dart';
import 'package:mobile/src/home/vote/vote_view.dart';
import 'package:multiple_result/multiple_result.dart';

import '../../core/shit_change_notifier.dart';

final voteController = ChangeNotifierProvider((ref) {
  return VoteController(
    ref.watch(voteServiceProvider),
  );
});

class VoteController extends ShitChangeNotifier {
  VoteController(this._voteService);
  final VoteService _voteService;

  late final _pageController = PageController();
  PageController get pageController => _pageController;
  int get currentPage => pageController.page?.round() ?? 0;

  int _shitsVotedOn = 0;
  bool get noMoreShits => _shitsVotedOn >= VoteView.shits.length;

  void nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<Result<Exception, bool>> vote(int value, String name) async {
    setBusy();
    final result = await _voteService.vote(name, value);
    setBusy(false);

    result.when(
      (error) => null,
      (success) {
        _shitsVotedOn++;
        notifyListeners();
        if (!noMoreShits) {
          nextPage();
        }
      },
    );

    return result;
  }
}
