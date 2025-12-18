import 'package:flutter/material.dart';

import '../../domain_layer/domain_layer.dart';

/// Widget that displays a gradient connector line between two lessons.
///
/// The gradient color is based on the status of each lesson:
/// - Green: Completed lesson
/// - Blue: Current lesson
/// - Transparent white: Locked lesson
///
/// Usage example:
/// ```dart
/// LessonConnector(
///   currentLesson: lesson1,
///   nextLesson: lesson2,
/// )
/// ```
class LessonConnector extends StatelessWidget {
  /// The current (top) lesson to be connected
  final LessonEntity currentLesson;

  /// The next (bottom) lesson to be connected
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
