import 'package:flutter_test/flutter_test.dart';
import 'package:mini_fluency/app/domain_layer/domain_layer.dart';
import 'package:mini_fluency/app/infra/infra.dart';
import 'package:mocktail/mocktail.dart';

class MockPathRepository extends Mock implements IPathRepository {}

void main() {
  late ResetPathUseCase useCase;
  late MockPathRepository mockRepository;

  final mockPath = PathEntity(
    id: '1',
    name: 'Test Path',
    description: 'Test Description',
    lessons: [],
  );

  setUp(() {
    mockRepository = MockPathRepository();
    useCase = ResetPathUseCase(repository: mockRepository);
  });

  group('ResetPathUseCase -', () {
    test('retorna Success quando repository reseta com sucesso', () async {
      when(() => mockRepository.resetPath()).thenAnswer(
        (_) async => Success(mockPath),
      );

      final result = await useCase();

      expect(result, isA<Success<PathEntity>>());
      expect(result.dataOrNull, mockPath);
      verify(() => mockRepository.resetPath()).called(1);
    });

    test('retorna Failure quando repository retorna falha', () async {
      when(() => mockRepository.resetPath()).thenAnswer(
        (_) async => Failure('Erro ao resetar'),
      );

      final result = await useCase();

      expect(result, isA<Failure<PathEntity>>());
      expect((result as Failure).message, 'Erro ao resetar');
      verify(() => mockRepository.resetPath()).called(1);
    });
  });
}
