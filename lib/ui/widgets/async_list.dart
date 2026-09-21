import 'package:flutter/material.dart';
import 'package:noua/ui/common/app_colors.dart';
import 'package:noua/ui/widgets/empty_state.dart';

/// Loading → empty → content, animated, for the three list screens.
class AsyncList extends StatelessWidget {
  const AsyncList({
    super.key,
    required this.isBusy,
    required this.isEmpty,
    required this.emptyMessage,
    required this.child,
  });

  final bool isBusy;
  final bool isEmpty;
  final String emptyMessage;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: isBusy
          ? const Center(
              key: ValueKey('busy'),
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            )
          : isEmpty
              ? EmptyState(key: ValueKey('empty$emptyMessage'), message: emptyMessage)
              : child,
    );
  }
}
