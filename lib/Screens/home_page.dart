// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/Providers/movie_provider.dart';
import 'package:myapp/Widgets/movie_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff17082a),
        body: Stack(
          children: [
            Image.asset(
              "assets/bg_bloop.png",
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
            GetBuilder<MovieProvider>(builder: (bloc) {
              return ListView(
                padding: EdgeInsets.only(top: 60, left: 10, right: 10),
                children: [
                  Container(
                      height: 50.0,
                      child: TextField(
                        style: TextStyle(color: Colors.white),
                        onChanged: (value) {
                          bloc.autoComplete(value);
                        },
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(18.0),
                            ),
                            borderSide: BorderSide(
                                color: Color(0xffAAAAAA),
                                width: 1,
                                style: BorderStyle.solid),
                          ),
                          filled: true,
                          fillColor: Color(0xff453954),
                          hintText: 'Search Movie',
                          hintStyle: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w300),
                          prefixIcon:
                              Icon(Icons.search, color: Color(0xffa49eab)),
                        ),
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  for (MovieDrop movie in bloc.dropList)
                    MovieWidget(movie: movie)
                ],
              );
            })
          ],
        ));
  }
}
