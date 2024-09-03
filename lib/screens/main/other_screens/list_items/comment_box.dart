import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_movie/data/models/comment.dart';
import 'package:my_movie/data/models/user_display_info.dart';

class CommentBox extends StatelessWidget {
  const CommentBox(
      {super.key, required this.comment, required this.userDisplayInfo});
  final Comment comment;
  final UserDisplayInfo userDisplayInfo;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final cardWidth = screenSize.width * 0.85;
    final avatarImage = NetworkImage(userDisplayInfo.avatarPath);

    return GestureDetector(
      onTap: () {
        _showReviewDialog(context);
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: avatarImage,
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: cardWidth - 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userDisplayInfo.displayName,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Divider(
                      color: Theme.of(context).colorScheme.primary,
                      thickness: 1,
                    ),
                    Text(
                      comment.content == null ? '' : comment.content!,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showReviewDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Text(AppLocalizations.of(context)!
                  .reviewBy(userDisplayInfo.displayName)),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(
                  color: Theme.of(context).colorScheme.primary,
                  thickness: 1,
                ),
                Text(comment.content == null ? '' : comment.content!),
                const SizedBox(height: 10),
                Divider(
                  color: Theme.of(context).colorScheme.primary,
                  thickness: 1,
                ),
                Text(
                  AppLocalizations.of(context)!.authorDetails,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Text(AppLocalizations.of(context)!
                    .username(userDisplayInfo.displayName)),
                Text(AppLocalizations.of(context)!.createAt(
                    comment.createdAt
                        .substring(0, 10)
                        .split('-')
                        .reversed
                        .join('/'),
                    comment.createdAt.substring(11, 19))),
              ],
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
