import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain_layer/domain_layer.dart';
import '../../../infra/infra.dart';
import 'path_state.dart';

class PathCubit extends Cubit<PathState> {
  final GetPathUseCase _getPathUseCase;
  final SavePathUseCase _savePathUseCase;
  final ResetPathUseCase _resetPathUseCase;
  final Random _random;

  PathCubit(
    this._getPathUseCase,
    this._savePathUseCase,
    this._resetPathUseCase, {
    Random? random,
  })  : _random = random ?? Random(),
        super(const PathState());

  Future<void> loadPath() async {
    emit(state.copyWith(state: LoadPathLoadingState()));

    await Future.delayed(const Duration(seconds: 1));

    // Simulate a random failure for demonstration purposes
    if (_random.nextInt(100) < 30) {
      emit(
        state.copyWith(
          state: LoadPathFailureState(
            '''Não foi possível carregar os dados. Verifique sua conexão e tente novamente.''',
          ),
        ),
      );
      return;
    }

    final result = await _getPathUseCase();

    result.result(
      (data) {
        emit(
          state.copyWith(
            state: LoadPathSuccessState(),
            path: data,
          ),
        );
      },
      (failure) {
        emit(state.copyWith(state: LoadPathFailureState(failure.message)));
      },
    );
  }

  Future<void> savePath() async {
    emit(state.copyWith(state: SavePathLoadingState()));

    final result = await _savePathUseCase(state.path);

    result.result(
      (data) {
        emit(
          state.copyWith(
            state: SavePathSuccessState(),
            path: data,
          ),
        );
      },
      (failure) {
        emit(state.copyWith(state: SavePathFailureState(failure.message)));
      },
    );
  }

  void updateTaskCompletion({
    required String lessonId,
    required String taskId,
    required bool isCompleted,
  }) {
    final updatedLessons = state.path.lessons.map((lesson) {
      if (lesson.id == lessonId) {
        final updatedTasks = lesson.tasks.map((task) {
          if (task.id == taskId) {
            return task.copyWith(isCompleted: isCompleted);
          }
          return task;
        }).toList();

        return lesson.copyWith(tasks: updatedTasks);
      }
      return lesson;
    }).toList();

    final lessonsWithUpdatedStatus = _updateLessonStatuses(updatedLessons);

    final updatedPath = state.path.copyWith(lessons: lessonsWithUpdatedStatus);

    emit(state.copyWith(path: updatedPath));

    savePath();
  }

  List<LessonEntity> _updateLessonStatuses(List<LessonEntity> lessons) {
    final updatedLessons = <LessonEntity>[];

    for (var i = 0; i < lessons.length; i++) {
      final lesson = lessons[i];
      final allTasksCompleted = lesson.tasks.every((task) => task.isCompleted);

      final shouldUnlock = i > 0 &&
          updatedLessons[i - 1].status == LessonStatus.completed &&
          lesson.status == LessonStatus.locked;

      LessonStatus newStatus = lesson.status;
      if (allTasksCompleted && lesson.status != LessonStatus.completed) {
        newStatus = LessonStatus.completed;
      } else if (shouldUnlock) {
        newStatus = LessonStatus.current;
      }

      updatedLessons.add(lesson.copyWith(status: newStatus));
    }

    return updatedLessons;
  }

  void resetLessonTasks({required String lessonId}) {
    final updatedLessons = state.path.lessons.map((lesson) {
      if (lesson.id == lessonId) {
        final resetTasks = lesson.tasks.map((task) {
          return task.copyWith(isCompleted: false);
        }).toList();

        return lesson.copyWith(tasks: resetTasks);
      }
      return lesson;
    }).toList();

    final lessonsWithUpdatedStatus = _updateLessonStatuses(updatedLessons);

    final updatedPath = state.path.copyWith(lessons: lessonsWithUpdatedStatus);

    emit(state.copyWith(path: updatedPath));

    savePath();
  }

  Future<void> resetPath() async {
    emit(state.copyWith(state: ResetPathLoadingState()));

    final result = await _resetPathUseCase();

    result.result(
      (data) {
        emit(
          state.copyWith(
            state: ResetPathSuccessState(),
            path: data,
          ),
        );
      },
      (failure) {
        emit(state.copyWith(state: ResetPathFailureState(failure.message)));
      },
    );
  }
}
