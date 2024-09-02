class Values {
  static const appName = "Movie Wiki";
  static const apiKey = "f8a716cb151ec10828e121a80305f51e";
  static const baseUrl = "https://api.themoviedb.org/";
  static const language = "en-US";
  static const page = 1;
  static const includeAdult = "false";
  static const imageSmall = "w500";
  static const imageUrl = "https://image.tmdb.org/t/p/";
  static const youtubeUrl = "https://www.youtube.com/embed/";
  static const authHeader =
      "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJmOGE3MTZjYjE1MWVjMTA4MjhlMTIxYTgwMzA1ZjUxZSIsIm5iZiI6MTcyMzAyODk3OS4zODIyNzksInN1YiI6IjY2ODE0MzU4NWNkMDlkN2ExMjQ3ZGE2OSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.2sNwk1nOJqPxmXnKhJBpFjL2w-AWf5NV7_t0UIsJ3cw";
}

enum NotificationTopic {
  newsUpdates('news_updates'),
  sportsScores('sports_scores'),
  offersPromo('offers_promo'),
  locationNewYork('location_newyork');

  final String name;

  const NotificationTopic(this.name);
}
