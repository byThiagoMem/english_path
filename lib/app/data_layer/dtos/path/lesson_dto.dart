import '../../../domain_layer/domain_layer.dart';
import 'task_dto.dart';

class LessonDTO extends LessonEntity {
  LessonDTO({
    required super.id,
    required super.title,
    required super.position,
    required super.status,
    required super.xp,
    required super.estimatedMinutes,
    required super.tasks,
  });

  factory LessonDTO.fromJson(Map<String, dynamic> json) {
    return LessonDTO(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      position: json['position'] ?? 0,
      status: LessonStatus.fromString(json['status'] ?? 'locked'),
      xp: json['xp'] ?? 0,
      estimatedMinutes: json['estimatedMinutes'] ?? 0,
      tasks: (json['tasks'] as List<dynamic>?)
              ?.map((task) => TaskDTO.fromJson(task as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'position': position,
      'status': status.name,
      'xp': xp,
      'estimatedMinutes': estimatedMinutes,
      'tasks': tasks.map((task) => task.toDTO.toJson()).toList(),
    };
  }
}

extension LessonDTOExtension on LessonEntity {
  LessonDTO get toDTO => LessonDTO(
        id: id,
        title: title,
        position: position,
        status: status,
        xp: xp,
        estimatedMinutes: estimatedMinutes,
        tasks: tasks,
      );
}
