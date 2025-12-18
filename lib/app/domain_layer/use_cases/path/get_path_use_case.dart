import '../../../infra/infra.dart';
import '../../domain_layer.dart';

class GetPathUseCase {
  final IPathRepository _repository;

  GetPathUseCase({
    required IPathRepository repository,
  }) : _repository = repository;

  Future<Result<PathEntity>> call() async {
    return await _repository.getPath();
  }
}
