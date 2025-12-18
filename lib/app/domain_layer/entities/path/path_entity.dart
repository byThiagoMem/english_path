import 'lesson_entity.dart';

class PathEntity {
  final String id;
  final String name;
  final String description;
  final List<LessonEntity> lessons;

  PathEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.lessons,
  });

  const PathEntity.empty()
      : id = '',
        name = '',
        description = '',
        lessons = const [];

  PathEntity copyWith({
    String? id,
    String? name,
    String? description,
    List<LessonEntity>? lessons,
  }) {
    return PathEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      lessons: lessons ?? this.lessons,
    );
  }
}
