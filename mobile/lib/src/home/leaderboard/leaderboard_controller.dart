import 'dart:collection';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile/src/home/leaderboard/leaderboard_service.dart';
import 'package:mobile/src/home/shit.dart';
import 'package:multiple_result/multiple_result.dart';

import '../../core/shit_change_notifier.dart';

final leaderboardControllerProvider = ChangeNotifierProvider((ref) {
  return LeaderboardController(
    ref.watch(leaderboardServiceProvider),
  );
}, dependencies: [leaderboardServiceProvider]);

class LeaderboardController extends ShitChangeNotifier {
  LeaderboardController(this._leaderboardService);
  final LeaderboardService _leaderboardService;

  List<Shit> _shits = [];
  UnmodifiableListView<Shit> get shits => UnmodifiableListView(_shits);
  

  Future<Result<Exception, List<Shit>>> getAll() async {
    setBusy();
    final result = await _leaderboardService.getAll();

    result.when(
      (error) => null,
      (successValue) {
        _shits = successValue;
      },
    );

    setBusy(false);
    return result;
  }
}
