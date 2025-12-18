import 'dart:convert';

import 'package:flutter/services.dart';

import '../../../infra/infra.dart';
import '../../data_layer.dart';

class PathDataSource {
  final ILocalStorage _localStorage;

  PathDataSource({
    required ILocalStorage localStorage,
  }) : _localStorage = localStorage;

  /// Loads path data from cache or local JSON asset
  Future<Result<PathDTO>> getPath() async {
    try {
      // Try to load from cache first (persisted data with progress)
      final cachedData = await _localStorage.getStorageData(
        LocalStorageKeys.path,
      );

      if (cachedData != null) {
        final pathJson = cachedData['path'] as Map<String, dynamic>;
        final pathDto = PathDTO.fromJson(pathJson);
        return Success(pathDto);
      }

      // If no cache, load from assets (first time)
      final String jsonString = await rootBundle.loadString(
        'assets/data/path.json',
      );

      // Parse JSON
      final Map<String, dynamic> jsonData = jsonDecode(jsonString);

      // Get the path object from the root
      final pathJson = jsonData['path'] as Map<String, dynamic>;

      // Convert to DTO
      final pathDto = PathDTO.fromJson(pathJson);

      // Save to cache for next time
      await _localStorage.setStorageData(LocalStorageKeys.path, jsonData);

      return Success(pathDto);
    } on Exception catch (e) {
      return Failure('Erro ao carregar trilha do JSON', e);
    } catch (e) {
      return Failure('Erro desconhecido ao carregar trilha');
    }
  }

  /// Saves path data to local storage (SharedPreferences)
  Future<Result<PathDTO>> savePath(PathDTO pathDto) async {
    try {
      // Wrap path in the same structure as the JSON file
      final dataToSave = {
        'path': pathDto.toJson(),
      };

      // Save to SharedPreferences
      await _localStorage.setStorageData(LocalStorageKeys.path, dataToSave);

      return Success(pathDto);
    } on Exception catch (e) {
      return Failure('Erro ao salvar trilha', e);
    } catch (e) {
      return Failure('Erro desconhecido ao salvar trilha');
    }
  }

  /// Clears cached path data (useful for reset)
  Future<void> clearCache() async {
    await _localStorage.removeStorage(LocalStorageKeys.path);
  }
}
