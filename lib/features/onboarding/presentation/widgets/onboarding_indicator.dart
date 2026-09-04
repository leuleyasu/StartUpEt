import 'package:flutter/material.dart';
import '../../../../core/app_colors.dart';

class OnboardingIndicator extends StatelessWidget {
  final int count;
  final int currentIndex;
  final ValueChanged<int>? onDotTap;

  const OnboardingIndicator({
    super.key,
    required this.count,
    required this.currentIndex,
    this.onDotTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeColor = isDark ? AppColors.darkPrimaryAccent : AppColors.primary;
    final inactiveColor = (isDark ? Colors.white : AppColors.primaryDark)
        .withValues(alpha: 0.18);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (index) {
        final isActive = index == currentIndex;
        return GestureDetector(
          onTap: () => onDotTap?.call(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 320),
            curve: Curves.easeInOutCubic,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            height: 8,
            width: isActive ? 28 : 8,
            decoration: BoxDecoration(
              color: isActive ? activeColor : inactiveColor,
              borderRadius: BorderRadius.circular(4),
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: activeColor.withValues(alpha: 0.4),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
          ),
        );
      }),
    );
  }
}
