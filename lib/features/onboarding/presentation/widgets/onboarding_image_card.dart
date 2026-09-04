import 'package:flutter/material.dart';
import '../../../../core/app_colors.dart';

class OnboardingImageCard extends StatelessWidget {
  final String imagePath;
  final List<String> floatingChips;

  const OnboardingImageCard({
    super.key,
    required this.imagePath,
    required this.floatingChips,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scaffoldColor = isDark ? AppColors.darkScaffold : AppColors.lightScaffold;

    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        constraints: const BoxConstraints(
          maxWidth: 420,
          maxHeight: 280,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: (isDark ? Colors.black : AppColors.primary).withValues(alpha: 0.18),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Main Visual
              Image.asset(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: AppColors.primaryDark,
                  child: const Center(
                    child: Icon(
                      Icons.image_outlined,
                      size: 60,
                      color: Colors.white54,
                    ),
                  ),
                ),
              ),

              // Gradient Overlay Vignette at the bottom for smooth blending
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.transparent,
                        scaffoldColor.withValues(alpha: 0.2),
                        scaffoldColor.withValues(alpha: 0.85),
                      ],
                      stops: const [0.0, 0.45, 0.75, 1.0],
                    ),
                  ),
                ),
              ),

              // Subtle Top Left Frosted Badge
              if (floatingChips.isNotEmpty)
                Positioned(
                  top: 14,
                  left: 14,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.55),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      floatingChips.first,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),

              // Subtle Bottom Right Accent Chip
              if (floatingChips.length > 1)
                Positioned(
                  bottom: 16,
                  right: 14,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: (isDark ? AppColors.darkSurface : Colors.white)
                          .withValues(alpha: 0.92),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      floatingChips[1],
                      style: TextStyle(
                        color: isDark
                            ? AppColors.darkPrimaryAccent
                            : AppColors.primary,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
