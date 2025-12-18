import 'task_entity.dart';

class LessonEntity {
  final String id;
  final String title;
  final int position;
  final LessonStatus status;
  final int xp;
  final int estimatedMinutes;
  final List<TaskEntity> tasks;

  LessonEntity({
    required this.id,
    required this.title,
    required this.position,
    required this.status,
    required this.xp,
    required this.estimatedMinutes,
    required this.tasks,
  });

  LessonEntity copyWith({
    String? id,
    String? title,
    int? position,
    LessonStatus? status,
    int? xp,
    int? estimatedMinutes,
    List<TaskEntity>? tasks,
  }) {
    return LessonEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      position: position ?? this.position,
      status: status ?? this.status,
      xp: xp ?? this.xp,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      tasks: tasks ?? this.tasks,
    );
  }
}

enum LessonStatus {
  locked('Missão bloqueada'),
  current('Próxima missão'),
  completed('Missão concluída');

  final String label;

  const LessonStatus(this.label);

  static LessonStatus fromString(String value) {
    return LessonStatus.values.firstWhere(
      (status) => status.name == value,
      orElse: () => LessonStatus.locked,
    );
  }
}
