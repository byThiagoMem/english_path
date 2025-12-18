import '../../../infra/infra.dart';
import '../../domain_layer.dart';

class ResetPathUseCase {
  final IPathRepository _repository;

  ResetPathUseCase({
    required IPathRepository repository,
  }) : _repository = repository;

  Future<Result<PathEntity>> call() async {
    return await _repository.resetPath();
  }
}
