import 'package:flutter_modular/flutter_modular.dart';

import '../../data_layer/data_layer.dart';
import '../../domain_layer/domain_layer.dart';
import '../app_module.dart';
import 'cubit/path_cubit.dart';
import 'path_page.dart';
import 'steps/lesson_page.dart';

class PathModule extends Module {
  @override
  void binds(Injector i) {
    i
      ..addLazySingleton(PathDataSource.new)
      ..addLazySingleton<IPathRepository>(PathRepository.new)
      ..addLazySingleton(GetPathUseCase.new)
      ..addLazySingleton(SavePathUseCase.new)
      ..addLazySingleton(ResetPathUseCase.new)
      ..addLazySingleton(PathCubit.new);
  }

  @override
  void routes(RouteManager r) {
    r
      ..child(
        Modular.initialRoute,
        child: (_) => const PathPage(),
        transition: TransitionType.fadeIn,
        duration: const Duration(milliseconds: 1000),
      )
      ..child(
        '/lesson',
        child: (context) => LessonPage(lesson: r.args.data),
        transition: TransitionType.downToUp,
        duration: const Duration(milliseconds: 700),
      );
  }

  @override
  List<Module> get imports => [
        AppModule(),
      ];
}
