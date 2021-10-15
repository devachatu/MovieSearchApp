import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/Models/Movie.dart';
import 'package:myapp/Services/request.dart';

class MovieDrop {
  late String name;
  late String id;
  late String year;
  late String image;
  late int rank;
  MovieDrop(
      {required this.name,
      required this.image,
      required this.id,
      required this.rank,
      required this.year});
}

class MovieProvider extends GetxController {
  List<MovieDrop> dropList = [];

  autoComplete(String search) async {
    var response = await getRequest("auto-complete", query: {"q": search});
    if (response["isSuccess"] ?? false) {
      dropList.clear();
      for (var item in (response["d"] ?? [])) {
        dropList.add(MovieDrop(
            name: item["l"] ?? "",
            id: item["id"] ?? "",
            image: item["i"]["imageUrl"] ?? "",
            year: (item["y"] ?? 0).toString(),
            rank: int.tryParse((item["rank"] ?? 0).toString()) ?? 0));
      }
      update();
    }
  }

  getMovie(String id) async {
    var response = await getRequest("title/get-overview-details", query: {
      "tconst": id,
    });
    var resp = await getRequest("title/get-meta-data", query: {
      "ids": id,
    });
    var res = await getRequest("title/get-full-credits", query: {
      "tconst": id,
    });
    if (res["isSuccess"] && resp["isSuccess"] && response["isSuccess"]) {
      Movie movie = Movie(
          title: response["title"]["title"],
          id: response["title"]["id"],
          image: response["title"]["image"]["url"],
          runningTimeInMinutes: response["title"]["runningTimeInMinutes"],
          titleType: response["title"]["titleType"],
          year: response["title"]["year"],
          rating: response["ratings"]["rating"],
          genres: [for (var item in response["genres"]) item],
          plot: response["plotSummary"]["text"],
          metaScore: resp[id]["metacritic"]["metaScore"],
          actors: [for (var item in res["cast"]) item["name"]],
          director: [for (var item in res["crew"]["director"]) item["name"]],
          writers: [for (var item in res["crew"]["producer"]) item["name"]]);
      return movie;
    }
  }
}
