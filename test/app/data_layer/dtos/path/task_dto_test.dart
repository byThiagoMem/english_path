import 'package:flutter_test/flutter_test.dart';
import 'package:mini_fluency/app/data_layer/dtos/path/task_dto.dart';
import 'package:mini_fluency/app/domain_layer/entities/path/task_entity.dart';

void main() {
  group('TaskDTO -', () {
    group('fromJson', () {
      test('converte JSON válido para TaskDTO', () {
        final json = {
          'id': 'task1',
          'title': 'Test Task',
          'type': 'listen_repeat',
          'estimatedSeconds': 120,
          'isCompleted': true,
        };

        final task = TaskDTO.fromJson(json);

        expect(task.id, 'task1');
        expect(task.title, 'Test Task');
        expect(task.type, TaskType.listenRepeat);
        expect(task.estimatedSeconds, 120);
        expect(task.isCompleted, true);
      });

      test('usa valores padrão quando campos são nulos', () {
        final json = {
          'type': 'multiple_choice',
        };

        final task = TaskDTO.fromJson(json);

        expect(task.id, '');
        expect(task.title, '');
        expect(task.type, TaskType.multipleChoice);
        expect(task.estimatedSeconds, 0);
        expect(task.isCompleted, false);
      });

      test('converte type snake_case corretamente', () {
        final json = {
          'id': 'task1',
          'title': 'Test',
          'type': 'multiple_choice',
          'estimatedSeconds': 60,
        };

        final task = TaskDTO.fromJson(json);

        expect(task.type, TaskType.multipleChoice);
      });
    });

    group('toJson', () {
      test('converte TaskDTO para JSON', () {
        final task = TaskDTO(
          id: 'task1',
          title: 'Test Task',
          type: TaskType.listenRepeat,
          estimatedSeconds: 120,
          isCompleted: true,
        );

        final json = task.toJson();

        expect(json['id'], 'task1');
        expect(json['title'], 'Test Task');
        expect(json['type'], 'listen_repeat');
        expect(json['estimatedSeconds'], 120);
        expect(json['isCompleted'], true);
      });

      test('converte camelCase para snake_case no type', () {
        final task = TaskDTO(
          id: 'task1',
          title: 'Test',
          type: TaskType.multipleChoice,
          estimatedSeconds: 60,
        );

        final json = task.toJson();

        expect(json['type'], 'multiple_choice');
      });
    });

    group('toDTO extension', () {
      test('converte TaskEntity para TaskDTO', () {
        final entity = TaskEntity(
          id: 'task1',
          title: 'Test Task',
          type: TaskType.fillInTheBlanks,
          estimatedSeconds: 180,
          isCompleted: false,
        );

        final dto = entity.toDTO;

        expect(dto.id, entity.id);
        expect(dto.title, entity.title);
        expect(dto.type, entity.type);
        expect(dto.estimatedSeconds, entity.estimatedSeconds);
        expect(dto.isCompleted, entity.isCompleted);
      });
    });
  });
}
