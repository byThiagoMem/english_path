import 'package:flutter/material.dart';

import '../../../domain_layer/domain_layer.dart';
import '../../../infra/infra.dart';

class TaskCardPage extends StatefulWidget {
  final TaskEntity task;
  final int taskNumber;
  final VoidCallback onComplete;

  const TaskCardPage({
    super.key,
    required this.task,
    required this.taskNumber,
    required this.onComplete,
  });

  @override
  State<TaskCardPage> createState() => _TaskCardPageState();
}

class _TaskCardPageState extends State<TaskCardPage> {
  double _sliderValue = 0.0;

  void _onSliderChanged(double value) {
    setState(() => _sliderValue = value);

    if (value >= 1.0 && !widget.task.isCompleted) {
      widget.onComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      child: Card(
        elevation: 8,
        shadowColor: Colors.black.withValues(alpha: 0.3),
        color: widget.task.isCompleted ? Colors.green[50] : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.task.title,
                          style: AppTextStyles.bodyMedium(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _taskTypeColor(widget.task.type)
                                    .withValues(alpha: 0.8),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                widget.task.type.label,
                                style: AppTextStyles.bodyXSmall(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Icon(
                              Icons.access_time,
                              size: 14,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${widget.task.estimatedSeconds}s',
                              style: AppTextStyles.bodyXSmall(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  widget.task.isCompleted
                      ? const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 32,
                        )
                      : CircleAvatar(
                          backgroundColor: Colors.grey[200],
                          radius: 18,
                          child: Text(
                            '${widget.taskNumber}',
                            style: AppTextStyles.bodyXSmall(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                ],
              ),
              const Spacer(),
              widget.task.isCompleted
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Tarefa concluída!',
                            style: AppTextStyles.bodyMedium(
                              color: Colors.green.shade800,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.swipe,
                              size: 20,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Deslize para concluir',
                              style: AppTextStyles.bodySmall(
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: Colors.deepPurple.shade900,
                            inactiveTrackColor: Colors.grey[300],
                            thumbColor: Colors.deepPurple.shade900,
                            overlayColor: Colors.deepPurple.shade900.withValues(
                              alpha: 0.2,
                            ),
                            thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 12,
                            ),
                            trackHeight: 8,
                          ),
                          child: Slider(
                            value: _sliderValue,
                            onChanged: _onSliderChanged,
                            min: 0.0,
                            max: 1.0,
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Color _taskTypeColor(TaskType type) {
    return switch (type) {
      TaskType.listenRepeat => Colors.purple,
      TaskType.multipleChoice => Colors.blue,
      TaskType.fillInTheBlanks => Colors.orange,
      TaskType.ordering => Colors.teal,
      TaskType.rolePlay => Colors.pink,
    };
  }
}
