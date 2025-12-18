import 'dart:math';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_fluency/app/domain_layer/domain_layer.dart';
import 'package:mini_fluency/app/infra/infra.dart';
import 'package:mini_fluency/app/presentation_layer/path/cubit/path_cubit.dart';
import 'package:mini_fluency/app/presentation_layer/path/cubit/path_state.dart';
import 'package:mocktail/mocktail.dart';

class MockGetPathUseCase extends Mock implements GetPathUseCase {}

class MockSavePathUseCase extends Mock implements SavePathUseCase {}

class MockResetPathUseCase extends Mock implements ResetPathUseCase {}

class FakeRandom implements Random {
  final int _value;

  FakeRandom(this._value);

  @override
  int nextInt(int max) => _value;

  @override
  bool nextBool() => false;

  @override
  double nextDouble() => 0.0;
}

void main() {
  late PathCubit cubit;
  late MockGetPathUseCase mockGetPathUseCase;
  late MockSavePathUseCase mockSavePathUseCase;
  late MockResetPathUseCase mockResetPathUseCase;

  final mockPath = PathEntity(
    id: '1',
    name: 'Test Path',
    description: 'Test Description',
    lessons: [
      LessonEntity(
        id: 'lesson1',
        title: 'Lesson 1',
        position: 1,
        status: LessonStatus.current,
        xp: 100,
        estimatedMinutes: 10,
        tasks: [
          TaskEntity(
            id: 'task1',
            title: 'Task 1',
            type: TaskType.listenRepeat,
            estimatedSeconds: 60,
            isCompleted: false,
          ),
          TaskEntity(
            id: 'task2',
            title: 'Task 2',
            type: TaskType.multipleChoice,
            estimatedSeconds: 120,
            isCompleted: false,
          ),
        ],
      ),
      LessonEntity(
        id: 'lesson2',
        title: 'Lesson 2',
        position: 2,
        status: LessonStatus.locked,
        xp: 150,
        estimatedMinutes: 15,
        tasks: [
          TaskEntity(
            id: 'task3',
            title: 'Task 3',
            type: TaskType.fillInTheBlanks,
            estimatedSeconds: 90,
            isCompleted: false,
          ),
        ],
      ),
    ],
  );

  setUp(() {
    mockGetPathUseCase = MockGetPathUseCase();
    mockSavePathUseCase = MockSavePathUseCase();
    mockResetPathUseCase = MockResetPathUseCase();

    // Usa FakeRandom que retorna sempre 50 (>= 30, nunca simula erro)
    cubit = PathCubit(
      mockGetPathUseCase,
      mockSavePathUseCase,
      mockResetPathUseCase,
      random: FakeRandom(50),
    );
  });

  setUpAll(() {
    registerFallbackValue(mockPath);
  });

  tearDown(() {
    cubit.close();
  });

  group('PathCubit -', () {
    group('loadPath', () {
      blocTest<PathCubit, PathState>(
        'emite [LoadPathLoadingState, LoadPathSuccessState] quando sucesso',
        build: () {
          when(() => mockGetPathUseCase()).thenAnswer(
            (_) async => Success(mockPath),
          );
          return cubit;
        },
        act: (cubit) => cubit.loadPath(),
        wait: const Duration(seconds: 2),
        expect: () => [
          PathState(state: LoadPathLoadingState()),
          PathState(
            state: LoadPathSuccessState(),
            path: mockPath,
          ),
        ],
        verify: (_) {
          verify(() => mockGetPathUseCase()).called(1);
        },
      );

      blocTest<PathCubit, PathState>(
        'emite [LoadPathLoadingState, LoadPathFailureState] quando falha',
        build: () {
          when(() => mockGetPathUseCase()).thenAnswer(
            (_) async => Failure('Erro ao carregar'),
          );
          return cubit;
        },
        act: (cubit) => cubit.loadPath(),
        wait: const Duration(seconds: 2),
        expect: () => [
          PathState(state: LoadPathLoadingState()),
          PathState(
            state: LoadPathFailureState('Erro ao carregar'),
          ),
        ],
        verify: (_) {
          verify(() => mockGetPathUseCase()).called(1);
        },
      );

      blocTest<PathCubit, PathState>(
        'emite LoadPathFailureState quando simulação de erro é ativada',
        build: () {
          return PathCubit(
            mockGetPathUseCase,
            mockSavePathUseCase,
            mockResetPathUseCase,
            random: FakeRandom(15), // < 30, simula erro
          );
        },
        act: (cubit) => cubit.loadPath(),
        wait: const Duration(seconds: 2),
        expect: () => [
          PathState(state: LoadPathLoadingState()),
          PathState(
            state: LoadPathFailureState(
              '''Não foi possível carregar os dados. Verifique sua conexão e tente novamente.''',
            ),
          ),
        ],
        verify: (_) {
          // Não deve chamar useCase pois erro foi simulado antes
          verifyNever(() => mockGetPathUseCase());
        },
      );
    });

    group('updateTaskCompletion', () {
      blocTest<PathCubit, PathState>(
        'atualiza task e chama savePath',
        build: () {
          when(() => mockSavePathUseCase(any())).thenAnswer(
            (invocation) async {
              final path = invocation.positionalArguments[0] as PathEntity;
              return Success(path);
            },
          );
          return cubit;
        },
        seed: () => PathState(path: mockPath),
        act: (cubit) => cubit.updateTaskCompletion(
          lessonId: 'lesson1',
          taskId: 'task1',
          isCompleted: true,
        ),
        wait: const Duration(milliseconds: 100),
        verify: (cubit) {
          final lesson = cubit.state.path.lessons.firstWhere(
            (l) => l.id == 'lesson1',
          );
          final task = lesson.tasks.firstWhere((t) => t.id == 'task1');
          expect(task.isCompleted, true);
          expect(cubit.state.state, isA<SavePathSuccessState>());
          verify(() => mockSavePathUseCase(any())).called(1);
        },
      );

      blocTest<PathCubit, PathState>(
        'completa lesson quando todas as tasks são completadas',
        build: () {
          when(() => mockSavePathUseCase(any())).thenAnswer(
            (invocation) async {
              final path = invocation.positionalArguments[0] as PathEntity;
              return Success(path);
            },
          );
          return cubit;
        },
        seed: () => PathState(
          path: mockPath.copyWith(
            lessons: [
              mockPath.lessons[0].copyWith(
                tasks: [
                  mockPath.lessons[0].tasks[0].copyWith(isCompleted: true),
                  mockPath.lessons[0].tasks[1],
                ],
              ),
              mockPath.lessons[1],
            ],
          ),
        ),
        act: (cubit) => cubit.updateTaskCompletion(
          lessonId: 'lesson1',
          taskId: 'task2',
          isCompleted: true,
        ),
        wait: const Duration(milliseconds: 100),
        verify: (cubit) {
          final lesson = cubit.state.path.lessons.firstWhere(
            (l) => l.id == 'lesson1',
          );
          final allCompleted = lesson.tasks.every((t) => t.isCompleted);
          expect(allCompleted, true);
          expect(lesson.status, LessonStatus.completed);
        },
      );

      blocTest<PathCubit, PathState>(
        'desbloqueia próxima lesson quando anterior é completada',
        build: () {
          when(() => mockSavePathUseCase(any())).thenAnswer(
            (invocation) async {
              final path = invocation.positionalArguments[0] as PathEntity;
              return Success(path);
            },
          );
          return cubit;
        },
        seed: () => PathState(
          path: mockPath.copyWith(
            lessons: [
              mockPath.lessons[0].copyWith(
                tasks: [
                  mockPath.lessons[0].tasks[0].copyWith(isCompleted: true),
                  mockPath.lessons[0].tasks[1],
                ],
              ),
              mockPath.lessons[1],
            ],
          ),
        ),
        act: (cubit) => cubit.updateTaskCompletion(
          lessonId: 'lesson1',
          taskId: 'task2',
          isCompleted: true,
        ),
        wait: const Duration(milliseconds: 100),
        verify: (cubit) {
          final currentLesson = cubit.state.path.lessons.firstWhere(
            (l) => l.id == 'lesson1',
          );
          final nextLesson = cubit.state.path.lessons.firstWhere(
            (l) => l.id == 'lesson2',
          );
          expect(currentLesson.status, LessonStatus.completed);
          expect(nextLesson.status, LessonStatus.current);
        },
      );
    });

    group('resetLessonTasks', () {
      blocTest<PathCubit, PathState>(
        'reseta todas as tasks da lesson',
        build: () {
          when(() => mockSavePathUseCase(any())).thenAnswer(
            (invocation) async {
              final path = invocation.positionalArguments[0] as PathEntity;
              return Success(path);
            },
          );
          return cubit;
        },
        seed: () => PathState(
          path: mockPath.copyWith(
            lessons: [
              mockPath.lessons[0].copyWith(
                status: LessonStatus.completed,
                tasks: [
                  mockPath.lessons[0].tasks[0].copyWith(isCompleted: true),
                  mockPath.lessons[0].tasks[1].copyWith(isCompleted: true),
                ],
              ),
              mockPath.lessons[1],
            ],
          ),
        ),
        act: (cubit) => cubit.resetLessonTasks(lessonId: 'lesson1'),
        verify: (cubit) {
          final lesson = cubit.state.path.lessons.firstWhere(
            (l) => l.id == 'lesson1',
          );
          final allReset = lesson.tasks.every((task) => !task.isCompleted);
          expect(allReset, true);
          verify(() => mockSavePathUseCase(any())).called(1);
        },
      );
    });

    group('resetPath', () {
      blocTest<PathCubit, PathState>(
        'emite [ResetPathLoadingState, ResetPathSuccessState] quando sucesso',
        build: () {
          when(() => mockResetPathUseCase()).thenAnswer(
            (_) async => Success(mockPath),
          );
          return cubit;
        },
        act: (cubit) => cubit.resetPath(),
        expect: () => [
          PathState(state: ResetPathLoadingState()),
          PathState(
            state: ResetPathSuccessState(),
            path: mockPath,
          ),
        ],
        verify: (_) {
          verify(() => mockResetPathUseCase()).called(1);
        },
      );

      blocTest<PathCubit, PathState>(
        'emite [ResetPathLoadingState, ResetPathFailureState] quando falha',
        build: () {
          when(() => mockResetPathUseCase()).thenAnswer(
            (_) async => Failure('Erro ao resetar'),
          );
          return cubit;
        },
        act: (cubit) => cubit.resetPath(),
        expect: () => [
          PathState(state: ResetPathLoadingState()),
          PathState(
            state: ResetPathFailureState('Erro ao resetar'),
          ),
        ],
        verify: (_) {
          verify(() => mockResetPathUseCase()).called(1);
        },
      );
    });
  });
}
