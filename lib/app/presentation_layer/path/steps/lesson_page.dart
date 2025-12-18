import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain_layer/domain_layer.dart';
import '../../../infra/infra.dart';
import '../components/lesson_header.dart';
import '../components/task_card_page.dart';
import '../cubit/path_cubit.dart';
import '../cubit/path_state.dart';

class LessonPage extends StatefulWidget {
  final LessonEntity lesson;

  const LessonPage({
    super.key,
    required this.lesson,
  });

  @override
  State<LessonPage> createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> {
  late final PathCubit _cubit;

  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _cubit = Instance.get();

    _initializePage();
  }

  void _initializePage() {
    final firstPendingIndex = widget.lesson.tasks.indexWhere(
      (task) => !task.isCompleted,
    );

    final initialPage = firstPendingIndex != -1 ? firstPendingIndex : 0;

    _pageController = PageController(initialPage: initialPage);
  }

  void _onTaskComplete({
    required String lessonId,
    required String taskId,
    required List<TaskEntity> allTasks,
    required int currentIndex,
  }) {
    _cubit.updateTaskCompletion(
      lessonId: lessonId,
      taskId: taskId,
      isCompleted: true,
    );

    Future.delayed(const Duration(milliseconds: 500), () {
      final nextPendingIndex = allTasks.indexWhere(
        (task) => !task.isCompleted && task.id != taskId,
      );

      if (nextPendingIndex != -1 && _pageController.hasClients) {
        _pageController.animateToPage(
          nextPendingIndex,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PathCubit>.value(
      value: _cubit,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text(
            widget.lesson.title,
            style: AppTextStyles.bodyLarge(color: Colors.white),
          ),
        ),
        body: BlocBuilder<PathCubit, PathState>(
          builder: (context, state) {
            return DisplayHandler(
              isLoading: state.state is LoadingState,
              loading: const Center(child: CircularProgressIndicator()),
              isFailure: state.state is FailureState,
              failure: FailureResultCard(
                message: state.state.message,
                onReload: _cubit.loadPath,
              ),
              content: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.deepPurple.shade900,
                      Colors.deepPurple.shade500,
                      Colors.indigo.shade200,
                    ],
                  ),
                ),
                child: Builder(
                  builder: (context) {
                    final currentLesson = state.path.lessons
                        .firstWhere((l) => l.id == widget.lesson.id);

                    final completedTasks = currentLesson.tasks
                        .where((task) => task.isCompleted)
                        .length;

                    final totalTasks = currentLesson.tasks.length;

                    final progress =
                        totalTasks > 0 ? completedTasks / totalTasks : 0.0;

                    return SafeArea(
                      child: Column(
                        children: [
                          LessonHeader(
                            lesson: currentLesson,
                            completedTasks: completedTasks,
                            totalTasks: totalTasks,
                          ),
                          LinearProgressIndicator(
                            value: progress,
                            minHeight: 10,
                            backgroundColor:
                                Colors.white.withValues(alpha: 0.3),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              _getProgressColor(progress),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 20.0),
                              child: PageView.builder(
                                controller: _pageController,
                                itemCount: currentLesson.tasks.length,
                                itemBuilder: (context, index) {
                                  final task = currentLesson.tasks[index];
                                  final taskNumber = index + 1;

                                  return TaskCardPage(
                                    task: task,
                                    taskNumber: taskNumber,
                                    onComplete: () => _onTaskComplete(
                                      lessonId: currentLesson.id,
                                      taskId: task.id,
                                      allTasks: currentLesson.tasks,
                                      currentIndex: index,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
        bottomNavigationBar: BlocBuilder<PathCubit, PathState>(
          builder: (_, state) {
            final currentLesson =
                state.path.lessons.firstWhere((l) => l.id == widget.lesson.id);

            final allTasksCompleted =
                currentLesson.tasks.every((task) => task.isCompleted);

            if (allTasksCompleted && currentLesson.tasks.isNotEmpty) {
              return Container(
                padding: const EdgeInsets.all(16).copyWith(
                  bottom: MediaQuery.of(context).viewPadding.bottom + 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  border: Border(
                    top: BorderSide(color: Colors.green[200]!),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.celebration,
                      color: Colors.green,
                      size: 32,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Parabéns!',
                            style: AppTextStyles.bodyMedium(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          Text(
                            '''Você completou todas as tarefas! +${currentLesson.xp} XP''',
                            style: AppTextStyles.bodySmall(
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Color _getProgressColor(double progress) {
    if (progress >= 1.0) return Colors.green;
    if (progress >= 0.5) return Colors.blue;
    return Colors.orange;
  }
}
