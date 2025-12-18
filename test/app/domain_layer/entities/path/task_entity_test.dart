import 'package:flutter_test/flutter_test.dart';
import 'package:mini_fluency/app/domain_layer/entities/path/task_entity.dart';

void main() {
  group('TaskType -', () {
    group('fromString', () {
      test('converte snake_case para TaskType correto', () {
        expect(
          TaskType.fromString('listen_repeat'),
          TaskType.listenRepeat,
        );
        expect(
          TaskType.fromString('multiple_choice'),
          TaskType.multipleChoice,
        );
        expect(
          TaskType.fromString('fill_in_the_blanks'),
          TaskType.fillInTheBlanks,
        );
        expect(
          TaskType.fromString('ordering'),
          TaskType.ordering,
        );
        expect(
          TaskType.fromString('role_play'),
          TaskType.rolePlay,
        );
      });

      test('retorna multipleChoice como padrão para valor inválido', () {
        expect(
          TaskType.fromString('invalid_type'),
          TaskType.multipleChoice,
        );
      });

      test('lida com strings vazias retornando padrão', () {
        expect(
          TaskType.fromString(''),
          TaskType.multipleChoice,
        );
      });
    });

    group('label', () {
      test('retorna label correto para cada tipo', () {
        expect(TaskType.listenRepeat.label, 'OUVIR E REPETIR');
        expect(TaskType.multipleChoice.label, 'MÚLTIPLA ESCOLHA');
        expect(TaskType.fillInTheBlanks.label, 'PREENCHER');
        expect(TaskType.ordering.label, 'ORDENAR');
        expect(TaskType.rolePlay.label, 'ROLE-PLAY');
      });
    });
  });
}
