import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../core/app_colors.dart';
import '../../features/startup/bloc/startup_bloc.dart';
import '../../features/startup/bloc/startup_event.dart';
import '../../features/startup/bloc/startup_state.dart';
import 'certifications_screen.dart';

class StartupsScreen extends StatefulWidget {
  const StartupsScreen({super.key});

  @override
  State<StartupsScreen> createState() => _StartupsScreenState();
}

class _StartupsScreenState extends State<StartupsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<StartupBloc>().add(const FetchStartupStatus());
  }

  void _showAwesomeSnackbar(
    String title,
    String message,
    ContentType contentType,
  ) {
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: title,
        message: message,
        contentType: contentType,
      ),
    );
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ethiopian Startups & Status'),
        actions: [
          IconButton(
            icon: const Icon(Icons.workspace_premium_outlined),
            tooltip: 'View Official Certificate',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CertificationsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<StartupBloc>().add(const FetchStartupStatus());
        },
        child: BlocConsumer<StartupBloc, StartupState>(
          listener: (context, state) {
            if (state is StartupError) {
              _showAwesomeSnackbar('Notice', state.message, ContentType.failure);
            } else if (state is StartupRenewed) {
              _showAwesomeSnackbar(
                'Renewal Initiated',
                state.result.message ??
                    'Draft renewal application successfully initiated.',
                ContentType.success,
              );
            }
          },
          builder: (context, state) {
            if (state is StartupLoading) {
              return const Center(
                child: SpinKitThreeBounce(color: AppColors.primary, size: 30),
              );
            }

            if (state is StartupLoaded) {
              final status = state.data;
              return ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  status.name,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: status.status == 'APPROVED' ||
                                          status.status == 'ACTIVE'
                                      ? Colors.green.shade50
                                      : Colors.amber.shade50,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  status.status.toUpperCase(),
                                  style: TextStyle(
                                    color: status.status == 'APPROVED' ||
                                            status.status == 'ACTIVE'
                                        ? Colors.green
                                        : Colors.amber.shade900,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          if (status.sector != null) ...[
                            _infoRow(
                              Icons.category,
                              'Sector',
                              status.sector!,
                            ),
                          ],
                          if (status.stage != null) ...[
                            _infoRow(
                              Icons.trending_up,
                              'Stage',
                              status.stage!,
                            ),
                          ],
                          if (status.membershipExpiresAt != null) ...[
                            _infoRow(
                              Icons.event_repeat,
                              'Membership Expiry',
                              status.membershipExpiresAt!,
                            ),
                          ],
                          if (status.description != null) ...[
                            const SizedBox(height: 12),
                            Text(
                              status.description!,
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 13,
                              ),
                            ),
                          ],
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: AppColors.primary,
                                    side: const BorderSide(color: AppColors.primary),
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const CertificationsScreen(),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.workspace_premium, size: 18),
                                  label: const Text('View Certificate'),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () {
                                    context
                                        .read<StartupBloc>()
                                        .add(const RenewStartup());
                                  },
                                  icon: const Icon(Icons.autorenew, size: 18),
                                  label: const Text('Renew Label'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }

            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.business_center_outlined,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'No Startup Registered',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Submit a startup application to receive official Ethiopian startup designation.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
          Text(
            value,
            style: TextStyle(color: Colors.grey[800], fontSize: 13),
          ),
        ],
      ),
    );
  }
}
