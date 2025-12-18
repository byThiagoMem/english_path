import '../../../infra/infra.dart';
import '../../domain_layer.dart';

abstract class IPathRepository {
  Future<Result<PathEntity>> getPath();

  Future<Result<PathEntity>> savePath(PathEntity path);

  Future<Result<PathEntity>> resetPath();
}
