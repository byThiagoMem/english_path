import 'package:flutter_test/flutter_test.dart';
import 'package:mini_fluency/app/data_layer/dtos/path/lesson_dto.dart';
import 'package:mini_fluency/app/domain_layer/entities/path/lesson_entity.dart';
import 'package:mini_fluency/app/domain_layer/entities/path/task_entity.dart';

void main() {
  group('LessonDTO -', () {
    group('fromJson', () {
      test('converte JSON válido para LessonDTO', () {
        final json = {
          'id': 'lesson1',
          'title': 'Lesson 1',
          'position': 1,
          'status': 'current',
          'xp': 100,
          'estimatedMinutes': 15,
          'tasks': [
            {
              'id': 'task1',
              'title': 'Task 1',
              'type': 'listen_repeat',
              'estimatedSeconds': 60,
              'isCompleted': false,
            }
          ],
        };

        final lesson = LessonDTO.fromJson(json);

        expect(lesson.id, 'lesson1');
        expect(lesson.title, 'Lesson 1');
        expect(lesson.position, 1);
        expect(lesson.status, LessonStatus.current);
        expect(lesson.xp, 100);
        expect(lesson.estimatedMinutes, 15);
        expect(lesson.tasks.length, 1);
        expect(lesson.tasks.first.id, 'task1');
      });

      test('usa valores padrão quando campos são nulos', () {
        final json = <String, dynamic>{};

        final lesson = LessonDTO.fromJson(json);

        expect(lesson.id, '');
        expect(lesson.title, '');
        expect(lesson.position, 0);
        expect(lesson.status, LessonStatus.locked);
        expect(lesson.xp, 0);
        expect(lesson.estimatedMinutes, 0);
        expect(lesson.tasks, isEmpty);
      });

      test('converte status string para LessonStatus', () {
        final json = {
          'id': 'lesson1',
          'title': 'Test',
          'position': 1,
          'status': 'completed',
          'xp': 100,
          'estimatedMinutes': 10,
        };

        final lesson = LessonDTO.fromJson(json);

        expect(lesson.status, LessonStatus.completed);
      });
    });

    group('toJson', () {
      test('converte LessonDTO para JSON', () {
        final lesson = LessonDTO(
          id: 'lesson1',
          title: 'Lesson 1',
          position: 1,
          status: LessonStatus.current,
          xp: 100,
          estimatedMinutes: 15,
          tasks: [
            TaskEntity(
              id: 'task1',
              title: 'Task 1',
              type: TaskType.listenRepeat,
              estimatedSeconds: 60,
              isCompleted: false,
            ),
          ],
        );

        final json = lesson.toJson();

        expect(json['id'], 'lesson1');
        expect(json['title'], 'Lesson 1');
        expect(json['position'], 1);
        expect(json['status'], 'current');
        expect(json['xp'], 100);
        expect(json['estimatedMinutes'], 15);
        expect(json['tasks'], isA<List>());
        expect((json['tasks'] as List).length, 1);
      });

      test('converte LessonStatus para string', () {
        final lesson = LessonDTO(
          id: 'lesson1',
          title: 'Test',
          position: 1,
          status: LessonStatus.locked,
          xp: 100,
          estimatedMinutes: 10,
          tasks: [],
        );

        final json = lesson.toJson();

        expect(json['status'], 'locked');
      });
    });

    group('toDTO extension', () {
      test('converte LessonEntity para LessonDTO', () {
        final entity = LessonEntity(
          id: 'lesson1',
          title: 'Lesson 1',
          position: 1,
          status: LessonStatus.current,
          xp: 100,
          estimatedMinutes: 15,
          tasks: [],
        );

        final dto = entity.toDTO;

        expect(dto.id, entity.id);
        expect(dto.title, entity.title);
        expect(dto.position, entity.position);
        expect(dto.status, entity.status);
        expect(dto.xp, entity.xp);
        expect(dto.estimatedMinutes, entity.estimatedMinutes);
        expect(dto.tasks, entity.tasks);
      });
    });
  });
}
