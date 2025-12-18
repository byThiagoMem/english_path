import 'package:flutter_test/flutter_test.dart';
import 'package:mini_fluency/app/data_layer/data_layer.dart';
import 'package:mini_fluency/app/domain_layer/domain_layer.dart';
import 'package:mini_fluency/app/infra/infra.dart';
import 'package:mocktail/mocktail.dart';

class MockPathDataSource extends Mock implements PathDataSource {}

void main() {
  late PathRepository repository;
  late MockPathDataSource mockDataSource;

  final mockPathDTO = PathDTO(
    id: '1',
    name: 'Test Path',
    description: 'Test Description',
    lessons: [],
  );

  setUp(() {
    mockDataSource = MockPathDataSource();
    repository = PathRepository(dataSource: mockDataSource);
  });

  setUpAll(() {
    registerFallbackValue(mockPathDTO);
  });

  group('PathRepository -', () {
    group('getPath', () {
      test('retorna Success com PathEntity quando dataSource retorna sucesso',
          () async {
        when(() => mockDataSource.getPath()).thenAnswer(
          (_) async => Success(mockPathDTO),
        );

        final result = await repository.getPath();

        expect(result, isA<Success<PathEntity>>());
        final pathEntity = result.dataOrNull;
        expect(pathEntity?.id, mockPathDTO.id);
        expect(pathEntity?.name, mockPathDTO.name);
        expect(pathEntity?.description, mockPathDTO.description);
        verify(() => mockDataSource.getPath()).called(1);
      });

      test('retorna Failure quando dataSource retorna falha', () async {
        when(() => mockDataSource.getPath()).thenAnswer(
          (_) async => Failure('Erro ao carregar'),
        );

        final result = await repository.getPath();

        expect(result, isA<Failure<PathEntity>>());
        expect((result as Failure).message, 'Erro ao carregar');
        verify(() => mockDataSource.getPath()).called(1);
      });
    });

    group('savePath', () {
      test('converte PathEntity para DTO e retorna Success', () async {
        final pathEntity = PathEntity(
          id: '1',
          name: 'Test Path',
          description: 'Test Description',
          lessons: [],
        );

        when(() => mockDataSource.savePath(any())).thenAnswer(
          (_) async => Success(mockPathDTO),
        );

        final result = await repository.savePath(pathEntity);

        expect(result, isA<Success<PathEntity>>());
        expect(result.dataOrNull?.id, pathEntity.id);
        verify(() => mockDataSource.savePath(any())).called(1);
      });

      test('retorna Failure quando dataSource retorna falha', () async {
        final pathEntity = PathEntity(
          id: '1',
          name: 'Test Path',
          description: 'Test Description',
          lessons: [],
        );

        when(() => mockDataSource.savePath(any())).thenAnswer(
          (_) async => Failure('Erro ao salvar'),
        );

        final result = await repository.savePath(pathEntity);

        expect(result, isA<Failure<PathEntity>>());
        expect((result as Failure).message, 'Erro ao salvar');
        verify(() => mockDataSource.savePath(any())).called(1);
      });

      test('passa DTO correto para dataSource', () async {
        final pathEntity = PathEntity(
          id: '1',
          name: 'Test Path',
          description: 'Test Description',
          lessons: [],
        );

        when(() => mockDataSource.savePath(any())).thenAnswer(
          (_) async => Success(mockPathDTO),
        );

        await repository.savePath(pathEntity);

        final captured = verify(
          () => mockDataSource.savePath(captureAny()),
        ).captured;

        final capturedDTO = captured.first as PathDTO;
        expect(capturedDTO.id, pathEntity.id);
        expect(capturedDTO.name, pathEntity.name);
      });
    });

    group('resetPath', () {
      test('limpa cache e retorna novo path com sucesso', () async {
        when(() => mockDataSource.clearCache()).thenAnswer((_) async => {});
        when(() => mockDataSource.getPath()).thenAnswer(
          (_) async => Success(mockPathDTO),
        );

        final result = await repository.resetPath();

        expect(result, isA<Success<PathEntity>>());
        expect(result.dataOrNull?.id, mockPathDTO.id);
        verify(() => mockDataSource.clearCache()).called(1);
        verify(() => mockDataSource.getPath()).called(1);
      });

      test('retorna Failure quando getPath falha após limpar cache', () async {
        when(() => mockDataSource.clearCache()).thenAnswer((_) async => {});
        when(() => mockDataSource.getPath()).thenAnswer(
          (_) async => Failure('Erro ao carregar após reset'),
        );

        final result = await repository.resetPath();

        expect(result, isA<Failure<PathEntity>>());
        expect((result as Failure).message, 'Erro ao carregar após reset');
        verify(() => mockDataSource.clearCache()).called(1);
        verify(() => mockDataSource.getPath()).called(1);
      });

      test('chama clearCache antes de getPath', () async {
        final callOrder = <String>[];

        when(() => mockDataSource.clearCache()).thenAnswer((_) async {
          callOrder.add('clearCache');
        });
        when(() => mockDataSource.getPath()).thenAnswer((_) async {
          callOrder.add('getPath');
          return Success(mockPathDTO);
        });

        await repository.resetPath();

        expect(callOrder, ['clearCache', 'getPath']);
      });
    });
  });
}
