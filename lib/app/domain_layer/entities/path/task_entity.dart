class TaskEntity {
  final String id;
  final String title;
  final TaskType type;
  final int estimatedSeconds;
  final bool isCompleted;

  TaskEntity({
    required this.id,
    required this.title,
    required this.type,
    required this.estimatedSeconds,
    this.isCompleted = false,
  });

  TaskEntity copyWith({
    String? id,
    String? title,
    TaskType? type,
    int? estimatedSeconds,
    bool? isCompleted,
  }) {
    return TaskEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      estimatedSeconds: estimatedSeconds ?? this.estimatedSeconds,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

enum TaskType {
  listenRepeat('OUVIR E REPETIR'),
  multipleChoice('MÚLTIPLA ESCOLHA'),
  fillInTheBlanks('PREENCHER'),
  ordering('ORDENAR'),
  rolePlay('ROLE-PLAY');

  final String label;

  const TaskType(this.label);

  static TaskType fromString(String value) {
    final normalizedValue = value.replaceAllMapped(
      RegExp(r'_([a-z])'),
      (match) => match.group(1)!.toUpperCase(),
    );

    return TaskType.values.firstWhere(
      (type) => type.name == normalizedValue,
      orElse: () => TaskType.multipleChoice,
    );
  }
}
