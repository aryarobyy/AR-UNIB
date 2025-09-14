import 'package:ar_unib/pages/admin/add/add_room.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Admin extends ConsumerStatefulWidget {
  const Admin({super.key});

  @override
  ConsumerState createState() => _AdminState();
}

class _AdminState extends ConsumerState<Admin> {
  @override
  Widget build(BuildContext context) {
    return AddRoom();
  }
}
