import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../core/app_colors.dart';
import '../../../../injection_container.dart' as di;
import '../../../auth/presentation/screens/login_screen.dart';
import '../../../auth/presentation/screens/register_screen.dart';
import '../../models/onboarding_item.dart';
import '../widgets/founder_spotlight_card.dart';
import '../widgets/onboarding_image_card.dart';
import '../widgets/onboarding_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  static const String hasSeenOnboardingKey = 'has_seen_onboarding';

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<OnboardingItem> _pages = OnboardingItem.items;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding({bool toRegister = false}) async {
    try {
      final storage = di.sl.isRegistered<FlutterSecureStorage>()
          ? di.sl<FlutterSecureStorage>()
          : const FlutterSecureStorage();
      await storage.write(
        key: OnboardingScreen.hasSeenOnboardingKey,
        value: 'true',
      );
    } catch (_) {
      // Best-effort storage write; ignore error and proceed
    }

    if (!mounted) return;

    final targetScreen =
        toRegister ? const RegisterScreen() : const LoginScreen();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => targetScreen),
    );
  }

  void _nextPage() {
    if (_currentIndex < _pages.length - 1) {
      _pageController.animateToPage(
        _currentIndex + 1,
        duration: const Duration(milliseconds: 380),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _completeOnboarding(toRegister: true);
    }
  }

  void _previousPage() {
    if (_currentIndex > 0) {
      _pageController.animateToPage(
        _currentIndex - 1,
        duration: const Duration(milliseconds: 380),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isLastPage = _currentIndex == _pages.length - 1;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkScaffold : AppColors.lightScaffold,
      body: SafeArea(
        child: Column(
          children: [
            // Top Navigation Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // App Brand Logo & Name
                  Row(
                    children: [
                      isDark
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                'assets/logo_white.png',
                                height: 28,
                                errorBuilder: (_, __, ___) => const Icon(
                                  Icons.rocket_launch_rounded,
                                  color: AppColors.primary,
                                  size: 24,
                                ),
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                'assets/logo.png',
                                height: 28,
                                errorBuilder: (_, __, ___) => const Icon(
                                  Icons.rocket_launch_rounded,
                                  color: AppColors.primary,
                                  size: 24,
                                ),
                              ),
                            ),
                      // const SizedBox(width: 8),
                      // Text(
                      //   'StartupET',
                      //   style: TextStyle(
                      //     fontSize: 18,
                      //     fontWeight: FontWeight.w800,
                      //     letterSpacing: -0.5,
                      //     color: isDark ? Colors.white : AppColors.primaryDark,
                      //   ),
                      // ),
                    ],
                  ),

                  // Skip Button
                  if (!isLastPage)
                    TextButton(
                      onPressed: () => _completeOnboarding(toRegister: false),
                      style: TextButton.styleFrom(
                        foregroundColor: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        // shape: RoundedRectangleBorder(
                        //   borderRadius: BorderRadius.circular(20),
                        //   side: BorderSide(
                        //     color: (isDark
                        //             ? AppColors.darkBorder
                        //             : AppColors.lightBorder)
                        //         .withValues(alpha: 0.6),
                        //   ),
                        // ),
                      ),
                      child: const Text(
                        'Skip',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  else
                    const SizedBox(height: 36),
                ],
              ),
            ),

            // Main Content Area with PageView
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                physics: const BouncingScrollPhysics(),
                onPageChanged: (index) {
                  setState(() => _currentIndex = index);
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  final item = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Hero Visual Component
                        Expanded(
                          flex: 12,
                          child: item.isFounderSpotlight
                              ? FounderSpotlightCard(imagePath: item.imagePath)
                              : OnboardingImageCard(
                                  imagePath: item.imagePath,
                                  floatingChips: item.chips,
                                ),
                        ),

                        const SizedBox(height: 16),

                        // Badge / Category Tag
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: (isDark
                                    ? AppColors.darkPrimaryAccent
                                    : AppColors.primary)
                                .withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: (isDark
                                      ? AppColors.darkPrimaryAccent
                                      : AppColors.primary)
                                  .withValues(alpha: 0.25),
                            ),
                          ),
                          child: Text(
                            item.badge,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.1,
                              color: isDark
                                  ? AppColors.darkPrimaryAccent
                                  : AppColors.primary,
                            ),
                          ),
                        ),

                        const SizedBox(height: 14),

                        // Title
                        Text(
                          item.title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.6,
                            height: 1.25,
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.lightTextPrimary,
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Subtitle
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 380),
                          child: Text(
                            item.subtitle,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              height: 1.5,
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary,
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Chip Tags for quick value proposition
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          alignment: WrapAlignment.center,
                          children: item.chips.map((chip) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: (isDark
                                        ? AppColors.darkSurface
                                        : Colors.white)
                                    .withValues(alpha: 0.8),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: (isDark
                                          ? AppColors.darkBorder
                                          : AppColors.lightBorder)
                                      .withValues(alpha: 0.7),
                                ),
                              ),
                              child: Text(
                                chip,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.lightTextSecondary,
                                ),
                              ),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 16),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Bottom Navigation & Controls
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Animated Indicator
                  OnboardingIndicator(
                    count: _pages.length,
                    currentIndex: _currentIndex,
                    onDotTap: (index) {
                      _pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 350),
                        curve: Curves.easeInOutCubic,
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  // Actions
                  if (!isLastPage) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Back Button
                        if (_currentIndex > 0)
                          IconButton(
                            onPressed: _previousPage,
                            style: IconButton.styleFrom(
                              backgroundColor:
                                  isDark ? AppColors.darkSurface : Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                                side: BorderSide(
                                  color: isDark
                                      ? AppColors.darkBorder
                                      : AppColors.lightBorder,
                                ),
                              ),
                              padding: const EdgeInsets.all(14),
                            ),
                            icon: Icon(
                              Icons.arrow_back_rounded,
                              color: isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.lightTextPrimary,
                            ),
                          )
                        else
                          const SizedBox(width: 52),

                        // Next Button
                        // ElevatedButton(
                        //   onPressed: _nextPage,
                        //   style: ElevatedButton.styleFrom(
                        //     backgroundColor: isDark
                        //         ? AppColors.darkPrimary
                        //         : AppColors.primary,
                        //     foregroundColor: Colors.white,
                        //     elevation: 4,
                        //     shadowColor:
                        //         AppColors.primary.withValues(alpha: 0.4),
                        //     shape: RoundedRectangleBorder(
                        //       borderRadius: BorderRadius.circular(18),
                        //     ),
                        //     padding: const EdgeInsets.symmetric(
                        //       horizontal: 28,
                        //       vertical: 16,
                        //     ),
                        //   ),
                        //   child: const Row(
                        //     mainAxisSize: MainAxisSize.min,
                        //     children: [
                        //       Text(
                        //         'Next',
                        //         style: TextStyle(
                        //           fontSize: 15,
                        //           fontWeight: FontWeight.w700,
                        //         ),
                        //       ),
                        //       SizedBox(width: 8),
                        //       Icon(Icons.arrow_forward_rounded, size: 18),
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                  ] else ...[
                    // Final Page Actions: "Get Started" & "Sign In"
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ElevatedButton(
                          onPressed: () =>
                              _completeOnboarding(toRegister: true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isDark
                                ? AppColors.darkPrimary
                                : AppColors.primary,
                            foregroundColor: Colors.white,
                            elevation: 4,
                            shadowColor:
                                AppColors.primary.withValues(alpha: 0.4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Get Started',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.3,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward_rounded, size: 20),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        // OutlinedButton(
                        //   onPressed: () =>
                        //       _completeOnboarding(toRegister: false),
                        //   style: OutlinedButton.styleFrom(
                        //     foregroundColor: isDark
                        //         ? AppColors.darkTextPrimary
                        //         : AppColors.primary,
                        //     side: BorderSide(
                        //       color: isDark
                        //           ? AppColors.darkBorder
                        //           : AppColors.lightBorderSubtle,
                        //     ),
                        //     shape: RoundedRectangleBorder(
                        //       borderRadius: BorderRadius.circular(16),
                        //     ),
                        //     padding: const EdgeInsets.symmetric(vertical: 14),
                        //   ),
                        //   child: const Text(
                        //     'Already have an account? Sign In',
                        //     style: TextStyle(
                        //       fontSize: 14,
                        //       fontWeight: FontWeight.w600,
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
