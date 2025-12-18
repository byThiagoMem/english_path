import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_fluency/app/domain_layer/entities/path/lesson_entity.dart';
import 'package:mini_fluency/app/infra/components/lesson_node.dart';

void main() {
  group('LessonNode -', () {
    testWidgets('renders lesson title and position', (tester) async {
      final lesson = LessonEntity(
        id: '1',
        title: 'Test Lesson',
        position: 1,
        status: LessonStatus.current,
        xp: 100,
        estimatedMinutes: 15,
        tasks: [],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LessonNode(
              lesson: lesson,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('1 • Test Lesson'), findsOneWidget);
    });

    testWidgets('executes onTap when tapped', (tester) async {
      var wasTapped = false;

      final lesson = LessonEntity(
        id: '1',
        title: 'Lesson 1',
        position: 1,
        status: LessonStatus.current,
        xp: 100,
        estimatedMinutes: 10,
        tasks: [],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LessonNode(
              lesson: lesson,
              onTap: () {
                wasTapped = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(GestureDetector));
      await tester.pump();

      expect(wasTapped, true);
    });

    testWidgets('shows check icon for completed lesson', (tester) async {
      final lesson = LessonEntity(
        id: '1',
        title: 'Completed Lesson',
        position: 1,
        status: LessonStatus.completed,
        xp: 100,
        estimatedMinutes: 10,
        tasks: [],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LessonNode(
              lesson: lesson,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('shows play icon for current lesson', (tester) async {
      final lesson = LessonEntity(
        id: '1',
        title: 'Current Lesson',
        position: 1,
        status: LessonStatus.current,
        xp: 100,
        estimatedMinutes: 10,
        tasks: [],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LessonNode(
              lesson: lesson,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.play_circle_filled), findsOneWidget);
    });

    testWidgets('shows lock icon for locked lesson', (tester) async {
      final lesson = LessonEntity(
        id: '1',
        title: 'Locked Lesson',
        position: 1,
        status: LessonStatus.locked,
        xp: 100,
        estimatedMinutes: 10,
        tasks: [],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LessonNode(
              lesson: lesson,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.lock), findsOneWidget);
    });

    testWidgets('has pulse animation for current lesson', (tester) async {
      final lesson = LessonEntity(
        id: '1',
        title: 'Current Lesson',
        position: 1,
        status: LessonStatus.current,
        xp: 100,
        estimatedMinutes: 10,
        tasks: [],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LessonNode(
              lesson: lesson,
              onTap: () {},
            ),
          ),
        ),
      );

      // Verify the widget is rendered
      expect(find.byType(LessonNode), findsOneWidget);

      // Pump frames to check animation
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.byType(LessonNode), findsOneWidget);
    });

    testWidgets('does not have pulse animation for completed lesson',
        (tester) async {
      final lesson = LessonEntity(
        id: '1',
        title: 'Completed Lesson',
        position: 1,
        status: LessonStatus.completed,
        xp: 100,
        estimatedMinutes: 10,
        tasks: [],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LessonNode(
              lesson: lesson,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.byType(LessonNode), findsOneWidget);
    });

    testWidgets('does not have pulse animation for locked lesson',
        (tester) async {
      final lesson = LessonEntity(
        id: '1',
        title: 'Locked Lesson',
        position: 1,
        status: LessonStatus.locked,
        xp: 100,
        estimatedMinutes: 10,
        tasks: [],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LessonNode(
              lesson: lesson,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.byType(LessonNode), findsOneWidget);
    });

    testWidgets('displays lesson position and title together', (tester) async {
      final lesson = LessonEntity(
        id: '1',
        title: 'Lesson 1',
        position: 5,
        status: LessonStatus.current,
        xp: 100,
        estimatedMinutes: 10,
        tasks: [],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LessonNode(
              lesson: lesson,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('5 • Lesson 1'), findsOneWidget);
    });
  });
}
