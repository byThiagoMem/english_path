import '../../../domain_layer/domain_layer.dart';

class TaskDTO extends TaskEntity {
  TaskDTO({
    required super.id,
    required super.title,
    required super.type,
    required super.estimatedSeconds,
    super.isCompleted,
  });

  factory TaskDTO.fromJson(Map<String, dynamic> json) {
    return TaskDTO(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      type: TaskType.fromString(json['type'] ?? TaskType.multipleChoice),
      estimatedSeconds: json['estimatedSeconds'] as int? ?? 0,
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    final typeString = type.name.replaceAllMapped(
      RegExp(r'[A-Z]'),
      (match) => '_${match.group(0)!.toLowerCase()}',
    );

    return {
      'id': id,
      'title': title,
      'type': typeString,
      'estimatedSeconds': estimatedSeconds,
      'isCompleted': isCompleted,
    };
  }
}

extension TaskDTOExtension on TaskEntity {
  TaskDTO get toDTO => TaskDTO(
        id: id,
        title: title,
        type: type,
        estimatedSeconds: estimatedSeconds,
        isCompleted: isCompleted,
      );
}
