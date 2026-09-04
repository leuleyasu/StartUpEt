class OnboardingItem {
  final String badge;
  final String title;
  final String subtitle;
  final String imagePath;
  final List<String> chips;
  final bool isFounderSpotlight;

  const OnboardingItem({
    required this.badge,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.chips,
    this.isFounderSpotlight = false,
  });

  static const List<OnboardingItem> items = [
    OnboardingItem(
      badge: 'ETHIOPIAN INNOVATION',
      title: 'Connect, Collaborate & Build Together',
      subtitle:
          'Unite with Ethiopia\'s top entrepreneurs, developers, and innovators. Form powerhouse teams and build ventures that solve real problems.',
      imagePath: 'assets/onboarding/onboarding_collaboration.png',
      chips: ['🤝 Ecosystem Network', '💡 Co-Creation', '🚀 Team Building'],
      isFounderSpotlight: false,
    ),
    OnboardingItem(
      badge: 'GROWTH & PATHWAYS',
      title: 'Access Pathways to Capital & Scale',
      subtitle:
          'Navigate official startup adoption & transplantation pathways, pitch to angel investors, and unlock verified grants & acceleration programs.',
      imagePath: 'assets/onboarding/onboarding_pathways.png',
      chips: ['📈 Verified Grants', '💼 Investor Pitches', '🏛️ State Pathways'],
      isFounderSpotlight: false,
    ),
    OnboardingItem(
      badge: 'STARTUP ETHIOPIA',
      title: 'Empowering The Next Wave of Founders',
      subtitle:
          'Get your venture officially certified, access national tax incentives, receive world-class mentorship, and lead Ethiopia\'s digital revolution.',
      imagePath: 'assets/onboarding/onboarding_founder.jpeg',
      chips: ['🇪🇹 National Certification', '🌟 Founder Spotlight', '🛡️ Protected IP'],
      isFounderSpotlight: true,
    ),
  ];
}
