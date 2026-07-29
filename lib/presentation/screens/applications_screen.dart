import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/app_colors.dart';
import '../../features/application/bloc/application_bloc.dart';
import '../../features/application/bloc/application_event.dart';
import '../../features/application/bloc/application_state.dart';
import '../../models/application.dart';
import 'new_application_wizard_screen.dart';

class ApplicationsScreen extends StatefulWidget {
  const ApplicationsScreen({super.key});

  @override
  State<ApplicationsScreen> createState() => _ApplicationsScreenState();
}

class _ApplicationsScreenState extends State<ApplicationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    context.read<ApplicationBloc>().add(const FetchApplications());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Certification Applications'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Under Review'),
            Tab(text: 'Completed'),
            Tab(text: 'Certified'),
          ],
        ),
      ),
      body: BlocBuilder<ApplicationBloc, ApplicationState>(
        builder: (context, state) {
          if (state is ApplicationLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ApplicationError) {
            final isNotFound =
                state.message.contains('404') ||
                state.message.toLowerCase().contains('not found');
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isNotFound
                          ? Icons.assignment_outlined
                          : Icons.cloud_off_outlined,
                      size: 56,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      isNotFound
                          ? 'No Applications Found'
                          : 'Unable to Load Applications',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isNotFound
                          ? 'You haven\'t submitted any startup certification applications yet.'
                          : 'Please check your connection and tap retry to refresh.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlinedButton.icon(
                          onPressed: () {
                            context.read<ApplicationBloc>().add(
                              const FetchApplications(),
                            );
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('Retry'),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () =>
                              _showCreateApplicationDialog(context),
                          icon: const Icon(Icons.add),
                          label: const Text('New Application'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }

          List<Application> apps = [];
          if (state is ApplicationListLoaded) {
            apps = state.applications;
          }

          return TabBarView(
            controller: _tabController,
            children: [
              _buildApplicationsList(apps, null),
              _buildApplicationsList(apps, 'UNDER_REVIEW'),
              _buildApplicationsList(apps, 'COMPLETED'),
              _buildApplicationsList(apps, 'CERTIFIED'),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        onPressed: () => _showCreateApplicationDialog(context),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'New Application',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildApplicationsList(
    List<Application> allApps,
    String? filterStatus,
  ) {
    final filtered = filterStatus == null
        ? allApps
        : allApps.where((a) => a.status.toUpperCase() == filterStatus).toList();

    if (filtered.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.assignment_outlined,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'No applications found',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                filterStatus == null
                    ? 'Start your official Ethiopian Startup Certification process below.'
                    : 'No applications match filter "$filterStatus".',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Colors.grey[500]),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final app = filtered[index];
        final statusColor = _getStatusColor(app.status);

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: CircleAvatar(
              backgroundColor: statusColor.withValues(alpha: 0.15),
              child: Icon(Icons.description, color: statusColor),
            ),
            title: Text(
              app.data?['startupName']?.toString() ?? 'Startup Application',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text('ID: ${app.id}'),
                if (app.createdAt != null) Text('Submitted: ${app.createdAt}'),
              ],
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                app.status.toUpperCase(),
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'CERTIFIED':
        return Colors.green;
      case 'UNDER_REVIEW':
      case 'PENDING':
        return Colors.orange;
      case 'REJECTED':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  void _showCreateApplicationDialog(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const NewApplicationWizardScreen(),
      ),
    );
  }
}
