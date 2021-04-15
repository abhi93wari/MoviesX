import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:movie_app/Services/CommonData.dart';
import 'package:movie_app/models/Results.dart';
import 'package:movie_app/models/Show.dart';
import 'package:movie_app/models/TrendingMovies.dart';
import 'package:movie_app/models/movie.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:math' as math;

import '../../constants.dart';

class Feed extends StatefulWidget {
  Feed({Key key}) : super(key: key);

  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {

  PageController _pageController;
  int initialPage;
  CarouselController buttonCarouselController;
  bool _enabled = true;
  //List<Results> movies = new List<Results>();

  Map<String,List<Results>> movieData = new Map();

  @override
  void initState() {
    super.initState();
    initialPage = 0;
    buttonCarouselController = CarouselController();
    _pageController = PageController();

  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: CommonData.findMovieData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          movieData = snapshot.data as Map<String,List<Results>>;
         return SingleChildScrollView(
            child: screen()
          );
        }
        return SingleChildScrollView(
          child: Shimmer.fromColors(
            baseColor: Colors.grey[200],
            highlightColor: Colors.grey[350],
            child: screen()
          ),
        );
      },
    );

  }

  Widget screen(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getHeadLIne(title: "Recent"),
        getSlider(),
        getHeadLIne(title: "Upcoming"),
        getUpcomingMovie(CommonData.upcomingMovies),
        getHeadLIne(title: "Trending"),
        getUpcomingMovie(CommonData.trendingMovies),
        getHeadLIne(title: "Popular"),
        getUpcomingMovie(CommonData.popularMovies),
//        getHeadLIne(title: "Trending Shows"),
//        getUpcomingShows(CommonData.trendingTv),
      ],
    );
  }

  Widget getHeadLIne({String title}){
    return Container(
      margin: EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: Text("${title}",
          style: Theme.of(context)
              .textTheme
              .headline5
              .copyWith(fontWeight: FontWeight.w800, color: Colors.black)),
    );
  }

  Widget getUpcomingMovie(List<Results> movies){
    return Container(
      margin: EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: movies.length,
        itemBuilder: (context, index) => smallMovieCard(movie: movies[index])
      ),
    );

  }

  Widget getUpcomingShows(List<Show> movies){
    return Container(
      margin: EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
      height: 180,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: movies.length,
          itemBuilder: (context, index) => smallTvCard(movie: movies[index])
      ),
    );

  }

  Widget smallMovieCard({Results movie}){
    return Container(
      width:200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 200,
            width: 200,
            padding: EdgeInsets.symmetric(vertical: kDefaultPadding),
            margin: EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: [kDefaultShadow],
              image: DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage(CommonData.tmdb_base_image_url+'w300'+movie.posterPath),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: kDefaultPadding / 2, horizontal: kDefaultPadding),
            child: Text(
              movie.title,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .copyWith(fontWeight: FontWeight.w800),
            ),
          ),


        ],

      ),
    );
  }

  Widget smallTvCard({Show movie}){
    return Container(
      width: 10,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 120,
            width: 120,
            padding: EdgeInsets.symmetric(vertical: kDefaultPadding),
            margin: EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: [kDefaultShadow],
              image: DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage(CommonData.tmdb_base_image_url+'w300'+movie.posterPath),
              ),
            ),
          ),
          Container(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: kDefaultPadding / 2, horizontal: kDefaultPadding),
              child: Text(
                movie.name,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(fontWeight: FontWeight.w800),
              ),
            ),
          ),


        ],

      ),
    );
  }

  Widget getSlider(){
    return CarouselSlider(
      options: CarouselOptions(
          height: MediaQuery.of(context).size.height*0.5,
          enlargeCenterPage: true,
          enlargeStrategy: CenterPageEnlargeStrategy.height,
          enableInfiniteScroll: true
      ),
      items: CommonData.nowPlayingMovies.map((i) {
        return Builder(
          builder: (BuildContext context) {
            return MovieCard(movie: i);
          },
        );
      }).toList(),
    );
  }

  Widget MovieCard({Results movie}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: kDefaultPadding),
            margin: EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              boxShadow: [kDefaultShadow],
              image: DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage(CommonData.tmdb_base_image_url+"w400"+movie.posterPath),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: kDefaultPadding / 2, horizontal: kDefaultPadding),
          child: Text(
            movie.title,
            style: Theme.of(context)
                .textTheme
                .headline5
                .copyWith(fontWeight: FontWeight.w800),
          ),
        ),
//        Padding(
//          padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
//          child: Text(
//            "Action",
//            style: Theme.of(context)
//                .textTheme
//                .bodyText1
//                .copyWith(fontWeight: FontWeight.w200, color: Colors.grey),
//          ),
//        ),
      ],
    );
  }

}
