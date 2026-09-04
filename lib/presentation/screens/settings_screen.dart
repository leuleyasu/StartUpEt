import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/app_colors.dart';
import '../../core/theme/cubit/theme_cubit.dart';
import '../../core/theme/cubit/theme_state.dart';
import '../../features/auth/bloc/auth_bloc.dart';
import '../../features/auth/bloc/auth_event.dart';
import '../../features/auth/bloc/auth_state.dart';
import '../../features/ecosystem/bloc/ecosystem_bloc.dart';
import '../../features/ecosystem/bloc/ecosystem_event.dart' hide EcosystemEvent;
import '../../features/ecosystem/bloc/ecosystem_state.dart';
import '../widgets/notifications_bottom_sheet.dart';
import 'active_sessions_screen.dart';
import 'certifications_screen.dart';
import 'document_vault_screen.dart';
import 'edit_profile_screen.dart';
import 'reports_screen.dart';
import 'startups_screen.dart';
import 'verification_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _showAwesomeSnackbar(
    BuildContext context,
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
    return BlocListener<EcosystemBloc, EcosystemState>(
      listener: (context, state) {
        if (state is EcosystemApplicationSubmitted) {
          _showAwesomeSnackbar(
            context,
            'Application Submitted!',
            'Your Ecosystem Builder application is now under official review.',
            ContentType.success,
          );
        } else if (state is EcosystemError) {
          _showAwesomeSnackbar(
            context,
            'Submission Notice',
            state.message,
            ContentType.failure,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Settings & Profile'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                _showLogoutConfirmationDialog(context);
              },
            ),
          ],
        ),
        body: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            final user = state is AuthAuthenticated ? state.user : null;

            final userName = user?.name ?? user?.email ?? 'User Profile';
            final email = user?.email ?? 'Not available';
            final role = user?.role ?? 'USER';

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Banner Card
                  Card(
                    elevation: 0,
                    color: Theme.of(context).cardColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: Theme.of(context)
                            .colorScheme
                            .outline
                            .withValues(alpha: 0.3),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 32,
                            backgroundColor: AppColors.primary,
                            backgroundImage:
                                user?.image != null && user!.image!.isNotEmpty
                                    ? NetworkImage(user.image!)
                                    : null,
                            child: (user?.image == null || user!.image!.isEmpty)
                                ? Text(
                                    userName.isNotEmpty
                                        ? userName[0].toUpperCase()
                                        : 'L',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : null,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userName,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  email,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(
                                      alpha: 0.12,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    role,
                                    style: const TextStyle(
                                      color: AppColors.primary,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.edit_outlined,
                              color: AppColors.primary,
                            ),
                            tooltip: 'Edit Profile',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditProfileScreen(user: user),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  Text(
                    'Account Preferences',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Appearance & Theme Option
                  BlocBuilder<ThemeCubit, ThemeState>(
                    builder: (context, themeState) {
                      final (label, icon) = switch (themeState.themeMode) {
                        ThemeMode.light => (
                          'Light Mode',
                          Icons.light_mode_outlined
                        ),
                        ThemeMode.dark => (
                          'Dark Mode',
                          Icons.dark_mode_outlined
                        ),
                        ThemeMode.system => (
                          'System Default',
                          Icons.brightness_auto_outlined
                        ),
                      };
                      return _settingsOptionTile(
                        context,
                        title: 'Appearance & Theme',
                        subtitle: 'Current: $label',
                        icon: icon,
                        iconColor: Colors.deepPurple,
                        onTap: () => _showThemeSelectionSheet(
                          context,
                          themeState.themeMode,
                        ),
                      );
                    },
                  ),

                  // Edit Profile Option
                  _settingsOptionTile(
                    context,
                    title: 'Edit Profile Information',
                    subtitle: 'Update name, phone number, location & avatar',
                    icon: Icons.person_outline,
                    iconColor: AppColors.primary,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfileScreen(user: user),
                        ),
                      );
                    },
                  ),

                  // Notifications Option
                  _settingsOptionTile(
                    context,
                    title: 'Notifications & Alerts',
                    subtitle: 'System notices, grant updates, SSE stream',
                    icon: Icons.notifications_active,
                    iconColor: Colors.amber.shade800,
                    onTap: () => NotificationsBottomSheet.show(context),
                  ),

                  // Active Sessions & Devices Option
                  _settingsOptionTile(
                    context,
                    title: 'Active Sessions & Devices',
                    subtitle: 'Manage active logins & remote device revocation',
                    icon: Icons.devices_outlined,
                    iconColor: Colors.indigo,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ActiveSessionsScreen(),
                        ),
                      );
                    },
                  ),

                  // App Tour & Onboarding Option
                  _settingsOptionTile(
                    context,
                    title: 'App Tour & Ecosystem Onboarding',
                    subtitle: 'Replay the introductory walkthrough and founder spotlight',
                    icon: Icons.explore_outlined,
                    iconColor: Colors.teal,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const OnboardingScreen(),
                        ),
                      );
                    },
                  ),

                  // Ecosystem Builder Application Option
                  _settingsOptionTile(
                    context,
                    title: 'Apply as Ecosystem Builder',
                    subtitle: 'Incubator, accelerator & hub manager application',
                    icon: Icons.business_center,
                    iconColor: Colors.teal,
                    onTap: () => _showEcosystemBuilderDialog(context),
                  ),

                  const SizedBox(height: 24),
                  Text(
                    'Startup & Regulatory Compliance',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Identity & Tax Verification Option
                  _settingsOptionTile(
                    context,
                    title: 'Identity & Business Verification',
                    subtitle: 'Verify Fayda National ID (16-digit FCN) & E-Trade TIN',
                    icon: Icons.verified_user_outlined,
                    iconColor: Colors.blue.shade700,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const VerificationScreen(),
                        ),
                      );
                    },
                  ),

                  // Startup Status & Label Option
                  _settingsOptionTile(
                    context,
                    title: 'Startup Status & Details',
                    subtitle: 'Check designation tier, expiry date & renewal',
                    icon: Icons.business_outlined,
                    iconColor: Colors.deepPurple,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const StartupsScreen(),
                        ),
                      );
                    },
                  ),

                  // Official Certifications Option
                  _settingsOptionTile(
                    context,
                    title: 'Official Startup Certificate',
                    subtitle: 'View, verify & download official PDF certificate',
                    icon: Icons.workspace_premium_outlined,
                    iconColor: Colors.teal.shade700,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CertificationsScreen(),
                        ),
                      );
                    },
                  ),

                  // Startup Progress Reporting Option
                  _settingsOptionTile(
                    context,
                    title: 'Compliance & Progress Reports',
                    subtitle: 'Submit startup KPIs, progress reports & view history',
                    icon: Icons.assignment_outlined,
                    iconColor: Colors.orange.shade800,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ReportsScreen(),
                        ),
                      );
                    },
                  ),

                  // Legal & Document Vault Option
                  _settingsOptionTile(
                    context,
                    title: 'Legal & Document Vault',
                    subtitle: 'Securely manage licenses, articles, pitch decks & files',
                    icon: Icons.folder_shared_outlined,
                    iconColor: Colors.blueGrey.shade700,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DocumentVaultScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _showThemeSelectionSheet(BuildContext context, ThemeMode currentMode) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (bottomSheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'Choose Theme',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
                const Divider(),
                _buildThemeSelectionTile(
                  context,
                  bottomSheetContext,
                  mode: ThemeMode.system,
                  currentMode: currentMode,
                  title: 'System Default',
                  subtitle: 'Follows system dark/light settings',
                  icon: Icons.brightness_auto_outlined,
                ),
                _buildThemeSelectionTile(
                  context,
                  bottomSheetContext,
                  mode: ThemeMode.light,
                  currentMode: currentMode,
                  title: 'Light Mode',
                  subtitle: 'Crisp white appearance',
                  icon: Icons.light_mode_outlined,
                ),
                _buildThemeSelectionTile(
                  context,
                  bottomSheetContext,
                  mode: ThemeMode.dark,
                  currentMode: currentMode,
                  title: 'Dark Mode',
                  subtitle: 'Eye-friendly dark slate appearance',
                  icon: Icons.dark_mode_outlined,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildThemeSelectionTile(
    BuildContext context,
    BuildContext bottomSheetContext, {
    required ThemeMode mode,
    required ThemeMode currentMode,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final isSelected = mode == currentMode;
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
      trailing: isSelected
          ? Icon(
              Icons.check_circle,
              color: Theme.of(context).colorScheme.primary,
            )
          : Icon(
              Icons.circle_outlined,
              color: Theme.of(context).colorScheme.outline,
            ),
      onTap: () {
        context.read<ThemeCubit>().setThemeMode(mode);
        Navigator.pop(bottomSheetContext);
      },
    );
  }

  Widget _settingsOptionTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 4,
        ),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  void _showEcosystemBuilderDialog(BuildContext context) {
    final orgNameController = TextEditingController();
    final typeController = TextEditingController();
    final websiteController = TextEditingController();
    final bioController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Ecosystem Builder Application'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: orgNameController,
                  decoration: const InputDecoration(
                    hintText: 'Organization Name',
                    prefixIcon: Icon(Icons.business),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: typeController,
                  decoration: const InputDecoration(
                    hintText: 'Builder Type (e.g. Incubator, Accelerator, Hub)',
                    prefixIcon: Icon(Icons.category),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: websiteController,
                  keyboardType: TextInputType.url,
                  decoration: const InputDecoration(
                    hintText: 'Official Website / Portal URL',
                    prefixIcon: Icon(Icons.language),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: bioController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: 'Organization Mission & Program Overview',
                    prefixIcon: Icon(Icons.notes),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(dialogContext);
                context.read<EcosystemBloc>().add(
                  SubmitEcosystemApplication({
                    'organizationName': orgNameController.text.trim(),
                    'builderType': typeController.text.trim(),
                    'website': websiteController.text.trim(),
                    'description': bioController.text.trim(),
                  }),
                );
              },
              child: const Text('Submit Application'),
            ),
          ],
        );
      },
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Logout Confirmation'),
          content: const Text(
            'Are you sure you want to log out of your StartupET account?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
                context.read<AuthBloc>().add(const AuthLogout());
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}
