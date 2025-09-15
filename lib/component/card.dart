import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyCard extends ConsumerStatefulWidget {
  final String title;
  final String? subtitle;
  final String? imageUrl;

  const MyCard({
    super.key,
    required this.title,
    this.imageUrl,
    this.subtitle
  });

  @override
  ConsumerState createState() => _MyCardState();
}

class _MyCardState extends ConsumerState<MyCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 3,
      child: InkWell(
        // onTap: () {
        //   Navigator.push(context, MaterialPageRoute(builder: (_) => _));
        // },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: widget.imageUrl != null ?
                  Image.network(
                    widget.imageUrl!,
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                  )
                  : Image.asset(
                    "assets/google.png",
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.subtitle ?? "",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),

              IconButton(
                icon: const Icon(
                  CupertinoIcons.pencil,
                  color: Colors.amber,
                ),
                onPressed: () {

                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}