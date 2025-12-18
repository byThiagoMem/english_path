import 'package:equatable/equatable.dart';

abstract class BaseState extends Equatable {
  const BaseState();

  String get message => '';

  Object? get response => null;
}

class IdleState extends BaseState {
  const IdleState();

  @override
  List<Object?> get props => [];
}

class LoadingState extends BaseState {
  const LoadingState();

  @override
  List<Object?> get props => [];
}

class SuccessState extends BaseState {
  @override
  final String message;

  @override
  final Object? response;

  const SuccessState({this.message = '', this.response});

  @override
  List<Object?> get props => [message];
}

class FailureState extends BaseState {
  @override
  final String message;

  const FailureState(this.message);

  @override
  List<Object?> get props => [message];
}
