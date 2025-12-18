import 'package:flutter/material.dart';

import '../../domain_layer/domain_layer.dart';

class LessonConnector extends StatelessWidget {
  final LessonEntity currentLesson;
  final LessonEntity nextLesson;

  const LessonConnector({
    super.key,
    required this.currentLesson,
    required this.nextLesson,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 4,
        height: 60,
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              _statusColor(currentLesson.status),
              _statusColor(nextLesson.status),
            ],
          ),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Color _statusColor(LessonStatus status) {
    switch (status) {
      case LessonStatus.completed:
        return Colors.green;
      case LessonStatus.current:
        return Colors.blue;
      case LessonStatus.locked:
        return Colors.white.withValues(alpha: 0.3);
    }
  }
}
