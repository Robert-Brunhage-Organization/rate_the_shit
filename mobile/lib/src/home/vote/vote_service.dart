import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile/src/home/vote/vote_repository.dart';
import 'package:multiple_result/multiple_result.dart';

final voteServiceProvider = Provider((ref) {
  final voteRepository = ref.watch(voteRepositoryProvider);
  return VoteService(voteRepository);
}, dependencies: [voteRepositoryProvider]);

class VoteService {
  VoteService(this._voteRepository);
  final VoteRepository _voteRepository;

  Future<Result<Exception, bool>> vote(String name, int value) async {
    try {
      final result = await _voteRepository.vote(name, value);
      return Success(result);
    } on DioError catch (e) {
      return Error(e);
    }
  }
}
