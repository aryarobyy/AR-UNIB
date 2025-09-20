part of 'directory.dart';

class BuildingDirectory extends ConsumerStatefulWidget {
  const BuildingDirectory({super.key});

  @override
  ConsumerState createState() => _BuildingDirectoryState();
}

class _BuildingDirectoryState extends ConsumerState<BuildingDirectory> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(buildingNotifierProvider.notifier).getBuildings();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final buildingsData = ref.read(buildingNotifierProvider);
    final state = ref.watch(buildingNotifierProvider);
    final buildings = buildingsData.buildings;

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
                icon: Icons.apartment,
                title: "${buildings.length}",
                subtitle: "Buildings",
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
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "All",
                  style: TextStyle(
                    color: Colors.orange[600],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),

        state.isLoading
            ? const Expanded(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ) : Expanded(
          child: buildings.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: buildings.length,
            itemBuilder: (context, index) {
              final building = buildings[index];
              return _buildBuildingCard(building);
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

  Widget _buildBuildingCard(BuildingModel building) {
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
                                Colors.orange[300]!,
                                Colors.orange[500]!,
                              ],
                            ),
                          ),
                          child: const Icon(
                            Icons.apartment,
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
                            building.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Text(
                    //   building['subtitle'],
                    //   style: TextStyle(
                    //     fontSize: 14,
                    //     color: Colors.orange[600],
                    //     fontWeight: FontWeight.w500,
                    //   ),
                    // ),
                    // const SizedBox(height: 6),
                    Text(
                      building.description ?? "",
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
                      Icons.meeting_room,
                      size: 14,
                      color: Colors.grey[500],
                    ),
                    const SizedBox(width: 4),
                        // Text( //Soon dibikin
                        //   "${building['roomCount']} rooms",
                        //   style: TextStyle(
                        //     fontSize: 11,
                        //     color: Colors.grey[600],
                        //   ),
                        // ),
                        // const SizedBox(width: 16),
                        Icon(
                          Icons.layers,
                          size: 14,
                          color: Colors.grey[500],
                        ),
                        // const SizedBox(width: 4),
                        // Text( //Soon
                        //   "${building.floors} floors",
                        //   style: TextStyle(
                        //     fontSize: 11,
                        //     color: Colors.grey[600],
                        //   ),
                        // ),
                        const SizedBox(width: 16),
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: Colors.grey[500],
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
                            PopupMenuItem<String>(
                              value: 'edit',
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (_) => BuildingEdit(building: building)));
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.edit, size: 18),
                                    SizedBox(width: 8),
                                    Text('Edit'),
                                  ],
                                ),
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
                                  Text(
                                    'Delete',
                                    style: TextStyle(color: Colors.red),
                                  ),
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
              Icons.apartment_outlined,
              size: 48,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "No buildings available",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Add your first building to get started",
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
