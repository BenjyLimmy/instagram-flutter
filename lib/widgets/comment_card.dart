import 'package:flutter/material.dart';
import 'package:instagram_flutter/models/user.dart' as model;
import 'package:instagram_flutter/providers/user_provider.dart';
import 'package:instagram_flutter/resources/firestore_methods.dart';
import 'package:instagram_flutter/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CommentCard extends StatefulWidget {
  final Map<String, dynamic> snap;
  const CommentCard({super.key, required this.snap});

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    model.User? user = Provider.of<UserProvider>(context).getUser;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(widget.snap['profilePic']),
            radius: 18,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: widget.snap['name'],
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      TextSpan(
                          text: ' ${widget.snap['text']}',
                          style: const TextStyle(color: Colors.white)),
                    ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      DateFormat.yMMMd()
                          .format(widget.snap['datePublished'].toDate()),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Column(
            children: [
              LikeAnimation(
                isAnimating: (widget.snap['likes'] as List).contains(user!.uid),
                smallLike: true,
                child: GestureDetector(
                  onTap: () async {
                    await FirestoreMethods().likeComment(
                      widget.snap['postId'],
                      widget.snap['commentId'],
                      user.uid,
                      widget.snap['likes'],
                    );
                  },
                  child: (widget.snap['likes'] as List).contains(user.uid)
                      ? const Icon(
                          Icons.favorite,
                          size: 16,
                          color: Colors.red,
                        )
                      : const Icon(Icons.favorite_border, size: 16),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Text(
                  (widget.snap['likes'] as List).length.toString(),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
