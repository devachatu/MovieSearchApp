class Movie {
  Movie({
    required this.id,
    required this.title,
    required this.image,
    required this.titleType,
    required this.year,
    required this.director,
    required this.plot,
    required this.actors,
    required this.writers,
    required this.genres,
    required this.rating,
    required this.metaScore,
    required this.runningTimeInMinutes,
  });
  String id;
  String title;
  String image;
  String titleType;
  int runningTimeInMinutes;
  int year;
  List<String> director;
  String plot;
  List<String> actors;
  List<String> writers;
  List<String> genres;
  double rating;
  int metaScore;

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
        id: json['id'] ?? "",
        title: json['title'] ?? "",
        image: json['image'] ?? "",
        titleType: json['titleType'] ?? "",
        year: json['year'] ?? "",
        director: List.castFrom<dynamic, String>(json['director'] ?? []),
        plot: json['plot'] ?? "",
        actors: List.castFrom<dynamic, String>(json['actors'] ?? []),
        writers: List.castFrom<dynamic, String>(json['writers'] ?? []),
        genres: List.castFrom<dynamic, String>(json['genres'] ?? []),
        rating: json['rating'] ?? 0,
        runningTimeInMinutes: json["runningTimeInMinutes"] ?? 0,
        metaScore: json['metaScore'] ?? 0);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['title'] = title;
    _data['image'] = image;
    _data['titleType'] = titleType;
    _data['year'] = year;
    _data['director'] = director;
    _data['plot'] = plot;
    _data['actors'] = actors;
    _data['writers'] = writers;
    _data['genres'] = genres;
    _data['rating'] = rating;
    _data['metaScore'] = metaScore;
    _data["runningTimeInMinutes"] = runningTimeInMinutes;
    return _data;
  }
}

  //  {
//     "id":"/title/tt0848228/",
//     "title":"The Avengers",
//     "image":"",
//     "titleType":"movie",
//     "year":2012,
//     "director":["",""],
//     "plot":"",
//     "actors":[""],
//     "writers":[""],
//     "genres":[""],
//     "rating":9.2,
//     "metaScore":69

// }