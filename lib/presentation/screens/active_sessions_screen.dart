import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../features/auth/bloc/auth_bloc.dart';
import '../../features/auth/bloc/auth_event.dart';
import '../../features/auth/bloc/auth_state.dart';
import '../../models/user_session.dart';

class ActiveSessionsScreen extends StatefulWidget {
  const ActiveSessionsScreen({super.key});

  @override
  State<ActiveSessionsScreen> createState() => _ActiveSessionsScreenState();
}

class _ActiveSessionsScreenState extends State<ActiveSessionsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(const AuthFetchSessionsRequested());
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

  String _formatDate(DateTime? dt) {
    if (dt == null) return 'Unknown';
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
  }

  String _parseDeviceName(String? ua) {
    if (ua == null || ua.trim().isEmpty) return 'Mobile App Client';
    if (ua.contains('iPhone')) return 'Apple iPhone (iOS)';
    if (ua.contains('iPad')) return 'Apple iPad (iPadOS)';
    if (ua.contains('Android')) return 'Android Mobile Device';
    if (ua.contains('Macintosh') || ua.contains('Mac OS')) return 'Apple Mac OS';
    if (ua.contains('Windows')) return 'Windows PC';
    if (ua.contains('Linux')) return 'Linux System';
    return ua.length > 28 ? '${ua.substring(0, 28)}...' : ua;
  }

  IconData _getDeviceIcon(String? ua) {
    if (ua == null) return Icons.smartphone;
    if (ua.contains('iPhone') || ua.contains('Android') || ua.contains('Mobile')) {
      return Icons.smartphone;
    }
    if (ua.contains('iPad') || ua.contains('Tablet')) {
      return Icons.tablet_mac;
    }
    return Icons.laptop_mac;
  }

  void _confirmTerminateSession(BuildContext context, UserSessionInfo session) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Revoke Device Session'),
          content: Text(
            'Are you sure you want to sign out this device (${_parseDeviceName(session.userAgent)})? It will immediately lose access to your StartupET account.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(dialogContext);
                context.read<AuthBloc>().add(
                      AuthTerminateSessionRequested(session.id),
                    );
                _showAwesomeSnackbar(
                  'Session Revoked',
                  'The remote device session has been terminated.',
                  ContentType.success,
                );
              },
              child: const Text('Sign Out Device'),
            ),
          ],
        );
      },
    );
  }

  void _confirmTerminateAllOthers(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Sign Out All Other Devices'),
          content: const Text(
            'This will terminate all active logins across other phones, tablets, and web browsers. Only this current session will remain active.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(dialogContext);
                context.read<AuthBloc>().add(
                      const AuthTerminateOtherSessionsRequested(),
                    );
                _showAwesomeSnackbar(
                  'All Other Devices Revoked',
                  'All other active sessions have been signed out.',
                  ContentType.success,
                );
              },
              child: const Text('Sign Out Others'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Active Sessions & Security'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Sessions',
            onPressed: () {
              context.read<AuthBloc>().add(const AuthFetchSessionsRequested());
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<AuthBloc>().add(const AuthFetchSessionsRequested());
        },
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthError) {
              _showAwesomeSnackbar('Notice', state.message, ContentType.failure);
            }
          },
          builder: (context, state) {
            if (state is AuthLoading) {
              return Center(
                child: SpinKitThreeBounce(
                  color: Theme.of(context).colorScheme.primary,
                  size: 30,
                ),
              );
            }

            List<UserSessionInfo> sessions = [];
            if (state is AuthSessionsLoaded) {
              sessions = state.sessions;
            }

            // Partition into current session vs other sessions
            UserSessionInfo? currentSession;
            final List<UserSessionInfo> otherSessions = [];

            for (final s in sessions) {
              if (s.isCurrentSession && currentSession == null) {
                currentSession = s;
              } else {
                otherSessions.add(s);
              }
            }

            // Fallback if isCurrentSession was not flagged: treat first active as current
            if (currentSession == null && sessions.isNotEmpty) {
              currentSession = sessions.first;
              otherSessions.remove(currentSession);
            }

            final theme = Theme.of(context);

            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // Security Summary Banner
                Card(
                  elevation: 0,
                  color: theme.cardColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: theme.colorScheme.outline.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.teal.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.shield_outlined,
                            color: Colors.teal,
                            size: 26,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Session & Device Security',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Review all devices currently authenticated to your account. Revoke any unrecognized sessions immediately.',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  color: theme.colorScheme.onSurfaceVariant,
                                  height: 1.35,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Section 1: Current Session
                Text(
                  'CURRENT ACTIVE DEVICE',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 10),

                if (currentSession != null)
                  _buildSessionCard(
                    context,
                    session: currentSession,
                    isCurrent: true,
                  )
                else
                  Card(
                    elevation: 0,
                    color: theme.cardColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: BorderSide(
                        color: theme.colorScheme.outline.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Active mobile session (This device)',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),

                const SizedBox(height: 24),

                // Section 2: Other Sessions Header + Terminate All Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'OTHER ACTIVE SESSIONS (${otherSessions.length})',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    if (otherSessions.isNotEmpty)
                      TextButton.icon(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.redAccent,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                        ),
                        onPressed: () => _confirmTerminateAllOthers(context),
                        icon: const Icon(Icons.delete_sweep, size: 18),
                        label: const Text(
                          'Sign Out Others',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 10),

                if (otherSessions.isEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 24,
                    ),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: theme.colorScheme.outline.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.verified_user_rounded,
                          color: Colors.green.shade600,
                          size: 40,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'No Other Active Devices',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'You are only logged in on this mobile device.',
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                else
                  ...otherSessions.map(
                    (s) => _buildSessionCard(
                      context,
                      session: s,
                      isCurrent: false,
                    ),
                  ),

                const SizedBox(height: 40),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSessionCard(
    BuildContext context, {
    required UserSessionInfo session,
    required bool isCurrent,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final deviceName = _parseDeviceName(session.userAgent);
    final icon = _getDeviceIcon(session.userAgent);
    final ip = session.ipAddress ?? 'Hidden IP';
    final createdAt = _formatDate(session.createdAt);
    final lastActive = _formatDate(session.lastActiveAt ?? session.createdAt);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCurrent
              ? Colors.green.withValues(alpha: 0.5)
              : theme.colorScheme.outline.withValues(alpha: 0.3),
          width: isCurrent ? 1.5 : 1,
        ),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: const Color(0xFF0F172A).withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isCurrent
                        ? Colors.green.withValues(alpha: 0.12)
                        : theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: isCurrent
                        ? (isDark ? Colors.greenAccent : Colors.green.shade700)
                        : theme.colorScheme.onSurfaceVariant,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              deviceName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.5,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                          if (isCurrent)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? Colors.green.withValues(alpha: 0.2)
                                    : Colors.green.shade50,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.green.withValues(alpha: 0.4),
                                  width: 0.8,
                                ),
                              ),
                              child: Text(
                                'THIS DEVICE',
                                style: TextStyle(
                                  color: isDark
                                      ? Colors.greenAccent
                                      : Colors.green.shade800,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.wifi,
                            size: 13,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'IP: $ip',
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Icon(
                            Icons.access_time,
                            size: 13,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Active $lastActive',
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Logged in $createdAt',
                        style: TextStyle(
                          fontSize: 11,
                          color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (!isCurrent) ...[
              const Divider(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.redAccent,
                    side: const BorderSide(color: Colors.redAccent, width: 0.8),
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => _confirmTerminateSession(context, session),
                  icon: const Icon(Icons.logout, size: 14),
                  label: const Text(
                    'Revoke Access',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
