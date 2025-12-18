import 'package:flutter/material.dart';

import '../../../infra.dart';

class FailureResultCard extends StatelessWidget {
  final String message;
  final VoidCallback onReload;

  const FailureResultCard({
    super.key,
    required this.onReload,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onReload,
        child: Container(
          width: double.maxFinite,
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              width: 1,
              color: Colors.black.withValues(alpha: .15),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  message,
                  style: AppTextStyles.bodySmall(
                    color: Colors.red,
                  ).copyWith(
                    height: 0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Icon(Icons.replay_outlined),
            ],
          ),
        ),
      ),
    );
  }
}
