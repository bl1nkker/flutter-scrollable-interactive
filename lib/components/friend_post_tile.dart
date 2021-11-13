import 'package:flutter/material.dart';

import '../components/components.dart';
import '../models/models.dart';

class FriendPostTile extends StatelessWidget {
  final Post post;

  const FriendPostTile({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Create a Row to arrange the widgets horizontally.
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // The first element is a circular avatar,
        //which displays the image asset associated with the post.
        CircleImage(
          imageProvider: AssetImage(post.profileImageUrl),
          imageRadius: 20,
        ),

        const SizedBox(width: 16),
        // Create Expanded, which makes the children fill
        //the rest of the container.
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(post.comment),
              Text(
                '${post.timestamp} mins ago',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
