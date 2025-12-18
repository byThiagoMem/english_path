import '../../../domain_layer/domain_layer.dart';
import 'lesson_dto.dart';

class PathDTO extends PathEntity {
  PathDTO({
    required super.id,
    required super.name,
    required super.description,
    required super.lessons,
  });

  factory PathDTO.fromJson(Map<String, dynamic> json) {
    return PathDTO(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      lessons: (json['lessons'] as List<dynamic>?)
              ?.map(
                (lesson) => LessonDTO.fromJson(lesson as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'lessons': lessons.map((lesson) => lesson.toDTO.toJson()).toList(),
    };
  }
}

extension PathDTOExtension on PathEntity {
  PathDTO get toDTO => PathDTO(
        id: id,
        name: name,
        description: description,
        lessons: lessons,
      );
}
