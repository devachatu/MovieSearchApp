import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/Models/Movie.dart';
import 'package:myapp/Providers/movie_provider.dart';
import 'package:myapp/Screens/movie_page.dart';

class MovieWidget extends StatefulWidget {
  MovieDrop movie;
  MovieWidget({Key? key, required this.movie}) : super(key: key);

  @override
  _MovieWidgetState createState() => _MovieWidgetState();
}

class _MovieWidgetState extends State<MovieWidget> {
  MovieProvider bloc = Get.find();
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () async {
          Movie movie = await bloc.getMovie(widget.movie.id);

          Get.to(() => MovieScreen(
                movie: movie,
              ));
        },
        child: Container(
            height: 300,
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 200,
                      child: Stack(
                        children: [
                          Container(
                              width: Get.width,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(25.0),
                                child: Image.network(
                                  widget.movie.image,
                                  fit: BoxFit.cover,
                                ),
                              )),
                          Padding(
                            padding: EdgeInsets.only(top: 24, left: 15),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                height: 20,
                                width: 85,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.transparent.withOpacity(0.6),
                                ),
                                child: Center(
                                    child: Text("Rank: ${widget.movie.rank}",
                                        style: TextStyle(color: Colors.white))),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                        height: 99,
                        padding: EdgeInsets.all(15),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: [
                                Flexible(
                                  child: Text(widget.movie.name,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500)),
                                )
                              ]),
                              SizedBox(height: 10),
                              Row(children: [
                                Image.asset(
                                  "assets/Group_356.png",
                                  height: 15,
                                  width: 15,
                                  color: Color(0xff815325),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(widget.movie.year,
                                    style: TextStyle(
                                        color: Color(0xff815325),
                                        fontWeight: FontWeight.w500))
                              ]),
                            ],
                          ),
                        ))
                  ],
                ),
              ],
            )));
  }
}
