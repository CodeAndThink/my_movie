import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_movie/data/models/movie.dart';
import 'package:my_movie/screens/main/book_ticket/gift_store_screen.dart';
import 'package:my_movie/screens/main/book_ticket/list_cinema_screen.dart';
import 'package:my_movie/screens/main/book_ticket/now_playing_movie_screen.dart';
import 'package:my_movie/screens/main/book_ticket/shopping_list_screen.dart';
import 'package:my_movie/screens/main/home/list_items/large_card.dart';
import 'package:my_movie/screens/main/notifications/notifications_screen.dart';
import 'package:my_movie/screens/main/viewmodel/movie_bloc/main_fetch_movie_by_categories_bloc.dart';
import 'package:my_movie/screens/main/viewmodel/movie_bloc/main_fetch_movie_by_categories_event.dart';
import 'package:my_movie/screens/main/viewmodel/movie_bloc/main_fetch_movie_by_categories_state.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BookTicketScreen extends StatefulWidget {
  const BookTicketScreen({super.key});

  @override
  BookTicketScreenState createState() => BookTicketScreenState();
}

class BookTicketScreenState extends State<BookTicketScreen> {
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
    movieBloc.add(FetchCommonMovieCategory('now_playing', 1));
  }

  Widget _buildLoadingSection() {
    return const SizedBox(
      height: 300,
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _subNavigationButton(
      BuildContext context, IconData icon, Widget widget, String title) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    return SizedBox(
      width: screenWidth * 0.2,
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Column(
          children: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => widget),
                );
              },
              icon: Icon(
                icon,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            Text(
              title,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height * 0.7;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.bookTicket,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                      width: screenWidth,
                      height: screenHeight,
                      child: BlocBuilder<MainFetchMovieByCategoriesBloc,
                          MainFetchMovieByCategoriesState>(
                        builder: (context, state) {
                          if (state is MovieCategoriesLoading) {
                            return _buildLoadingSection();
                          } else if (state is MovieCategoriesLoaded) {
                            final List<Movie> movies = state.nowPlayingMovies;
                            return Stack(
                              children: [
                                PageView.builder(
                                  controller: _pageController,
                                  scrollDirection: Axis.horizontal,
                                  itemCount:
                                      movies.length * _infiniteScrollFactor,
                                  itemBuilder: (context, index) {
                                    final realIndex = index % movies.length;
                                    final movie = movies[realIndex];
                                    return LargeCard(
                                      movie: movie,
                                      width: screenWidth,
                                      height: screenHeight,
                                      onTap: () {},
                                    );
                                  },
                                  onPageChanged: (index) {
                                    final realIndex = index % movies.length;
                                    if (realIndex == 0) {
                                      _pageController.jumpToPage(movies.length *
                                          _infiniteScrollFactor ~/
                                          2);
                                    }
                                  },
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: SmoothPageIndicator(
                                      controller: _pageController,
                                      count: 20,
                                      effect: WormEffect(
                                        dotColor: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        activeDotColor: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        dotHeight: 8,
                                        dotWidth: 10,
                                        spacing: 5,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            );
                          } else if (state is MovieCategoriesFalure) {
                            return Center(
                                child: Text('Error: ${state.message}'));
                          } else {
                            return Center(
                                child: Text(AppLocalizations.of(context)!
                                    .noMoviesAvailable));
                          }
                        },
                      ))),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Card(
                  elevation: 2,
                  child: SizedBox(
                      height: 160,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _subNavigationButton(
                                  context,
                                  FontAwesomeIcons.video,
                                  const NowPlayingMovieScreen(),
                                  AppLocalizations.of(context)!.movie),
                              _subNavigationButton(
                                  context,
                                  FontAwesomeIcons.gifts,
                                  const GiftStoreScreen(),
                                  AppLocalizations.of(context)!.gift),
                              _subNavigationButton(
                                  context,
                                  FontAwesomeIcons.film,
                                  const ListCinemaScreen(),
                                  AppLocalizations.of(context)!.cinema),
                              _subNavigationButton(
                                  context,
                                  FontAwesomeIcons.percent,
                                  const NotificationScreen(),
                                  AppLocalizations.of(context)!.promotion),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _subNavigationButton(
                                  context,
                                  FontAwesomeIcons.cartShopping,
                                  const ShoppingListScreen(),
                                  AppLocalizations.of(context)!.shoppingCart),
                            ],
                          ),
                        ],
                      )),
                ),
              )
            ],
          ),
        ));
  }
}
