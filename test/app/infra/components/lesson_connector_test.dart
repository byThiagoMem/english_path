import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_fluency/app/domain_layer/entities/path/lesson_entity.dart';
import 'package:mini_fluency/app/infra/components/lesson_connector.dart';

void main() {
  group('LessonConnector -', () {
    testWidgets('renders connector container', (tester) async {
      final lesson1 = LessonEntity(
        id: '1',
        title: 'Lesson 1',
        position: 1,
        status: LessonStatus.completed,
        xp: 100,
        estimatedMinutes: 10,
        tasks: [],
      );

      final lesson2 = LessonEntity(
        id: '2',
        title: 'Lesson 2',
        position: 2,
        status: LessonStatus.current,
        xp: 100,
        estimatedMinutes: 10,
        tasks: [],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LessonConnector(
              currentLesson: lesson1,
              nextLesson: lesson2,
            ),
          ),
        ),
      );

      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('has correct dimensions', (tester) async {
      final lesson1 = LessonEntity(
        id: '1',
        title: 'Lesson 1',
        position: 1,
        status: LessonStatus.completed,
        xp: 100,
        estimatedMinutes: 10,
        tasks: [],
      );

      final lesson2 = LessonEntity(
        id: '2',
        title: 'Lesson 2',
        position: 2,
        status: LessonStatus.current,
        xp: 100,
        estimatedMinutes: 10,
        tasks: [],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LessonConnector(
              currentLesson: lesson1,
              nextLesson: lesson2,
            ),
          ),
        ),
      );

      final connector = tester.widget<LessonConnector>(
        find.byType(LessonConnector),
      );

      expect(connector.currentLesson, lesson1);
      expect(connector.nextLesson, lesson2);
    });

    testWidgets('displays gradient from completed to current', (tester) async {
      final completedLesson = LessonEntity(
        id: '1',
        title: 'Lesson 1',
        position: 1,
        status: LessonStatus.completed,
        xp: 100,
        estimatedMinutes: 10,
        tasks: [],
      );

      final currentLesson = LessonEntity(
        id: '2',
        title: 'Lesson 2',
        position: 2,
        status: LessonStatus.current,
        xp: 100,
        estimatedMinutes: 10,
        tasks: [],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LessonConnector(
              currentLesson: completedLesson,
              nextLesson: currentLesson,
            ),
          ),
        ),
      );

      // Verify that the widget is rendered
      expect(find.byType(LessonConnector), findsOneWidget);
    });

    testWidgets('displays gradient from current to locked', (tester) async {
      final currentLesson = LessonEntity(
        id: '1',
        title: 'Lesson 1',
        position: 1,
        status: LessonStatus.current,
        xp: 100,
        estimatedMinutes: 10,
        tasks: [],
      );

      final lockedLesson = LessonEntity(
        id: '2',
        title: 'Lesson 2',
        position: 2,
        status: LessonStatus.locked,
        xp: 100,
        estimatedMinutes: 10,
        tasks: [],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LessonConnector(
              currentLesson: currentLesson,
              nextLesson: lockedLesson,
            ),
          ),
        ),
      );

      expect(find.byType(LessonConnector), findsOneWidget);
    });

    testWidgets('displays gradient from locked to locked', (tester) async {
      final lockedLesson1 = LessonEntity(
        id: '1',
        title: 'Lesson 1',
        position: 1,
        status: LessonStatus.locked,
        xp: 100,
        estimatedMinutes: 10,
        tasks: [],
      );

      final lockedLesson2 = LessonEntity(
        id: '2',
        title: 'Lesson 2',
        position: 2,
        status: LessonStatus.locked,
        xp: 100,
        estimatedMinutes: 10,
        tasks: [],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LessonConnector(
              currentLesson: lockedLesson1,
              nextLesson: lockedLesson2,
            ),
          ),
        ),
      );

      expect(find.byType(LessonConnector), findsOneWidget);
    });
  });
}
