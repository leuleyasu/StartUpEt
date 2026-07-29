import 'package:flutter/material.dart';
import '../../core/app_colors.dart';

class NotificationsBottomSheet extends StatelessWidget {
  const NotificationsBottomSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const NotificationsBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> notifications = [
      {
        'title': 'Certification Status Update',
        'message': 'Your startup application for "Startup Label" is currently under document review by the committee.',
        'time': '10 mins ago',
        'isRead': false,
        'icon': Icons.assignment_turned_in,
        'color': Colors.blue,
      },
      {
        'title': 'New Grant Opportunity!',
        'message': 'National Innovation Grant 2026 is now open for applications up to ETB 2,500,000.',
        'time': '1 hour ago',
        'isRead': false,
        'icon': Icons.monetization_on,
        'color': Colors.green,
      },
      {
        'title': 'Fayda ID Verified',
        'message': 'Your 16-digit Fayda National ID has been successfully verified with the central repository.',
        'time': 'Yesterday',
        'isRead': true,
        'icon': Icons.verified,
        'color': Colors.teal,
      },
      {
        'title': 'Ecosystem Summit RSVP',
        'message': 'Confirmation for Ethiopia Startup Summit 2026 at Millennium Hall.',
        'time': '2 days ago',
        'isRead': true,
        'icon': Icons.event,
        'color': Colors.purple,
      },
    ];

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(Icons.notifications_active, color: AppColors.primary),
                  SizedBox(width: 8),
                  Text(
                    'Notifications',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Mark all read'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.6,
            ),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: notifications.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final n = notifications[index];
                final isUnread = n['isRead'] == false;

                return Container(
                  color: isUnread ? AppColors.primary.withValues(alpha: 0.04) : Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: (n['color'] as Color).withValues(alpha: 0.15),
                        child: Icon(n['icon'] as IconData, color: n['color'] as Color, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  n['title'],
                                  style: TextStyle(
                                    fontWeight: isUnread ? FontWeight.bold : FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  n['time'],
                                  style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              n['message'],
                              style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
