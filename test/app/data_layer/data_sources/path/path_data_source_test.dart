import 'package:flutter_test/flutter_test.dart';
import 'package:mini_fluency/app/data_layer/data_sources/path/path_data_source.dart';
import 'package:mini_fluency/app/data_layer/dtos/path/path_dto.dart';
import 'package:mini_fluency/app/infra/infra.dart';
import 'package:mocktail/mocktail.dart';

class MockLocalStorage extends Mock implements ILocalStorage {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late PathDataSource dataSource;
  late MockLocalStorage mockLocalStorage;

  setUp(() {
    mockLocalStorage = MockLocalStorage();
    dataSource = PathDataSource(localStorage: mockLocalStorage);
  });

  group('PathDataSource -', () {
    group('getPath', () {
      test('retorna PathDTO do cache quando disponível', () async {
        final cachedData = {
          'path': {
            'id': 'path1',
            'name': 'Cached Path',
            'description': 'From cache',
            'lessons': [],
          },
        };

        when(() => mockLocalStorage.getStorageData(LocalStorageKeys.path))
            .thenAnswer((_) async => cachedData);

        final result = await dataSource.getPath();

        expect(result.isSuccess, true);
        final pathDto = result.dataOrNull;
        expect(pathDto!.id, 'path1');
        expect(pathDto.name, 'Cached Path');
        verify(() => mockLocalStorage.getStorageData(LocalStorageKeys.path))
            .called(1);
      });

      test('retorna Failure quando ocorre Exception', () async {
        when(() => mockLocalStorage.getStorageData(LocalStorageKeys.path))
            .thenThrow(Exception('Storage error'));

        final result = await dataSource.getPath();

        expect(result.isSuccess, false);
        expect(result.isFailure, true);
      });

      test('retorna Failure quando ocorre erro desconhecido', () async {
        when(() => mockLocalStorage.getStorageData(LocalStorageKeys.path))
            .thenThrow('Unknown error');

        final result = await dataSource.getPath();

        expect(result.isSuccess, false);
        expect(result.errorOrNull, 'Erro desconhecido ao carregar trilha');
      });
    });

    group('savePath', () {
      test('salva PathDTO com sucesso', () async {
        final pathDto = PathDTO(
          id: 'path1',
          name: 'Test Path',
          description: 'Test description',
          lessons: [],
        );

        when(
          () => mockLocalStorage.setStorageData(
            LocalStorageKeys.path,
            any(),
          ),
        ).thenAnswer((_) async {});

        final result = await dataSource.savePath(pathDto);

        expect(result.isSuccess, true);
        expect(result.dataOrNull, pathDto);
        verify(
          () => mockLocalStorage.setStorageData(
            LocalStorageKeys.path,
            {
              'path': pathDto.toJson(),
            },
          ),
        ).called(1);
      });

      test('retorna Failure quando ocorre Exception ao salvar', () async {
        final pathDto = PathDTO(
          id: 'path1',
          name: 'Test Path',
          description: 'Test',
          lessons: [],
        );

        when(
          () => mockLocalStorage.setStorageData(
            LocalStorageKeys.path,
            any(),
          ),
        ).thenThrow(
          Exception('Save error'),
        );

        final result = await dataSource.savePath(pathDto);

        expect(result.isSuccess, false);
        expect(result.isFailure, true);
      });

      test('retorna Failure quando ocorre erro desconhecido ao salvar',
          () async {
        final pathDto = PathDTO(
          id: 'path1',
          name: 'Test Path',
          description: 'Test',
          lessons: [],
        );

        when(
          () => mockLocalStorage.setStorageData(
            LocalStorageKeys.path,
            any(),
          ),
        ).thenThrow('Unknown error');

        final result = await dataSource.savePath(pathDto);

        expect(result.isSuccess, false);
        expect(result.errorOrNull, 'Erro desconhecido ao salvar trilha');
      });
    });

    group('clearCache', () {
      test('limpa cache com sucesso', () async {
        when(() => mockLocalStorage.removeStorage(LocalStorageKeys.path))
            .thenAnswer((_) async {});

        await dataSource.clearCache();

        verify(() => mockLocalStorage.removeStorage(LocalStorageKeys.path))
            .called(1);
      });
    });
  });
}
