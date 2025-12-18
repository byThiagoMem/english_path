import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../infra/infra.dart';
import 'components/lesson_bottom_sheet.dart';
import 'cubit/path_cubit.dart';
import 'cubit/path_state.dart';

class PathPage extends StatefulWidget {
  const PathPage({super.key});

  @override
  State<PathPage> createState() => _PathPageState();
}

class _PathPageState extends State<PathPage> {
  late final PathCubit _pathCubit;

  @override
  void initState() {
    super.initState();

    _pathCubit = Instance.get()..loadPath();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PathCubit>.value(
      value: _pathCubit,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          actions: [
            BlocBuilder<PathCubit, PathState>(
              builder: (_, event) {
                return Visibility(
                  visible: event.state is! FailureState,
                  child: IconButton(
                    icon: const Icon(Icons.refresh_rounded),
                    tooltip: 'Resetar progresso',
                    onPressed: () => _showResetDialog(context),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white.withValues(alpha: .9),
                      foregroundColor: Colors.deepPurple,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(width: 16),
          ],
        ),
        body: BlocBuilder<PathCubit, PathState>(
          builder: (_, event) {
            final path = event.path;

            return Stack(
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.deepPurple.shade900,
                        Colors.deepPurple.shade700,
                        Colors.indigo.shade600,
                      ],
                    ),
                  ),
                  child: DisplayHandler(
                    isLoading: event.state is LoadPathLoadingState,
                    loading: Center(
                      child: const CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                    isFailure: event.state is LoadPathFailureState,
                    failure: FailureResultCard(
                      message: event.state.message,
                      onReload: _pathCubit.loadPath,
                    ),
                    content: ListView.separated(
                      reverse: true,
                      itemCount: path.lessons.length,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 70,
                      ).copyWith(top: 150),
                      itemBuilder: (_, index) {
                        final lesson = path.lessons[index];

                        return LessonNode(
                          lesson: lesson,
                          onTap: () => LessonBottomSheet.show(
                            context,
                            lesson,
                            onRetry: () {
                              _pathCubit.resetLessonTasks(
                                lessonId: lesson.id,
                              );
                            },
                          ),
                        );
                      },
                      separatorBuilder: (_, index) {
                        return Visibility(
                          visible: index < path.lessons.length - 1,
                          child: LessonConnector(
                            currentLesson: path.lessons[index + 1],
                            nextLesson: path.lessons[index],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Visibility(
                  visible: path.name.isNotEmpty,
                  child: Positioned(
                    top: 65,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.indigo.shade600,
                            Colors.deepPurple.shade700,
                            Colors.deepPurple.shade900,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: .15),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.route_rounded,
                            size: 20,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            path.name,
                            style: AppTextStyles.bodyMedium(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'Resetar Progresso',
          style: AppTextStyles.bodyMedium(),
        ),
        content: Text(
          'Deseja resetar todo o progresso? Esta ação não pode ser desfeita.',
          style: AppTextStyles.bodySmall(
            fontWeight: FontWeight.normal,
          ),
        ),
        actions: [
          TextButton(
            onPressed: Navigate.pop,
            child: Text(
              'Cancelar',
              style: AppTextStyles.bodyMedium(),
            ),
          ),
          FilledButton(
            onPressed: () {
              Navigate.pop();
              _pathCubit.resetPath();
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red[500],
            ),
            child: Text(
              'Resetar',
              style: AppTextStyles.bodyMedium(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
