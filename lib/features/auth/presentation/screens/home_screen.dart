import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';

import '../../../../core/app_colors.dart';
import '../../../../presentation/screens/applications_screen.dart';
import '../../../../presentation/screens/events_screen.dart';
import '../../../../presentation/screens/funding_screen.dart';
import '../../../../presentation/screens/settings_screen.dart';
import '../../../../presentation/widgets/startup_dashboard_view.dart';
import '../../../application/bloc/application_bloc.dart';
import '../../../application/bloc/application_event.dart';
import '../../../startup/bloc/startup_bloc.dart';
import '../../../startup/bloc/startup_event.dart';
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
    _tabController = TabController(length: 5, vsync: this);
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
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.25)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
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
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 9.5,
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
          StartupDashboardView(
            user: user,
            onNavigateTab: (index) {
              setState(() {
                _currentIndex = index;
                _tabController.animateTo(index);
              });
            },
          ),
          const ApplicationsScreen(),
          const FundingScreen(),
          const EventsScreen(),
          const SettingsScreen(),
        ];

        return Scaffold(
          body: BottomBar(
            showIcon: false,
            layout: BottomBarLayout(
              width: MediaQuery.of(context).size.width * 0.94,
              borderRadius: BorderRadius.circular(30),
              offset: 16,
              alignment: Alignment.bottomCenter,
            ),
            theme: BottomBarThemeData(
              barDecoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFF1E293B)
                    : AppColors.primary,
                borderRadius: BorderRadius.circular(30),
                border: Theme.of(context).brightness == Brightness.dark
                    ? Border.all(color: const Color(0xFF334155), width: 1.2)
                    : null,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
            ),
            body: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: pages,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: TabBar(
                controller: _tabController,
                indicator: const BoxDecoration(),
                indicatorColor: Colors.transparent,
                indicatorWeight: 0,
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
                    Icons.account_balance_wallet_outlined,
                    Icons.account_balance_wallet,
                    'Funding',
                  ),
                  _buildTabItem(
                    3,
                    Icons.event_outlined,
                    Icons.event,
                    'Events',
                  ),
                  _buildTabItem(
                    4,
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
