import 'package:flutter_test/flutter_test.dart';
import 'package:mini_fluency/app/domain_layer/domain_layer.dart';
import 'package:mini_fluency/app/infra/infra.dart';
import 'package:mocktail/mocktail.dart';

class MockPathRepository extends Mock implements IPathRepository {}

void main() {
  late GetPathUseCase useCase;
  late MockPathRepository mockRepository;

  final mockPath = PathEntity(
    id: '1',
    name: 'Test Path',
    description: 'Test Description',
    lessons: [],
  );

  setUp(() {
    mockRepository = MockPathRepository();
    useCase = GetPathUseCase(repository: mockRepository);
  });

  group('GetPathUseCase -', () {
    test('retorna Success quando repository retorna sucesso', () async {
      when(() => mockRepository.getPath()).thenAnswer(
        (_) async => Success(mockPath),
      );

      final result = await useCase();

      expect(result, isA<Success<PathEntity>>());
      expect(result.dataOrNull, mockPath);
      verify(() => mockRepository.getPath()).called(1);
    });

    test('retorna Failure quando repository retorna falha', () async {
      when(() => mockRepository.getPath()).thenAnswer(
        (_) async => Failure('Erro ao carregar'),
      );

      final result = await useCase();

      expect(result, isA<Failure<PathEntity>>());
      expect((result as Failure).message, 'Erro ao carregar');
      verify(() => mockRepository.getPath()).called(1);
    });
  });
}
