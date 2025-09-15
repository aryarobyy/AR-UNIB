part of 'directory.dart';

class RoomDirectory extends ConsumerStatefulWidget {
  const RoomDirectory({super.key});

  @override
  ConsumerState createState() => _RoomDirectoryState();
}

class _RoomDirectoryState extends ConsumerState<RoomDirectory> {
  final List<Map<String, dynamic>> dummyRooms = [
    {
      'id': '1',
      'title': 'Lecture Hall A',
      'subtitle': 'Engineering Faculty',
      'description': 'Main lecture hall with AR projector support',
      'imageUrl': 'https://via.placeholder.com/100x80?text=Room+A',
      'capacity': '150 students',
      'status': 'Active',
      'lastUpdated': '2 hours ago',
    },
    {
      'id': '2',
      'title': 'Computer Lab 1',
      'subtitle': 'Computer Science Dept',
      'description': 'Advanced computer laboratory with VR/AR equipment',
      'imageUrl': 'https://via.placeholder.com/100x80?text=Lab+1',
      'capacity': '40 students',
      'status': 'Active',
      'lastUpdated': '1 day ago',
    },
    {
      'id': '3',
      'title': 'Library Study Room',
      'subtitle': 'Central Library',
      'description': 'Quiet study space with interactive AR books',
      'imageUrl': 'https://via.placeholder.com/100x80?text=Library',
      'capacity': '20 students',
      'status': 'Maintenance',
      'lastUpdated': '3 days ago',
    },
    {
      'id': '4',
      'title': 'Physics Laboratory',
      'subtitle': 'Science Faculty',
      'description': 'Modern physics lab with AR experiments',
      'imageUrl': 'https://via.placeholder.com/100x80?text=Physics',
      'capacity': '30 students',
      'status': 'Active',
      'lastUpdated': '5 hours ago',
    },
    {
      'id': '5',
      'title': 'Art Studio',
      'subtitle': 'Fine Arts Department',
      'description': 'Creative space with AR sculpting tools',
      'imageUrl': 'https://via.placeholder.com/100x80?text=Art',
      'capacity': '25 students',
      'status': 'Active',
      'lastUpdated': '12 hours ago',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              _buildStatItem(
                icon: Icons.meeting_room,
                title: "${dummyRooms.length}",
                subtitle: "Total Rooms",
                color: Colors.blue,
              ),
              const SizedBox(width: 16),
              _buildStatItem(
                icon: Icons.check_circle,
                title: "${dummyRooms.where((room) => room['status'] == 'Active').length}",
                subtitle: "Active",
                color: Colors.green,
              ),
              const SizedBox(width: 16),
              _buildStatItem(
                icon: Icons.build,
                title: "${dummyRooms.where((room) => room['status'] == 'Maintenance').length}",
                subtitle: "Maintenance",
                color: Colors.orange,
              ),
            ],
          ),
        ),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              Icon(Icons.filter_list, color: Colors.grey[600], size: 20),
              const SizedBox(width: 8),
              Text(
                "Filter & Sort",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "All",
                  style: TextStyle(
                    color: Colors.blue[600],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),

        Expanded(
          child: dummyRooms.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: dummyRooms.length,
            itemBuilder: (context, index) {
              final room = dummyRooms[index];
              return _buildRoomCard(room);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoomCard(Map<String, dynamic> room) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.blue[300]!,
                        Colors.blue[500]!,
                      ],
                    ),
                  ),
                  child: const Icon(
                    Icons.meeting_room,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              room['title'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: room['status'] == 'Active'
                                  ? Colors.green.withOpacity(0.1)
                                  : Colors.orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              room['status'],
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: room['status'] == 'Active'
                                    ? Colors.green[700]
                                    : Colors.orange[700],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        room['subtitle'],
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        room['description'],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.people,
                            size: 14,
                            color: Colors.grey[500],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            room['capacity'],
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(
                            Icons.access_time,
                            size: 14,
                            color: Colors.grey[500],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            room['lastUpdated'],
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert,
                    color: Colors.grey[400],
                    size: 20,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  onSelected: (value) {
                    switch (value) {
                      case 'edit':
                        break;
                      case 'delete':
                        break;
                      case 'duplicate':
                        break;
                    }
                  },
                  itemBuilder: (BuildContext context) => [
                    const PopupMenuItem<String>(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 18),
                          SizedBox(width: 8),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'duplicate',
                      child: Row(
                        children: [
                          Icon(Icons.copy, size: 18),
                          SizedBox(width: 8),
                          Text('Duplicate'),
                        ],
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 18, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Delete', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              Icons.meeting_room_outlined,
              size: 48,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "No rooms available",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Add your first room to get started",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}