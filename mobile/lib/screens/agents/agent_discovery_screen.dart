import 'package:flutter/material.dart';

class AgentDiscoveryScreen extends StatefulWidget {
  const AgentDiscoveryScreen({super.key});

  @override
  State<AgentDiscoveryScreen> createState() => _AgentDiscoveryScreenState();
}

class _AgentDiscoveryScreenState extends State<AgentDiscoveryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedLocation = 'All Locations';
  String _selectedService = 'All Services';
  double _minRating = 0.0;
  bool _isGridView = false;
  String _sortBy = 'Featured';

  // Sample agent data
  final List<Map<String, dynamic>> _agents = [
    {
      'id': '1',
      'name': 'Sarah Johnson',
      'location': 'New York, USA',
      'rating': 4.9,
      'reviews': 127,
      'hourlyRate': 25,
      'specialties': ['Fashion', 'Electronics', 'Cosmetics'],
      'languages': ['English', 'Spanish'],
      'responseTime': '< 1 hour',
      'completedTrips': 89,
      'verified': true,
    },
    {
      'id': '2',
      'name': 'Mohammed Ali',
      'location': 'Dubai, UAE',
      'rating': 4.8,
      'reviews': 98,
      'hourlyRate': 30,
      'specialties': ['Luxury', 'Gold', 'Electronics'],
      'languages': ['Arabic', 'English'],
      'responseTime': '< 30 min',
      'completedTrips': 156,
      'verified': true,
    },
    {
      'id': '3',
      'name': 'Yuki Tanaka',
      'location': 'Tokyo, Japan',
      'rating': 5.0,
      'reviews': 156,
      'hourlyRate': 28,
      'specialties': ['Tech', 'Anime', 'Fashion'],
      'languages': ['Japanese', 'English'],
      'responseTime': '< 2 hours',
      'completedTrips': 203,
      'verified': true,
    },
    {
      'id': '4',
      'name': 'Emma Wilson',
      'location': 'London, UK',
      'rating': 4.7,
      'reviews': 82,
      'hourlyRate': 35,
      'specialties': ['Antiques', 'Fashion', 'Art'],
      'languages': ['English', 'French'],
      'responseTime': '< 3 hours',
      'completedTrips': 67,
      'verified': true,
    },
    {
      'id': '5',
      'name': 'Pierre Dubois',
      'location': 'Paris, France',
      'rating': 4.9,
      'reviews': 134,
      'hourlyRate': 32,
      'specialties': ['Luxury', 'Fashion', 'Perfume'],
      'languages': ['French', 'English'],
      'responseTime': '< 1 hour',
      'completedTrips': 112,
      'verified': true,
    },
    {
      'id': '6',
      'name': 'Li Wei',
      'location': 'Singapore',
      'rating': 4.8,
      'reviews': 91,
      'hourlyRate': 22,
      'specialties': ['Electronics', 'Food', 'Fashion'],
      'languages': ['Chinese', 'English', 'Malay'],
      'responseTime': '< 2 hours',
      'completedTrips': 78,
      'verified': false,
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredAgents {
    return _agents.where((agent) {
      final matchesRating = agent['rating'] >= _minRating;
      final matchesLocation = _selectedLocation == 'All Locations' ||
          agent['location'].toString().contains(_selectedLocation);
      final matchesService = _selectedService == 'All Services' ||
          (agent['specialties'] as List).contains(_selectedService);
      final matchesSearch = _searchController.text.isEmpty ||
          agent['name']
              .toString()
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()) ||
          agent['location']
              .toString()
              .toLowerCase()
              .contains(_searchController.text.toLowerCase());

      return matchesRating && matchesLocation && matchesService && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredAgents = _filteredAgents;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Agents'),
        actions: [
          IconButton(
            icon: Icon(_isGridView ? Icons.list : Icons.grid_view),
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
            tooltip: _isGridView ? 'List View' : 'Grid View',
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            onSelected: (value) {
              setState(() {
                _sortBy = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'Featured', child: Text('Featured')),
              const PopupMenuItem(value: 'Rating', child: Text('Highest Rated')),
              const PopupMenuItem(value: 'Price-Low', child: Text('Price: Low to High')),
              const PopupMenuItem(value: 'Price-High', child: Text('Price: High to Low')),
              const PopupMenuItem(value: 'Reviews', child: Text('Most Reviewed')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by name or location...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                          });
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),

          // Filter Chips
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                FilterChip(
                  label: Text(_selectedLocation),
                  selected: _selectedLocation != 'All Locations',
                  onSelected: (_) => _showLocationFilter(),
                  avatar: const Icon(Icons.location_on, size: 18),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: Text(_selectedService),
                  selected: _selectedService != 'All Services',
                  onSelected: (_) => _showServiceFilter(),
                  avatar: const Icon(Icons.work, size: 18),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: Text(
                      _minRating > 0 ? '${_minRating.toStringAsFixed(1)}+ stars' : 'Any Rating'),
                  selected: _minRating > 0,
                  onSelected: (_) => _showRatingFilter(),
                  avatar: const Icon(Icons.star, size: 18),
                ),
                const SizedBox(width: 8),
                if (_selectedLocation != 'All Locations' ||
                    _selectedService != 'All Services' ||
                    _minRating > 0)
                  ActionChip(
                    label: const Text('Clear Filters'),
                    onPressed: () {
                      setState(() {
                        _selectedLocation = 'All Locations';
                        _selectedService = 'All Services';
                        _minRating = 0.0;
                      });
                    },
                  ),
              ],
            ),
          ),

          // Results Count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text(
                  '${filteredAgents.length} agents found',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Text(
                  'Sort: $_sortBy',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // Agent List/Grid
          Expanded(
            child: filteredAgents.isEmpty
                ? _buildEmptyState()
                : _isGridView
                    ? _buildGridView(filteredAgents)
                    : _buildListView(filteredAgents),
          ),
        ],
      ),
    );
  }

  Widget _buildListView(List<Map<String, dynamic>> agents) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: agents.length,
      itemBuilder: (context, index) {
        return _buildAgentCard(agents[index]);
      },
    );
  }

  Widget _buildGridView(List<Map<String, dynamic>> agents) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: agents.length,
      itemBuilder: (context, index) {
        return _buildAgentGridCard(agents[index]);
      },
    );
  }

  Widget _buildAgentCard(Map<String, dynamic> agent) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _navigateToAgentProfile(agent),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Agent Avatar
              Stack(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[300],
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.grey[600],
                    ),
                  ),
                  if (agent['verified'])
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.verified,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              // Agent Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      agent['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            agent['location'],
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          size: 16,
                          color: Colors.amber,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${agent['rating']} (${agent['reviews']})',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          Icons.check_circle,
                          size: 14,
                          color: Colors.green[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${agent['completedTrips']} trips',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: (agent['specialties'] as List)
                          .take(3)
                          .map((specialty) => Chip(
                                label: Text(
                                  specialty,
                                  style: const TextStyle(fontSize: 10),
                                ),
                                padding: EdgeInsets.zero,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          '\$${agent['hourlyRate']}/hr',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          agent['responseTime'],
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAgentGridCard(Map<String, dynamic> agent) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _navigateToAgentProfile(agent),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Agent Avatar
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.grey[600],
                    ),
                  ),
                  if (agent['verified'])
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.verified,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      agent['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      agent['location'],
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 11,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          size: 14,
                          color: Colors.amber,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${agent['rating']}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      '\$${agent['hourlyRate']}/hr',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          const Text(
            'No agents found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your filters',
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  void _showLocationFilter() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select Location',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ...['All Locations', 'New York', 'Dubai', 'Tokyo', 'London', 'Paris', 'Singapore']
                  .map((location) => ListTile(
                        title: Text(location),
                        selected: _selectedLocation == location,
                        onTap: () {
                          setState(() {
                            _selectedLocation = location;
                          });
                          Navigator.pop(context);
                        },
                      ))
                  .toList(),
            ],
          ),
        );
      },
    );
  }

  void _showServiceFilter() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select Service',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ...['All Services', 'Fashion', 'Electronics', 'Luxury', 'Tech', 'Cosmetics', 'Gold']
                  .map((service) => ListTile(
                        title: Text(service),
                        selected: _selectedService == service,
                        onTap: () {
                          setState(() {
                            _selectedService = service;
                          });
                          Navigator.pop(context);
                        },
                      ))
                  .toList(),
            ],
          ),
        );
      },
    );
  }

  void _showRatingFilter() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Minimum Rating',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ...[0.0, 4.0, 4.5, 4.7, 4.8, 4.9]
                  .map((rating) => ListTile(
                        title: Text(rating == 0.0 ? 'Any Rating' : '$rating+ stars'),
                        selected: _minRating == rating,
                        onTap: () {
                          setState(() {
                            _minRating = rating;
                          });
                          Navigator.pop(context);
                        },
                      ))
                  .toList(),
            ],
          ),
        );
      },
    );
  }

  void _navigateToAgentProfile(Map<String, dynamic> agent) {
    // TODO: Navigate to agent profile screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening profile for ${agent['name']}'),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}
