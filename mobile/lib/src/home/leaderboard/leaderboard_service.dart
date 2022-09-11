import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile/src/home/leaderboard/leaderboard_repository.dart';
import 'package:multiple_result/multiple_result.dart';

import '../shit.dart';

final leaderboardServiceProvider = Provider((ref) {
  final leaderboardRepository = ref.watch(leaderboardRepositoryProvider);
  return LeaderboardService(leaderboardRepository);
}, dependencies: [leaderboardRepositoryProvider]);

class LeaderboardService {
  LeaderboardService(this._leaderboardRepository);
  final LeaderboardRepository _leaderboardRepository;

  Future<Result<Exception, List<Shit>>> getAll() async {
    try {
      final result = await _leaderboardRepository.getAll();
      final shits = result.map((e) => Shit.fromEntity(e)).toList();
      return Success(shits);
    } on DioError catch (e) {
      return Error(e);
    }
  }
}
