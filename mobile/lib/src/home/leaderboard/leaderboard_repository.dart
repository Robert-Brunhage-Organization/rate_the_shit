import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile/src/core/dio.dart';

import '../shit_entity.dart';

final leaderboardRepositoryProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  return LeaderboardRepository(dio);
}, dependencies: [dioProvider]);

class LeaderboardRepository {
  LeaderboardRepository(this._dio);
  final Dio _dio;

  // get leaderboard
  Future<List<ShitEntity>> getAll() async {
    final result = await _dio.get(
      "/shit",
    );
    final data = List<Map<String, dynamic>>.from(result.data!);

    return data.map((e) => ShitEntity.fromMap(e)).toList();
  }
}
