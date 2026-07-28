import 'package:flutter/material.dart';

class FundingScreen extends StatefulWidget {
  const FundingScreen({super.key});

  @override
  State<FundingScreen> createState() => _FundingScreenState();
}

class _FundingScreenState extends State<FundingScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> _grants = [
    {
      'title': 'National Innovation Grant 2026',
      'provider': 'Ministry of Innovation & Technology',
      'amount': 'ETB 2,500,000',
      'deadline': 'Sep 30, 2026',
      'category': 'Grant',
      'description': 'Non-dilutive seed capital for registered Ethiopian tech startups with verified Fayda ID.',
    },
    {
      'title': 'GreenTech Energy Challenge',
      'provider': 'East Africa Climate Fund',
      'amount': '\$50,000 USD',
      'deadline': 'Oct 15, 2026',
      'category': 'Equity / Grant',
      'description': 'Catalytic financing for renewable energy, solar tech, and agricultural sustainability.',
    },
    {
      'title': 'Women Entrepreneurs Innovation Fund',
      'provider': 'StartupEt Growth Accelerator',
      'amount': 'ETB 1,800,000',
      'deadline': 'Nov 01, 2026',
      'category': 'Accelerator',
      'description': 'Targeted funding, mentorship, and cloud credits for female founders in tech.',
    },
  ];

  final List<Map<String, dynamic>> _myApplications = [
    {
      'title': 'National Innovation Grant 2026',
      'appliedDate': 'July 10, 2026',
      'status': 'Under Review',
      'statusColor': Colors.orange,
      'step': 'Step 2 of 4: Document Verification',
    },
    {
      'title': 'Startup Label Certification Application',
      'appliedDate': 'June 15, 2026',
      'status': 'Approved',
      'statusColor': Colors.green,
      'step': 'Certificate Generated',
    },
  ];

  @override
  void initState() {
    super.initState() ;
    _tabController = TabController(length: 2, vsync: this);
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
        title: const Text('Funding & Pitches'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Available Grants'),
            Tab(text: 'My Applications'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildGrantsTab(),
          _buildMyApplicationsTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showSubmitPitchDialog(context),
        icon: const Icon(Icons.send),
        label: const Text('Submit Pitch'),
      ),
    );
  }

  Widget _buildGrantsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _grants.length,
      itemBuilder: (context, index) {
        final grant = _grants[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        grant['category'],
                        style: const TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      'Deadline: ${grant['deadline']}',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  grant['title'],
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'Offered by: ${grant['provider']}',
                  style: TextStyle(color: Colors.grey[700], fontSize: 12),
                ),
                const SizedBox(height: 8),
                Text(grant['description'], style: TextStyle(color: Colors.grey[800])),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      grant['amount'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => _applyForFunding(context, grant['title']),
                      child: const Text('Apply Now'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMyApplicationsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _myApplications.length,
      itemBuilder: (context, index) {
        final app = _myApplications[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            title: Text(
              app['title'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text('Applied: ${app['appliedDate']}'),
                const SizedBox(height: 4),
                Text(
                  'Stage: ${app['step']}',
                  style: const TextStyle(color: Colors.black87),
                ),
              ],
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: (app['statusColor'] as Color).withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                app['status'],
                style: TextStyle(
                  color: app['statusColor'] as Color,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _applyForFunding(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Application submitted for "$title"!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showSubmitPitchDialog(BuildContext context) {
    final titleController = TextEditingController();
    final summaryController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Submit Pitch Deck'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Startup / Pitch Title',
                  hintText: 'e.g. AgriTech AI Solutions',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: summaryController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Executive Summary',
                  hintText: 'Briefly describe your solution and market target',
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Pitch Deck PDF attached.')),
                  );
                },
                icon: const Icon(Icons.upload_file),
                label: const Text('Attach Pitch Deck (PDF)'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Pitch successfully submitted to investors!'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }
}
