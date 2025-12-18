import 'package:flutter/material.dart';

import '../../../domain_layer/domain_layer.dart';
import '../../../infra/infra.dart';

class LessonHeader extends StatelessWidget {
  final LessonEntity lesson;
  final int completedTasks;
  final int totalTasks;

  const LessonHeader({
    super.key,
    required this.lesson,
    required this.completedTasks,
    required this.totalTasks,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _statusIcon,
                color: Colors.white,
                size: 32,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Missão ${lesson.position}',
                      style: AppTextStyles.bodySmall(
                        color: Colors.white70,
                      ),
                    ),
                    Text(
                      '$completedTasks de $totalTasks tarefas concluídas',
                      style: AppTextStyles.bodyMedium(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.timer,
                        size: 16,
                        color: Colors.white70,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${lesson.estimatedMinutes} min',
                        style: AppTextStyles.bodySmall(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.stars,
                        size: 16,
                        color: Colors.white70,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${lesson.xp} XP',
                        style: AppTextStyles.bodySmall(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData get _statusIcon {
    return switch (lesson.status) {
      LessonStatus.locked => Icons.lock,
      LessonStatus.current => Icons.play_circle_fill,
      LessonStatus.completed => Icons.check_circle,
    };
  }
}
