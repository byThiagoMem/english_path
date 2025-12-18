import 'package:flutter/material.dart';

import '../../domain_layer/domain_layer.dart';
import '../core/core.dart';

/// Widget that represents a lesson node in the learning path map.
///
/// Displays lesson information (title, XP, estimated time)
/// with colors and icons
/// based on status. Lessons with 'current' status have a pulse animation.
///
/// Colors by status:
/// - Green: Completed lesson
/// - Blue: Current lesson (with animation)
/// - Gray: Locked lesson
///
/// Usage example:
/// ```dart
/// LessonNode(
///   lesson: lessonEntity,
///   onTap: () {
///     // Navigate to lesson screen
///     Navigator.push(...);
///   },
/// )
/// ```
class LessonNode extends StatefulWidget {
  /// The lesson entity with all information (title, status, XP, etc.)
  final LessonEntity lesson;

  /// Callback executed when user taps on the lesson node
  final VoidCallback onTap;

  const LessonNode({
    super.key,
    required this.lesson,
    required this.onTap,
  });

  @override
  State<LessonNode> createState() => _LessonNodeState();
}

class _LessonNodeState extends State<LessonNode>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;

  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    if (widget.lesson.status == LessonStatus.current) {
      _pulseController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1500),
      )..repeat(reverse: true);

      _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
        CurvedAnimation(
          parent: _pulseController,
          curve: Curves.easeInOut,
        ),
      );
    } else {
      _pulseController = AnimationController(vsync: this);
      _pulseAnimation = AlwaysStoppedAnimation(1.0);
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();

    super.dispose();
  }

  Color get _statusColor => switch (widget.lesson.status) {
        LessonStatus.completed => Colors.green,
        LessonStatus.current => Colors.blue,
        LessonStatus.locked => Colors.grey,
      };

  IconData get _statusIcon => switch (widget.lesson.status) {
        LessonStatus.completed => Icons.check_circle,
        LessonStatus.current => Icons.play_circle_filled,
        LessonStatus.locked => Icons.lock,
      };

  @override
  Widget build(BuildContext context) {
    final isCurrent = widget.lesson.status == LessonStatus.current;

    return GestureDetector(
      onTap: widget.onTap,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          if (isCurrent)
            Positioned(
              top: -5,
              child: AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (_, __) {
                  return Transform.scale(
                    scale: _pulseAnimation.value,
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Colors.grey.withValues(alpha: 0.3),
                            Colors.grey.withValues(alpha: 0.3),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: _statusColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: _statusColor.withValues(alpha: 0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(
                    color: Colors.white,
                    width: 4,
                  ),
                ),
                child: Icon(
                  _statusIcon,
                  color: Colors.white,
                  size: 36,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: _statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _statusColor.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  '${widget.lesson.position} • ${widget.lesson.title}',
                  style: AppTextStyles.bodyXSmall(
                    fontWeight: FontWeight.bold,
                    color: _statusColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
