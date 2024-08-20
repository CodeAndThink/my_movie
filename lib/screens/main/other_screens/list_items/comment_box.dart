import 'package:flutter/material.dart';
import 'package:my_movie/constain_values/values.dart';
import 'package:my_movie/data/models/auth_detail.dart';
import 'package:my_movie/data/models/review.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CommentBox extends StatelessWidget {
  const CommentBox(
      {super.key, required this.authorDetails, required this.review});
  final AuthorDetails authorDetails;
  final Review review;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final cardWidth = screenSize.width * 0.85;
    final avatarImage = authorDetails.avatarPath?.isEmpty ?? true
        ? const AssetImage('assets/images/man.png') as ImageProvider
        : NetworkImage(
            Values.imageUrl + Values.imageSize + authorDetails.avatarPath!);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: GestureDetector(
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
                        review.author,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Divider(
                        color: Theme.of(context).colorScheme.primary,
                        thickness: 1,
                      ),
                      Text(
                        review.content,
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
      ),
    );
  }

  void _showReviewDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.reviewBy(review.author)),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(
                  color: Theme.of(context).colorScheme.primary,
                  thickness: 1,
                ),
                Text(review.content),
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
                    .username(authorDetails.userName)),
                Text(AppLocalizations.of(context)!.createAt(
                    review.createdAt.toString().split(' ').first,
                    review.createdAt.toString().split(' ')[1].substring(0, 8))),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text(AppLocalizations.of(context)!.close),
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
