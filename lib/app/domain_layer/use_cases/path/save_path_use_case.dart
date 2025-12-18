import '../../../infra/infra.dart';
import '../../domain_layer.dart';

class SavePathUseCase {
  final IPathRepository _repository;

  SavePathUseCase({
    required IPathRepository repository,
  }) : _repository = repository;

  Future<Result<PathEntity>> call(PathEntity path) async {
    return await _repository.savePath(path);
  }
}
