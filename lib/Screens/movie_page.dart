// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:myapp/Models/Movie.dart';
import 'package:pdf/pdf.dart';
import 'package:myapp/Providers/movie_provider.dart';
import 'package:myapp/Widgets/movie_widget.dart';
import 'package:printing/printing.dart';
import 'package:share/share.dart';

class MovieScreen extends StatefulWidget {
  Movie movie;
  MovieScreen({Key? key, required this.movie}) : super(key: key);

  @override
  _MovieScreenState createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {
  bool likeColor = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff17082a),
        body: GetBuilder<MovieProvider>(builder: (bloc) {
          return ListView(
            padding: EdgeInsets.only(top: 60, left: 10, right: 10),
            children: [
              Container(
                height: 550,
                child: Stack(
                  children: [
                    Container(
                      child: Image.network(
                        widget.movie.image,
                        fit: BoxFit.cover,
                        color: Colors.grey.withOpacity(0.3),
                        colorBlendMode: BlendMode.dstIn,
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                          padding:
                              EdgeInsets.only(left: 20, top: 10, right: 20),
                          child: InkWell(
                              onTap: (() => Get.back()),
                              child: Container(
                                height: 50,
                                width: 50,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.4),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ))),
                    ),
                    Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding:
                              EdgeInsets.only(left: 20, bottom: 100, right: 20),
                          child: Container(
                              height: 120,
                              child: Column(
                                children: [
                                  Text(
                                    "${widget.movie.title}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white,
                                        fontSize: 38),
                                  ),
                                  Row(
                                    children: [
                                      for (String name in widget.movie.genres)
                                        Flexible(
                                            child: Text(
                                          "${name},",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              color:
                                                  Colors.white.withOpacity(0.5),
                                              fontSize: 15),
                                        ))
                                    ],
                                  )
                                ],
                              )),
                        ))
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                      onTap: () async {
                        http.Response response =
                            await http.get(Uri.parse(widget.movie.image));
                        await Printing.layoutPdf(
                            onLayout: (PdfPageFormat format) async =>
                                response.bodyBytes);

                        await Printing.sharePdf(
                            filename: widget.movie.image,
                            bytes: response.bodyBytes);
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Color(0xff210f37).withOpacity(0.4),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        child: Icon(
                          Icons.download,
                          color: Colors.white,
                          size: 20,
                        ),
                      )),
                  InkWell(
                      onTap: (() => setState(() {
                            likeColor = !likeColor;
                          })),
                      child: Container(
                        height: 50,
                        width: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Color(0xff210f37).withOpacity(0.4),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        child: Icon(
                          Icons.favorite,
                          color: likeColor ? Color(0xfff79e44) : Colors.white,
                          size: 20,
                        ),
                      )),
                  InkWell(
                      onTap: () {
                        Share.share(widget.movie.title, subject: "Movie");
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Color(0xff210f37).withOpacity(0.4),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        child: Icon(
                          Icons.share,
                          color: Colors.white,
                          size: 20,
                        ),
                      ))
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Color(0xff210f37),
                    borderRadius: BorderRadius.all(Radius.circular(25))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RatingBar.builder(
                          initialRating: widget.movie.rating / 2,
                          ignoreGestures: true,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            size: 5,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {
                            print(rating);
                          },
                        ),
                        Text(
                          "${widget.movie.rating}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xffF79E44),
                              fontSize: 24),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Internet Movie Database",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          "${widget.movie.rating}/10",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Metacritic",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          "${widget.movie.metaScore}/100",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        )
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Color(0xff210f37),
                    borderRadius: BorderRadius.all(Radius.circular(25))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.calendar_today,
                          color: Color(0xffF79E44),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "${widget.movie.year}",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.timer,
                          color: Color(0xffF79E44),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "${widget.movie.runningTimeInMinutes} Min",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                // height: 600,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Color(0xff210f37),
                    borderRadius: BorderRadius.all(Radius.circular(25))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      Text(
                        "Plot",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w500),
                      )
                    ]),
                    SizedBox(
                      height: 10,
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      Flexible(
                          child: Text(
                        '"${widget.movie.plot}"',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ))
                    ]),
                    SizedBox(
                      height: 20,
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      Text(
                        "Director",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w500),
                      )
                    ]),
                    SizedBox(
                      height: 10,
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      Flexible(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (String name in widget.movie.director)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(7),
                                  decoration: BoxDecoration(
                                      color: Color(0xff37274b),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Text(
                                    name,
                                    style: TextStyle(
                                        color: Color(0xffecbbda), fontSize: 20),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                )
                              ],
                            )
                        ],
                      ))
                    ]),
                    SizedBox(
                      height: 20,
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      Text(
                        "Actors",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w500),
                      )
                    ]),
                    SizedBox(
                      height: 10,
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      Flexible(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (int i = 0; i < widget.movie.actors.length; i++)
                            i < 5
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(7),
                                        decoration: BoxDecoration(
                                            color: Color(0xff37274b),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        child: Text(
                                          widget.movie.actors[i],
                                          style: TextStyle(
                                              color: Color(0xffecbbda),
                                              fontSize: 20),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  )
                                : Container()
                        ],
                      ))
                    ]),
                    SizedBox(
                      height: 20,
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      Text(
                        "Writer",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w500),
                      ),
                    ]),
                    SizedBox(
                      height: 10,
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      Flexible(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (int i = 0; i < widget.movie.writers.length; i++)
                            i < 5
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(7),
                                        decoration: BoxDecoration(
                                            color: Color(0xff37274b),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        child: Text(
                                          widget.movie.writers[i],
                                          style: TextStyle(
                                              color: Color(0xffecbbda),
                                              fontSize: 20),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  )
                                : Container()
                        ],
                      ))
                    ]),
                  ],
                ),
              )
            ],
          );
        }));
  }
}
