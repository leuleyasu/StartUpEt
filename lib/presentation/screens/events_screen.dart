import 'package:flutter/material.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> _events = [
    {
      'id': 'evt_1',
      'title': 'Ethiopia Startup Summit 2026',
      'date': 'Aug 15, 2026 • 09:00 AM',
      'location': 'Millennium Hall, Addis Ababa',
      'organizer': 'Ministry of Innovation & Technology',
      'registered': true,
      'imageColor': Colors.deepPurple,
    },
    {
      'id': 'evt_2',
      'title': 'FinTech & Digital Payment Workshop',
      'date': 'Aug 28, 2026 • 10:00 AM',
      'location': 'ICT Park, Addis Ababa',
      'organizer': 'Ethio Telecom & StartupEt',
      'registered': false,
      'imageColor': Colors.blue,
    },
    {
      'id': 'evt_3',
      'title': 'Venture Capital & Angel Investor Pitch Night',
      'date': 'Sep 05, 2026 • 06:00 PM',
      'location': 'Skylight Hotel, Addis Ababa',
      'organizer': 'Ethiopian Business Angels Network',
      'registered': false,
      'imageColor': Colors.orange,
    },
  ];

  final List<Map<String, dynamic>> _spaces = [
    {
      'name': 'ICT Park Innovation Hub',
      'location': 'Bole, Addis Ababa',
      'seatsAvailable': 12,
      'rate': 'ETB 1,500 / month',
      'amenities': 'Fiber Internet, Meeting Rooms, Coffee Bar',
    },
    {
      'name': 'Addis Tech Incubator Center',
      'location': 'Kazanchis, Addis Ababa',
      'seatsAvailable': 5,
      'rate': 'ETB 2,000 / month',
      'amenities': '24/7 Access, Maker Lab, Legal Advisory Desk',
    },
    {
      'name': 'Hawassa University Technology Park',
      'location': 'Hawassa',
      'seatsAvailable': 20,
      'rate': 'ETB 1,000 / month',
      'amenities': 'High-speed Wi-Fi, Research Labs, Conference Room',
    },
  ];

  @override
  void initState() {
    super.initState();
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
        title: const Text('Events & Hub Spaces'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Ecosystem Events'),
            Tab(text: 'Co-Working Spaces'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildEventsTab(),
          _buildSpacesTab(),
        ],
      ),
    );
  }

  Widget _buildEventsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _events.length,
      itemBuilder: (context, index) {
        final event = _events[index];
        final isRegistered = event['registered'] == true;

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: event['imageColor'] as Color,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                ),
                padding: const EdgeInsets.all(16),
                alignment: Alignment.bottomLeft,
                child: Text(
                  event['title'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.calendar_month, size: 16, color: Colors.grey),
                        const SizedBox(width: 6),
                        Text(event['date'], style: TextStyle(color: Colors.grey[800])),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 16, color: Colors.grey),
                        const SizedBox(width: 6),
                        Text(event['location'], style: TextStyle(color: Colors.grey[800])),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Organized by: ${event['organizer']}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isRegistered ? Colors.grey[200] : Theme.of(context).primaryColor,
                          foregroundColor: isRegistered ? Colors.black87 : Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            event['registered'] = !isRegistered;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                isRegistered
                                    ? 'Unregistered from ${event['title']}'
                                    : 'Registered for ${event['title']}!',
                              ),
                            ),
                          );
                        },
                        child: Text(isRegistered ? 'Registered (Cancel)' : 'Register Now'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSpacesTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _spaces.length,
      itemBuilder: (context, index) {
        final space = _spaces[index];
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
                    Text(
                      space['name'],
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${space['seatsAvailable']} Desks Left',
                        style: const TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.place, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(space['location'], style: TextStyle(color: Colors.grey[700], fontSize: 13)),
                  ],
                ),
                const SizedBox(height: 8),
                Text('Amenities: ${space['amenities']}', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      space['rate'],
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => _bookSpace(context, space['name']),
                      icon: const Icon(Icons.event_seat),
                      label: const Text('Book Desk'),
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

  void _bookSpace(BuildContext context, String spaceName) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Book $spaceName'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Select your preferred start date for desk allocation:'),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Start Date',
                  hintText: 'YYYY-MM-DD',
                  prefixIcon: Icon(Icons.calendar_today),
                ),
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
                  SnackBar(
                    content: Text('Desk booking request sent for $spaceName!'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text('Confirm Booking'),
            ),
          ],
        );
      },
    );
  }
}
