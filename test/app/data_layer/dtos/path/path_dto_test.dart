import 'package:flutter_test/flutter_test.dart';
import 'package:mini_fluency/app/data_layer/dtos/path/path_dto.dart';
import 'package:mini_fluency/app/domain_layer/entities/path/lesson_entity.dart';
import 'package:mini_fluency/app/domain_layer/entities/path/path_entity.dart';

void main() {
  group('PathDTO -', () {
    group('fromJson', () {
      test('converte JSON válido para PathDTO', () {
        final json = {
          'id': 'path1',
          'name': 'English Path',
          'description': 'Learn English',
          'lessons': [
            {
              'id': 'lesson1',
              'title': 'Lesson 1',
              'position': 1,
              'status': 'current',
              'xp': 100,
              'estimatedMinutes': 15,
              'tasks': [],
            }
          ],
        };

        final path = PathDTO.fromJson(json);

        expect(path.id, 'path1');
        expect(path.name, 'English Path');
        expect(path.description, 'Learn English');
        expect(path.lessons.length, 1);
        expect(path.lessons.first.id, 'lesson1');
      });

      test('usa valores padrão quando campos são nulos', () {
        final json = <String, dynamic>{};

        final path = PathDTO.fromJson(json);

        expect(path.id, '');
        expect(path.name, '');
        expect(path.description, '');
        expect(path.lessons, isEmpty);
      });

      test('converte lista de lessons corretamente', () {
        final json = {
          'id': 'path1',
          'name': 'Test Path',
          'description': 'Description',
          'lessons': [
            {
              'id': 'lesson1',
              'title': 'Lesson 1',
              'position': 1,
              'status': 'current',
              'xp': 100,
              'estimatedMinutes': 10,
              'tasks': [],
            },
            {
              'id': 'lesson2',
              'title': 'Lesson 2',
              'position': 2,
              'status': 'locked',
              'xp': 150,
              'estimatedMinutes': 15,
              'tasks': [],
            },
          ],
        };

        final path = PathDTO.fromJson(json);

        expect(path.lessons.length, 2);
        expect(path.lessons[0].id, 'lesson1');
        expect(path.lessons[1].id, 'lesson2');
      });
    });

    group('toJson', () {
      test('converte PathDTO para JSON', () {
        final path = PathDTO(
          id: 'path1',
          name: 'English Path',
          description: 'Learn English',
          lessons: [
            LessonEntity(
              id: 'lesson1',
              title: 'Lesson 1',
              position: 1,
              status: LessonStatus.current,
              xp: 100,
              estimatedMinutes: 15,
              tasks: [],
            ),
          ],
        );

        final json = path.toJson();

        expect(json['id'], 'path1');
        expect(json['name'], 'English Path');
        expect(json['description'], 'Learn English');
        expect(json['lessons'], isA<List>());
        expect((json['lessons'] as List).length, 1);
      });

      test('converte lista de lessons para JSON', () {
        final path = PathDTO(
          id: 'path1',
          name: 'Test',
          description: 'Desc',
          lessons: [
            LessonEntity(
              id: 'lesson1',
              title: 'Lesson 1',
              position: 1,
              status: LessonStatus.current,
              xp: 100,
              estimatedMinutes: 10,
              tasks: [],
            ),
            LessonEntity(
              id: 'lesson2',
              title: 'Lesson 2',
              position: 2,
              status: LessonStatus.locked,
              xp: 150,
              estimatedMinutes: 15,
              tasks: [],
            ),
          ],
        );

        final json = path.toJson();
        final lessons = json['lessons'] as List;

        expect(lessons.length, 2);
        expect(lessons[0]['id'], 'lesson1');
        expect(lessons[1]['id'], 'lesson2');
      });
    });

    group('toDTO extension', () {
      test('converte PathEntity para PathDTO', () {
        final entity = PathEntity(
          id: 'path1',
          name: 'English Path',
          description: 'Learn English',
          lessons: [],
        );

        final dto = entity.toDTO;

        expect(dto.id, entity.id);
        expect(dto.name, entity.name);
        expect(dto.description, entity.description);
        expect(dto.lessons, entity.lessons);
      });
    });
  });
}
