import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';

import '../../../../core/app_colors.dart';
import '../../../../models/user.dart';
import '../../../../presentation/screens/applications_screen.dart';
import '../../../../presentation/screens/certifications_screen.dart';
import '../../../../presentation/screens/settings_screen.dart';
import '../../../../presentation/widgets/notifications_bottom_sheet.dart';
import '../../../application/bloc/application_bloc.dart';
import '../../../application/bloc/application_event.dart';
import '../../../application/bloc/application_state.dart';
import '../../../startup/bloc/startup_bloc.dart';
import '../../../startup/bloc/startup_event.dart';
import '../../../startup/bloc/startup_state.dart';
import '../../bloc/auth_bloc.dart';
import '../../bloc/auth_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late int _currentIndex;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          _currentIndex = _tabController.index;
        });
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<StartupBloc>().add(const FetchStartupStatus());
        context.read<ApplicationBloc>().add(const FetchApplications());
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildTabItem(
    int index,
    IconData unselectedIcon,
    IconData selectedIcon,
    String label,
  ) {
    final isSelected = _currentIndex == index;
    return Tab(
      height: 52,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.25)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? selectedIcon : unselectedIcon,
              color: isSelected ? Colors.tealAccent : Colors.grey[400],
              size: 20,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.white : Colors.grey[400],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final user = state is AuthAuthenticated ? state.user : null;
        if (user == null) return const SizedBox();

        final List<Widget> pages = [
          _StartupDashboardView(
            user: user,
            onNavigateTab: (index) {
              setState(() {
                _currentIndex = index;
                _tabController.animateTo(index);
              });
            },
          ),
          const ApplicationsScreen(),
          const CertificationsScreen(),
          const SettingsScreen(),
        ];

        return Scaffold(
          body: BottomBar(
            showIcon: false,
            layout: BottomBarLayout(
              width: MediaQuery.of(context).size.width * 0.92,
              borderRadius: BorderRadius.circular(30),
              offset: 16,
              alignment: Alignment.bottomCenter,
            ),
            theme: BottomBarThemeData(
              barDecoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  // BoxShadow(
                  //   color: Colors.blue,
                  //   blurRadius: 15,
                  //   offset: const Offset(0, 5),
                  // ),
                ],
              ),
            ),
            body: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: pages,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: TabBar(
                controller: _tabController,
                indicatorColor: Colors.transparent,
                dividerColor: Colors.transparent,
                labelPadding: EdgeInsets.zero,
                tabs: [
                  _buildTabItem(
                    0,
                    Icons.dashboard_outlined,
                    Icons.dashboard,
                    'Dashboard',
                  ),
                  _buildTabItem(
                    1,
                    Icons.assignment_outlined,
                    Icons.assignment,
                    'Application',
                  ),
                  _buildTabItem(
                    2,
                    Icons.workspace_premium_outlined,
                    Icons.workspace_premium,
                    'Certifications',
                  ),
                  _buildTabItem(
                    3,
                    Icons.settings_outlined,
                    Icons.settings,
                    'Settings',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _StartupDashboardView extends StatelessWidget {
  final User user;
  final Function(int) onNavigateTab;

  const _StartupDashboardView({
    required this.user,
    required this.onNavigateTab,
  });

  String _getFirstName(String? name) {
    if (name == null || name.trim().isEmpty) return 'User';
    return name.trim().split(' ').first;
  }

  String _getInitials(String? name) {
    if (name == null || name.trim().isEmpty) return 'U';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, name.length >= 2 ? 2 : 1).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final firstName = _getFirstName(user.name);
    final initials = _getInitials(user.name);
    final role = user.role ?? 'USER';

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 140.0,
          floating: false,
          pinned: true,
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0xFF0F172A),
          title: Text(
            'Welcome, $firstName!',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: Stack(
                children: [
                  const Icon(
                    Icons.notifications_outlined,
                    color: Colors.white,
                    size: 24,
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Text(
                        '!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              onPressed: () => NotificationsBottomSheet.show(context),
            ),
            const SizedBox(width: 8),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: const EdgeInsets.fromLTRB(20, 75, 20, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: AppColors.primary,
                    child: Text(
                      initials,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'StartupET Mobile Dashboard',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.teal.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.tealAccent,
                              width: 0.8,
                            ),
                          ),
                          child: Text(
                            role,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Main Dashboard Content
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Primary CTA: Apply New Startup Application
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () => onNavigateTab(1),
                    icon: const Icon(Icons.add_circle_outline, size: 22),
                    label: const Text(
                      'Apply New Startup Application',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Live Metric Cards Grid
                const Text(
                  'Overview & Activity',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 12),

                BlocBuilder<ApplicationBloc, ApplicationState>(
                  builder: (context, appState) {
                    int fundingApps = 0;
                    int approvedApps = 0;
                    int pendingApps = 0;
                    int upcomingDeadlines = 0;

                    if (appState is ApplicationListLoaded) {
                      final apps = appState.applications;
                      fundingApps = apps
                          .where(
                            (a) =>
                                a.type == 'FUNDING' ||
                                a.data?['type'] == 'FUNDING',
                          )
                          .length;
                      approvedApps = apps
                          .where(
                            (a) =>
                                a.status.toUpperCase() == 'CERTIFIED' ||
                                a.status.toUpperCase() == 'APPROVED',
                          )
                          .length;
                      pendingApps = apps
                          .where(
                            (a) =>
                                a.status.toUpperCase() == 'PENDING' ||
                                a.status.toUpperCase() == 'UNDER_REVIEW',
                          )
                          .length;
                    }

                    final successRate = (fundingApps > 0)
                        ? ((approvedApps / fundingApps) * 100).toStringAsFixed(
                            0,
                          )
                        : '0';

                    return GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      childAspectRatio: 1.3,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      children: [
                        _MetricCard(
                          title: 'Funding Applications',
                          value: '$fundingApps',
                          subtitle: 'Across all programs',
                          icon: Icons.account_balance_wallet,
                          color: Colors.blue,
                        ),
                        _MetricCard(
                          title: 'Approved',
                          value: '$approvedApps',
                          subtitle: '$successRate% success rate',
                          icon: Icons.check_circle_outline,
                          color: Colors.green,
                        ),
                        _MetricCard(
                          title: 'Pending Reports',
                          value: '$pendingApps',
                          subtitle: pendingApps > 0
                              ? '$pendingApps under review'
                              : 'No pending reports',
                          icon: Icons.description_outlined,
                          color: Colors.amber.shade800,
                        ),
                        _MetricCard(
                          title: 'Upcoming Deadlines',
                          value: '$upcomingDeadlines',
                          subtitle: 'No upcoming deadlines',
                          icon: Icons.alarm,
                          color: Colors.purple,
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 24),

                // Important Notices Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Important Notices',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    TextButton(
                      onPressed: () => NotificationsBottomSheet.show(context),
                      child: const Text('View All Notifications'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                _buildNoticeCard(
                  title: 'Ethiopian Startup Certification Proclamation 2026',
                  description: 'All applicants require Fayda National ID (FCN) verification for tax exemption eligibility.',
                  time: 'Official Announcement',
                  icon: Icons.campaign,
                  color: AppColors.primary,
                ),

                const SizedBox(height: 24),

                // Startup Certification Status Preview Card
                _buildCertificationPreviewCard(context),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNoticeCard({
    required String title,
    required String description,
    required String time,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: color.withValues(alpha: 0.12),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      Text(
                        time,
                        style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCertificationPreviewCard(BuildContext context) {
    return BlocBuilder<StartupBloc, StartupState>(
      builder: (context, state) {
        if (state is StartupLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state is StartupLoaded) {
          final startup = state.data;
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                colors: [Color(0xFF0F766E), Color(0xFF0D9488)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Startup Label Status',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        startup.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Status: ${startup.status.toUpperCase()}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () => onNavigateTab(2),
                  child: const Text('View Cert'),
                ),
              ],
            ),
          );
        }

        // Empty state when no startup label exists yet
        return Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.grey.shade300),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Color(0xFFF1F5F9),
                  child: Icon(Icons.workspace_premium, color: Colors.grey),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'No Startup Label Registered',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Apply to get certified under StartupET',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => onNavigateTab(1),
                  child: const Text('Apply'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: color.withValues(alpha: 0.12),
                  child: Icon(icon, color: color, size: 20),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
