import 'package:flutter_test/flutter_test.dart';
import 'package:mini_fluency/app/domain_layer/entities/path/lesson_entity.dart';

void main() {
  group('LessonStatus -', () {
    group('fromString', () {
      test('converte string para LessonStatus correto', () {
        expect(LessonStatus.fromString('locked'), LessonStatus.locked);
        expect(LessonStatus.fromString('current'), LessonStatus.current);
        expect(LessonStatus.fromString('completed'), LessonStatus.completed);
      });

      test('retorna locked como padrão para valor inválido', () {
        expect(
          LessonStatus.fromString('invalid_status'),
          LessonStatus.locked,
        );
      });

      test('lida com strings vazias retornando padrão', () {
        expect(
          LessonStatus.fromString(''),
          LessonStatus.locked,
        );
      });
    });
  });
}
