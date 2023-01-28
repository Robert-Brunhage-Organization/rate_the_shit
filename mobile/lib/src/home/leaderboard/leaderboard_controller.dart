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

  final List<Shit> _shits = [];
  UnmodifiableListView<Shit> get shits => UnmodifiableListView(_shits);

  Future<Result<List<Shit>, Exception>> getAll() async {
    setBusy();
    final result = await _leaderboardService.getAll();

    result.when(
      (shitResults) {
        _veryUglySortingPleaseHelp(shitResults);
      },
      (error) {},
    );

    setBusy(false);
    return result;
  }

  /// This is really really ugly and just didn't want to bother with the
  /// solution. Best case would be to do this in the API layer and just return the
  /// ordered results but yeah.
  void _veryUglySortingPleaseHelp(List<Shit> shitResults) {
    _shits.clear();
    final itemsWithoutZero = shitResults
        .where(
            (element) => element.positiveRating + element.negativeRating != 0)
        .toList();

    itemsWithoutZero.sort((a, b) {
      final aPercentage =
          (a.positiveRating / (a.positiveRating + a.negativeRating)) * 100;
      final bPercentage =
          (b.positiveRating / (b.positiveRating + b.negativeRating)) * 100;

      if (aPercentage == bPercentage) {
        return (b.positiveRating + b.negativeRating) -
            (a.positiveRating + a.negativeRating);
      }

      return (bPercentage - aPercentage).round();
    });

    final itemsWithZero = shitResults
        .where(
          (element) => element.positiveRating + element.negativeRating == 0,
        )
        .toList();

    _shits.addAll(itemsWithoutZero);
    _shits.addAll(itemsWithZero);
  }
}
