import 'package:flutter/material.dart';

class DisplayHandler extends StatelessWidget {
  final bool isLoading;
  final Widget loading;
  final Widget content;
  final bool isFailure;
  final Widget failure;

  const DisplayHandler({
    super.key,
    required this.isLoading,
    required this.loading,
    required this.content,
    required this.isFailure,
    required this.failure,
  });

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !isLoading && !isFailure,
      replacement: Visibility(
        visible: isFailure,
        replacement: loading,
        child: failure,
      ),
      child: content,
    );
  }
}
