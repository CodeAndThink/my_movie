import 'package:flutter/material.dart';
import 'package:my_movie/constain_values/values.dart';
import 'package:my_movie/data/models/cast.dart';
import 'package:my_movie/data/models/crew.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CastAndCrewScreen extends StatelessWidget {
  final dynamic credit;
  final bool isCast;

  const CastAndCrewScreen(
      {super.key, required this.credit, required this.isCast});

  @override
  Widget build(BuildContext context) {
    final Cast? cast = isCast ? Cast.fromJson(credit) : null;
    final Crew? crew = !isCast ? Crew.fromJson(credit) : null;

    final String? profilePath = isCast ? cast?.profilePath : crew?.profilePath;
    final String name =
        isCast ? cast?.name ?? 'Unknown' : crew?.name ?? 'Unknown';
    final String originalName =
        isCast ? cast?.originalName ?? '' : crew?.originalName ?? '';
    final String character = isCast ? cast?.character ?? '' : '';
    final String job = !isCast ? crew?.job ?? '' : '';
    final String department = !isCast ? crew?.department ?? '' : '';
    final String order = isCast ? cast?.order.toString() ?? '' : '';
    final int castId = isCast ? cast?.castId ?? 0 : 0;
    final String creditId = !isCast ? crew?.creditId ?? '0' : '0';

    return Scaffold(
        appBar: AppBar(
          title: Text(
            name,
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 10,
                  child: Center(
                    child: Stack(
                      children: [
                        Container(
                          color: Theme.of(context).colorScheme.surface,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Center(
                            child: ClipOval(
                              child: Image.network(
                                '${Values.imageUrl}${Values.imageSize}$profilePath',
                                width: 150,
                                height: 150,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 150,
                                    height: 150,
                                    color: Colors.grey,
                                    child: const Icon(
                                      Icons.person,
                                      size: 60,
                                      color: Colors.white,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Column(
                    children: [
                      Divider(
                        color: Theme.of(context).colorScheme.primary,
                        thickness: 1,
                      ),
                      Text(
                        AppLocalizations.of(context)!.name(name),
                        style: Theme.of(context).textTheme.bodyMedium,
                        overflow: TextOverflow.clip,
                      ),
                      Divider(
                        color: Theme.of(context).colorScheme.primary,
                        thickness: 1,
                      ),
                      if (originalName.isNotEmpty)
                        Text(
                          AppLocalizations.of(context)!
                              .originalName(originalName),
                          style: Theme.of(context).textTheme.bodyMedium,
                          overflow: TextOverflow.clip,
                        ),
                      Divider(
                        color: Theme.of(context).colorScheme.primary,
                        thickness: 1,
                      ),
                      if (isCast)
                        Text(
                          AppLocalizations.of(context)!.character(character),
                          style: Theme.of(context).textTheme.bodyMedium,
                          overflow: TextOverflow.clip,
                        )
                      else
                        Text(
                          AppLocalizations.of(context)!.job(job),
                          style: Theme.of(context).textTheme.bodyMedium,
                          overflow: TextOverflow.clip,
                        ),
                      if (!isCast && department.isNotEmpty)
                        Text(
                          AppLocalizations.of(context)!
                              .departmentLabel(department),
                          style: Theme.of(context).textTheme.bodyMedium,
                          overflow: TextOverflow.clip,
                        ),
                      Divider(
                        color: Theme.of(context).colorScheme.primary,
                        thickness: 1,
                      ),
                      if (isCast && order.isNotEmpty)
                        Text(
                          AppLocalizations.of(context)!.orderLabel(order),
                          style: Theme.of(context).textTheme.bodyMedium,
                          overflow: TextOverflow.clip,
                        ),
                      Divider(
                        color: Theme.of(context).colorScheme.primary,
                        thickness: 1,
                      ),
                      if (isCast)
                        Text(
                          AppLocalizations.of(context)!.castIdLabel(castId),
                          style: Theme.of(context).textTheme.bodyMedium,
                          overflow: TextOverflow.clip,
                        ),
                      Divider(
                        color: Theme.of(context).colorScheme.primary,
                        thickness: 1,
                      ),
                      if (!isCast)
                        Text(
                          AppLocalizations.of(context)!.creditIdLabel(creditId),
                          style: Theme.of(context).textTheme.bodyMedium,
                          overflow: TextOverflow.clip,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
