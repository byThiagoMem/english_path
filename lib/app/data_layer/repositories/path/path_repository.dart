import '../../../domain_layer/domain_layer.dart';
import '../../../infra/infra.dart';
import '../../data_layer.dart';

class PathRepository implements IPathRepository {
  final PathDataSource _dataSource;

  PathRepository({
    required PathDataSource dataSource,
  }) : _dataSource = dataSource;

  @override
  Future<Result<PathEntity>> getPath() async {
    final result = await _dataSource.getPath();

    return result.fold(
      onSuccess: (dto) => Success(dto as PathEntity),
      onFailure: (error) => Failure(error),
    );
  }

  @override
  Future<Result<PathEntity>> savePath(PathEntity path) async {
    final result = await _dataSource.savePath(path.toDTO);

    return result.fold(
      onSuccess: (dto) => Success(dto as PathEntity),
      onFailure: (error) => Failure(error),
    );
  }

  @override
  Future<Result<PathEntity>> resetPath() async {
    await _dataSource.clearCache();

    final result = await _dataSource.getPath();

    return result.fold(
      onSuccess: (dto) => Success(dto as PathEntity),
      onFailure: (error) => Failure(error),
    );
  }
}
