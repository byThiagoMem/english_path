import 'package:flutter/material.dart';

import '../../../domain_layer/domain_layer.dart';
import '../../../infra/infra.dart';

class LessonBottomSheet extends StatelessWidget {
  final LessonEntity lesson;
  final VoidCallback? onRetry;

  const LessonBottomSheet({
    super.key,
    required this.lesson,
    this.onRetry,
  });

  static Future<void> show(
    BuildContext context,
    LessonEntity lesson, {
    VoidCallback? onRetry,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => LessonBottomSheet(
        lesson: lesson,
        onRetry: onRetry,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final canNavigate = lesson.status != LessonStatus.locked;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: _statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _statusColor.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Text(
              _statusText,
              style: AppTextStyles.bodyXSmall(
                fontWeight: FontWeight.w500,
                color: _statusColor,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            lesson.title,
            style: AppTextStyles.heading22(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 12,
            runSpacing: 12,
            children: [
              _InfoChip(
                icon: Icons.timer_outlined,
                label: '${lesson.estimatedMinutes} min',
              ),
              _InfoChip(
                icon: Icons.stars,
                label: '${lesson.xp} XP',
              ),
              _InfoChip(
                icon: Icons.task_alt,
                label: '${lesson.tasks.length} tarefas',
              ),
            ],
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            text: _buttonText,
            backgroundColor: canNavigate ? _statusColor : Colors.grey,
            onPressed: canNavigate
                ? () {
                    if (lesson.status == LessonStatus.completed) {
                      onRetry?.call();
                    }
                    Navigate.popAndPushNamed(
                      AppRoutes.lesson,
                      arguments: lesson,
                    );
                  }
                : null,
            icon: canNavigate
                ? (lesson.status == LessonStatus.completed
                    ? Icons.refresh
                    : Icons.play_arrow)
                : Icons.lock,
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  Color get _statusColor => switch (lesson.status) {
        LessonStatus.completed => Colors.green,
        LessonStatus.current => Colors.blue,
        LessonStatus.locked => Colors.grey,
      };

  String get _statusText {
    return switch (lesson.status) {
      LessonStatus.completed => 'Missão concluída',
      LessonStatus.current => 'Próxima missão',
      LessonStatus.locked => 'Missão bloqueada',
    };
  }

  String get _buttonText {
    return switch (lesson.status) {
      LessonStatus.completed => 'Refazer missão',
      LessonStatus.current => 'Iniciar missão',
      LessonStatus.locked => 'Missão bloqueada',
    };
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.grey[700]),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTextStyles.bodyXSmall(
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
