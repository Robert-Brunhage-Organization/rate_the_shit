import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile/src/core/dio.dart';

final voteRepositoryProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  return VoteRepository(dio);
}, dependencies: [dioProvider]);

class VoteRepository {
  VoteRepository(this._dio);
  final Dio _dio;

  Future<bool> vote(String name, int value) async {
    final result = await  _dio.post(
      "/shit",
      data: <String, dynamic>{
        'value': value,
        'name': name,
      },
    );

    return result.data != null;
  }
}
