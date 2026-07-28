import 'package:flutter/material.dart';

class StartupsScreen extends StatefulWidget {
  const StartupsScreen({super.key});

  @override
  State<StartupsScreen> createState() => _StartupsScreenState();
}

class _StartupsScreenState extends State<StartupsScreen> {
  String _selectedSector = 'All';
  final String _searchQuery = '';

  final List<Map<String, dynamic>> _startups = [
    {
      'name': 'Gebeya Tech',
      'sector': 'EdTech & Talent',
      'stage': 'Growth',
      'location': 'Addis Ababa',
      'verified': true,
      'description': 'Pan-African tech talent marketplace building software engineering capacity.',
      'founded': '2016',
      'teamSize': '50-100',
    },
    {
      'name': 'AgriTech Ethiopia',
      'sector': 'Agriculture',
      'stage': 'Seed',
      'location': 'Hawassa',
      'verified': true,
      'description': 'IoT and AI driven precision farming platform for smallholder farmers in Ethiopia.',
      'founded': '2023',
      'teamSize': '10-20',
    },
    {
      'name': 'Chapa Financial',
      'sector': 'FinTech',
      'stage': 'Series A',
      'location': 'Addis Ababa',
      'verified': true,
      'description': 'Online payment gateway enabling digital transactions and e-commerce across Ethiopia.',
      'founded': '2020',
      'teamSize': '30-50',
    },
    {
      'name': 'Deliver Addis',
      'sector': 'Logistics',
      'stage': 'Expansion',
      'location': 'Addis Ababa',
      'verified': true,
      'description': 'On-demand food and package delivery ecosystem in urban Ethiopian cities.',
      'founded': '2015',
      'teamSize': '100+',
    },
    {
      'name': 'HealthNet ET',
      'sector': 'HealthTech',
      'stage': 'Pre-Seed',
      'location': 'Jimma',
      'verified': false,
      'description': 'Telemedicine and electronic medical record (EMR) system for regional clinics.',
      'founded': '2024',
      'teamSize': '5-10',
    },
  ];

  final List<String> _sectors = ['All', 'FinTech', 'Agriculture', 'EdTech & Talent', 'Logistics', 'HealthTech'];

  @override
  Widget build(BuildContext context) {
    final filteredStartups = _startups.where((s) {
      final matchesSector = _selectedSector == 'All' || s['sector'] == _selectedSector;
      final matchesSearch = s['name'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
          s['sector'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesSector && matchesSearch;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ethiopian Startups'),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: _sectors.map((sector) {
                final isSelected = _selectedSector == sector;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(sector),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedSector = sector;
                        });
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredStartups.length,
              itemBuilder: (context, index) {
                final startup = filteredStartups[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => _showStartupDetails(context, startup),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                startup['name'],
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              if (startup['verified'] == true)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.verified, size: 14, color: Colors.green),
                                      SizedBox(width: 4),
                                      Text(
                                        'Verified',
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            startup['description'],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.grey[700], fontSize: 13),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Chip(
                                label: Text(startup['sector']),
                                visualDensity: VisualDensity.compact,
                                backgroundColor: Colors.purple.shade50,
                                labelStyle: const TextStyle(fontSize: 11, color: Colors.deepPurple),
                              ),
                              const SizedBox(width: 8),
                              Chip(
                                label: Text(startup['stage']),
                                visualDensity: VisualDensity.compact,
                                backgroundColor: Colors.blue.shade50,
                                labelStyle: const TextStyle(fontSize: 11, color: Colors.blue),
                              ),
                              const Spacer(),
                              Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                              const SizedBox(width: 2),
                              Text(
                                startup['location'],
                                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showStartupDetails(BuildContext context, Map<String, dynamic> startup) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    startup['name'],
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                startup['description'],
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
              const Divider(height: 32),
              _detailRow(Icons.category, 'Sector', startup['sector']),
              _detailRow(Icons.trending_up, 'Stage', startup['stage']),
              _detailRow(Icons.location_city, 'Location', startup['location']),
              _detailRow(Icons.calendar_today, 'Founded', startup['founded']),
              _detailRow(Icons.people, 'Team Size', startup['teamSize']),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Contact request sent to ${startup['name']}')),
                    );
                  },
                  icon: const Icon(Icons.mail),
                  label: const Text('Contact Startup'),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.deepPurple),
          const SizedBox(width: 12),
          Text('$label:', style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(width: 8),
          Text(value, style: const TextStyle(color: Colors.black87)),
        ],
      ),
    );
  }
}
