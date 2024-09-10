import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_movie/data/models/movie.dart';
import 'package:my_movie/screens/main/home/list_items/large_card.dart';
import 'package:my_movie/screens/main/home/list_view/movie_sections.dart';
import 'package:my_movie/screens/main/notifications/notifications_screen.dart';
import 'package:my_movie/screens/main/other_screens/movie_detail_screen.dart';
import 'package:my_movie/screens/main/search/search_screen.dart';
import 'package:my_movie/screens/main/viewmodel/movie_bloc/main_fetch_movie_by_categories_bloc.dart';
import 'package:my_movie/screens/main/viewmodel/movie_bloc/main_fetch_movie_by_categories_event.dart';
import 'package:my_movie/screens/main/viewmodel/movie_bloc/main_fetch_movie_by_categories_state.dart';
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

  void _loadAllCategories() {
    final movieBloc = context.read<MainFetchMovieByCategoriesBloc>();
    movieBloc.add(FetchCommonMovieCategory('popular', 1));
    movieBloc.add(FetchCommonMovieCategory('top_rated', 1));
    movieBloc.add(FetchCommonMovieCategory('now_playing', 1));
    movieBloc.add(FetchCommonMovieCategory('upcoming', 1));
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
                    builder: (context) => const NotificationScreen())),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          BlocBuilder<MainFetchMovieByCategoriesBloc,
              MainFetchMovieByCategoriesState>(
            builder: (context, state) {
              if (state is MovieCategoriesLoading) {
                return _buildLoadingSection();
              } else if (state is MovieCategoriesLoaded) {
                return _buildMovieSection(
                    'Popular movies:', state.popularMovies);
              } else if (state is MovieCategoriesFalure) {
                return SliverToBoxAdapter(
                  child: Center(child: Text('Error: ${state.message}')),
                );
              } else {
                return const SliverToBoxAdapter(
                  child: Center(child: Text('No data available')),
                );
              }
            },
          ),
          BlocBuilder<MainFetchMovieByCategoriesBloc,
              MainFetchMovieByCategoriesState>(
            builder: (context, state) {
              if (state is MovieCategoriesLoading) {
                return _buildLoadingSection();
              } else if (state is MovieCategoriesLoaded) {
                return _buildMovieSection(
                    '${AppLocalizations.of(context)!.topRatedMovies}:',
                    state.topRatedMovies);
              } else if (state is MovieCategoriesFalure) {
                return SliverToBoxAdapter(
                  child: Center(child: Text('Error: ${state.message}')),
                );
              } else {
                return const SliverToBoxAdapter(
                  child: Center(child: Text('No data available')),
                );
              }
            },
          ),
          BlocBuilder<MainFetchMovieByCategoriesBloc,
              MainFetchMovieByCategoriesState>(
            builder: (context, state) {
              if (state is MovieCategoriesLoading) {
                return _buildLoadingSection();
              } else if (state is MovieCategoriesLoaded) {
                return _buildMovieSection(
                    '${AppLocalizations.of(context)!.nowPlayingMovies}:',
                    state.nowPlayingMovies);
              } else if (state is MovieCategoriesFalure) {
                return SliverToBoxAdapter(
                  child: Center(child: Text('Error: ${state.message}')),
                );
              } else {
                return const SliverToBoxAdapter(
                  child: Center(child: Text('No data available')),
                );
              }
            },
          ),
          BlocBuilder<MainFetchMovieByCategoriesBloc,
              MainFetchMovieByCategoriesState>(
            builder: (context, state) {
              if (state is MovieCategoriesLoading) {
                return _buildLoadingSection();
              } else if (state is MovieCategoriesLoaded) {
                return _buildMovieSection(
                    '${AppLocalizations.of(context)!.upcomingMovies}:',
                    state.upcomingMovies);
              } else if (state is MovieCategoriesFalure) {
                return SliverToBoxAdapter(
                  child: Center(child: Text('Error: ${state.message}')),
                );
              } else {
                return const SliverToBoxAdapter(
                  child: Center(child: Text('No data available')),
                );
              }
            },
          ),
        ],
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

  SliverToBoxAdapter _buildLoadingSection() {
    return const SliverToBoxAdapter(
      child: SizedBox(
        height: 300,
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
