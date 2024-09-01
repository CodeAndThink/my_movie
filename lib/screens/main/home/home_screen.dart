import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_movie/data/models/movie.dart';
import 'package:my_movie/screens/main/home/list_items/large_card.dart';
import 'package:my_movie/screens/main/home/list_view/movie_sections.dart';
import 'package:my_movie/screens/main/notifications/notifications_screen.dart';
import 'package:my_movie/screens/main/other_screens/movie_detail_screen.dart';
import 'package:my_movie/screens/main/search/search_screen.dart';
import 'package:my_movie/screens/main/viewmodel/movie_bloc/movie_bloc.dart';
import 'package:my_movie/screens/main/viewmodel/movie_bloc/movie_event.dart';
import 'package:my_movie/screens/main/viewmodel/movie_bloc/movie_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  late final PageController _pageController;
  final int _infiniteScrollFactor = 20;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 1.0,
    );
    _loadAllCategories();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _loadAllCategories() {
    (context).read<MovieBloc>().add(LoadMoviesByCategories('popular', 1));
    (context).read<MovieBloc>().add(LoadMoviesByCategories('top_rated', 1));
    (context).read<MovieBloc>().add(LoadMoviesByCategories('now_playing', 1));
    (context).read<MovieBloc>().add(LoadMoviesByCategories('upcoming', 1));
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    return Scaffold(
      appBar: AppBar(
        title: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: screenWidth * 0.6),
          child: Text(
            AppLocalizations.of(context)!.welcome,
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search,
                color: Theme.of(context).colorScheme.primary),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SearchScreen())),
          ),
          IconButton(
            icon: Icon(Icons.notifications,
                color: Theme.of(context).colorScheme.primary),
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const NotificationsScreen())),
          ),
        ],
      ),
      body: Center(
        child: BlocBuilder<MovieBloc, MovieState>(
          builder: (context, state) {
            if (state is MovieLoading) {
              return const CircularProgressIndicator();
            } else if (state is MovieLoaded) {
              return CustomScrollView(
                slivers: [
                  _buildMovieSection('Popular movies:', state.popularMovies),
                  _buildMovieSection(
                      '${AppLocalizations.of(context)!.topRatedMovies}:',
                      state.topRatedMovies),
                  _buildMovieSection(
                      '${AppLocalizations.of(context)!.nowPlayingMovies}:',
                      state.nowPlayingMovies),
                  _buildMovieSection(
                      '${AppLocalizations.of(context)!.upcomingMovies}:',
                      state.upcomingMovies),
                ],
              );
            } else if (state is MovieError) {
              return Text('Error: ${state.message}');
            } else {
              return const Text('No data available');
            }
          },
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildMovieSection(String title, List<Movie> movies) {
    final screenSize = MediaQuery.of(context).size;
    final cardWidth = screenSize.width;
    final cardHeight = screenSize.height * 0.7;
    final itemCount = movies.length;

    if (title == 'Popular movies:') {
      return SliverToBoxAdapter(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: cardWidth,
          height: cardHeight,
          child: PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.horizontal,
            itemCount: itemCount * _infiniteScrollFactor,
            itemBuilder: (context, index) {
              final realIndex = index % itemCount;
              final movie = movies[realIndex];
              return LargeCard(
                movie: movie,
                width: cardWidth,
                height: cardHeight,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          MovieDetailScreen(movieId: movie.id),
                    ),
                  );
                },
              );
            },
            onPageChanged: (index) {
              final realIndex = index % itemCount;
              if (realIndex == 0) {
                _pageController
                    .jumpToPage(itemCount * _infiniteScrollFactor ~/ 2);
              }
            },
          ),
        ),
      ));
    } else {
      return SliverToBoxAdapter(
        child: MoviesSection(
          title: title,
          movies: movies,
          onCardTap: (movie) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MovieDetailScreen(movieId: movie.id),
              ),
            );
          },
        ),
      );
    }
  }
}
