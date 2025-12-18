import 'package:equatable/equatable.dart';

import '../../../domain_layer/domain_layer.dart';
import '../../../infra/infra.dart';

/// States specific to loading the Path
class LoadPathLoadingState extends LoadingState {}

class LoadPathSuccessState extends SuccessState {}

class LoadPathFailureState extends FailureState {
  const LoadPathFailureState(super.statusFailure);
}

///
/// States specific to Saveing the Path
class SavePathLoadingState extends LoadingState {}

class SavePathSuccessState extends SuccessState {}

class SavePathFailureState extends FailureState {
  const SavePathFailureState(super.statusFailure);
}

///
/// States specific to Resetting the Path
class ResetPathLoadingState extends LoadingState {}

class ResetPathSuccessState extends SuccessState {}

class ResetPathFailureState extends FailureState {
  const ResetPathFailureState(super.statusFailure);
}

///

class PathState extends Equatable {
  final BaseState state;
  final PathEntity path;

  const PathState({
    this.state = const IdleState(),
    this.path = const PathEntity.empty(),
  });

  PathState copyWith({
    BaseState? state,
    PathEntity? path,
  }) =>
      PathState(
        state: state ?? this.state,
        path: path ?? this.path,
      );

  @override
  List<Object?> get props => [state, path];
}
