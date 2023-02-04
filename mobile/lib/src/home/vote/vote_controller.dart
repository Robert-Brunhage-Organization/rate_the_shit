import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile/src/home/vote/vote_service.dart';
import 'package:mobile/src/home/vote/vote_view.dart';
import 'package:multiple_result/multiple_result.dart';

import '../../core/shit_change_notifier.dart';

final voteControllerProvider = ChangeNotifierProvider((ref) {
  return VoteController(
    ref.watch(voteServiceProvider),
  );
});

class VoteController extends ShitChangeNotifier {
  VoteController(this._voteService);
  final VoteService _voteService;

  int _currentShit = 0;
  int get currentShit => _currentShit;

  int _shitsVotedOn = 0;
  bool get noMoreShits => _shitsVotedOn >= VoteView.shits.length;

  void nextPage() {
    _currentShit++;
    notifyListeners();
  }

  Future<Result<bool, Exception>> vote(int value, String name) async {
    setBusy();
    final result = await _voteService.vote(name, value);

    result.when(
      (success) {
        _shitsVotedOn++;
        if (!noMoreShits) {
          nextPage();
        }
      },
      (error) {},
    );

    setBusy(false);
    return result;
  }
}
