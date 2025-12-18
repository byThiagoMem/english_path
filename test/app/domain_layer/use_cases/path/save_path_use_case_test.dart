import 'package:flutter_test/flutter_test.dart';
import 'package:mini_fluency/app/domain_layer/domain_layer.dart';
import 'package:mini_fluency/app/infra/infra.dart';
import 'package:mocktail/mocktail.dart';

class MockPathRepository extends Mock implements IPathRepository {}

void main() {
  late SavePathUseCase useCase;
  late MockPathRepository mockRepository;

  final mockPath = PathEntity(
    id: '1',
    name: 'Test Path',
    description: 'Test Description',
    lessons: [],
  );

  setUp(() {
    mockRepository = MockPathRepository();
    useCase = SavePathUseCase(repository: mockRepository);
  });

  setUpAll(() {
    registerFallbackValue(mockPath);
  });

  group('SavePathUseCase -', () {
    test('retorna Success quando repository salva com sucesso', () async {
      when(() => mockRepository.savePath(any())).thenAnswer(
        (_) async => Success(mockPath),
      );

      final result = await useCase(mockPath);

      expect(result, isA<Success<PathEntity>>());
      expect(result.dataOrNull, mockPath);
      verify(() => mockRepository.savePath(mockPath)).called(1);
    });

    test('retorna Failure quando repository retorna falha', () async {
      when(() => mockRepository.savePath(any())).thenAnswer(
        (_) async => Failure('Erro ao salvar'),
      );

      final result = await useCase(mockPath);

      expect(result, isA<Failure<PathEntity>>());
      expect((result as Failure).message, 'Erro ao salvar');
      verify(() => mockRepository.savePath(mockPath)).called(1);
    });

    test('passa o path correto para o repository', () async {
      when(() => mockRepository.savePath(any())).thenAnswer(
        (_) async => Success(mockPath),
      );

      await useCase(mockPath);

      final captured = verify(
        () => mockRepository.savePath(captureAny()),
      ).captured;

      expect(captured.first, mockPath);
    });
  });
}
