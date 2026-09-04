import 'package:flutter/material.dart';
import '../../../../core/app_colors.dart';

class FounderSpotlightCard extends StatelessWidget {
  final String imagePath;

  const FounderSpotlightCard({
    super.key,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Ambient Radial Glow Background
            Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    (isDark ? AppColors.darkPrimaryAccent : AppColors.primaryLight)
                        .withValues(alpha: 0.28),
                    (isDark ? AppColors.primary : AppColors.primary)
                        .withValues(alpha: 0.08),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.55, 1.0],
                ),
              ),
            ),

            // Outer Decorative Orbit Ring
            Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: (isDark
                          ? AppColors.darkPrimaryAccent
                          : AppColors.primary)
                      .withValues(alpha: 0.25),
                  width: 1.5,
                ),
              ),
            ),

            // Main Founder Card Frame
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    isDark ? AppColors.darkPrimaryAccent : AppColors.primary,
                    isDark ? AppColors.primary : AppColors.primaryDark,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.35),
                    blurRadius: 28,
                    spreadRadius: 2,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(4),
              child: ClipOval(
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: AppColors.primaryDark,
                    child: const Icon(
                      Icons.person_rounded,
                      size: 80,
                      color: Colors.white70,
                    ),
                  ),
                ),
              ),
            ),

            // Verified Founder Badge
            Positioned(
              bottom: 12,
              right: 28,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark
                        ? AppColors.darkPrimaryAccent.withValues(alpha: 0.6)
                        : AppColors.primary.withValues(alpha: 0.2),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.verified_rounded,
                      size: 16,
                      color: isDark
                          ? AppColors.darkPrimaryAccent
                          : AppColors.primary,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Verified Founder',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppColors.primaryDark,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Floating Inspirational Quote Tag
            Positioned(
              top: 10,
              left: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: (isDark ? AppColors.darkSurface : Colors.white)
                      .withValues(alpha: 0.92),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      '🇪🇹',
                      style: TextStyle(fontSize: 13),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Startup Innovator',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
