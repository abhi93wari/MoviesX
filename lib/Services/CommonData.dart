import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_app/models/Results.dart';
import 'package:movie_app/models/Show.dart';
import 'package:movie_app/models/TrendingMovies.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/models/TrendingShows.dart';

class CommonData{

  static   bool isLoading = false;

  static String tmdb_api_key;

  static String image_NA = "https://1.bp.blogspot.com/-JXjPS9M7MMU/XX39ZP97p4I/AAAAAAAAABE/VQYxrz_roLcXRf5m1nyxTYIxFh7KGow7wCPcBGAYYCw/s1600/df1.jpg";

  static String tmdb_base_url = "https://api.themoviedb.org/3/";
  static String tmdb_base_image_url = "https://image.tmdb.org/t/p/";
  static String language = "&language=en-US"; //hi-IN,en-US,en-IN
  static String region= "&region=US"; //in or us in caps

  static List<Results> trendingMovies = new List<Results>();
  static List<Results> nowPlayingMovies = new List<Results>();
  static List<Results> upcomingMovies = new List<Results>();
  static List<Results> popularMovies = new List<Results>();
  static List<Show> trendingTv = new List<Show>();

  static Map<int,bool> likedMovies = new Map();



  static Future<void> findMovieData() async{
    trendingMovies = await findTrendingMovies();
    //trendingTv = await findTrendingShows();
    nowPlayingMovies = await findNowPlayingMovies();
    upcomingMovies = await findUpcomingMovies();
    popularMovies = await findPopularMovies();
    return;

  }


  static Future<List<Results>> findPopularMovies() async{
    var url = Uri.parse(tmdb_base_url+'movie/popular?api_key='+tmdb_api_key+language+region);
    print(url);
    var response = await http.get(url);
    print('Response status: ${response.statusCode}');
    // print('Response body: ${response.body}');
    var data = response.body;


    var myjson = jsonDecode(data);
    //print(myjson);
    TrendingMovies trendingMovies = TrendingMovies.fromJson(myjson);
    print(trendingMovies.results.length);
    return trendingMovies.results;

  }


  static Future<List<Results>> findUpcomingMovies() async{
    var url = Uri.parse(tmdb_base_url+'movie/upcoming?api_key='+tmdb_api_key+language+region);
    print(url);
    var response = await http.get(url);
    print('Response status: ${response.statusCode}');
    // print('Response body: ${response.body}');
    var data = response.body;


    var myjson = jsonDecode(data);
    //print(myjson);
    TrendingMovies trendingMovies = TrendingMovies.fromJson(myjson);
    print(trendingMovies.results.length);
    return trendingMovies.results;

  }

  static Future<List<Results>> findNowPlayingMovies() async{
    var url = Uri.parse(tmdb_base_url+'movie/now_playing?api_key='+tmdb_api_key+language+region);
    print(url);
    var response = await http.get(url);
    print('Response status: ${response.statusCode}');
    // print('Response body: ${response.body}');
    var data = response.body;


    var myjson = jsonDecode(data);
    //print(myjson);
    TrendingMovies trendingMovies = TrendingMovies.fromJson(myjson);
    print(trendingMovies.results.length);
    return trendingMovies.results;

  }

  static Future<List<Results>> findTrendingMovies() async{
    var url = Uri.parse(tmdb_base_url+'trending/movie/day?api_key='+tmdb_api_key);
    print(url);
    var response = await http.get(url);
    print('Response status: ${response.statusCode}');
   // print('Response body: ${response.body}');
    var data = response.body;


    var myjson = jsonDecode(data);
    //print(myjson);
   TrendingMovies trendingMovies = TrendingMovies.fromJson(myjson);
    print(trendingMovies.results.length);
    return trendingMovies.results;

  }

  static Future<List<Show>> findTrendingShows() async{
    var url = Uri.parse(tmdb_base_url+'trending/tv/day?api_key='+tmdb_api_key);
    print(url);
    var response = await http.get(url);
    print('Response status: ${response.statusCode}');
    // print('Response body: ${response.body}');
    var data = response.body;


    var myjson = jsonDecode(data);
    //print(myjson);
    TrendingShows trendingShows = TrendingShows.fromJson(myjson);
    print(trendingShows.results.length);
    return trendingShows.results;

  }

  static Future<bool> retriveAPIKey() async{
    CollectionReference tmdb = FirebaseFirestore.instance.collection('TMDB');

    DocumentSnapshot documentSnapshot = await tmdb.doc("tmdb_api_key").get();
    if(documentSnapshot.exists){
      print("api_key mil gya");
      //print(documentSnapshot.data());
      tmdb_api_key = documentSnapshot.data()['v3_auth'];



      return true;
    }
    else{
      return false;
    }


  }

  static Future<dynamic> fetchProfileData() async{

    CollectionReference users = FirebaseFirestore.instance.collection('users');
    //check if doc exists
    DocumentSnapshot documentSnapshot = await users.doc(FirebaseAuth.instance.currentUser.uid).get();
    if(documentSnapshot.exists){
      print(documentSnapshot.data());
      return documentSnapshot.data();
    }
    else{
      return null;
    }

  }
  static Future<bool> isUsernameAvailable(String username) async {

    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('users')
        .where('user_name', isEqualTo: username)
        .limit(1)
        .get();
    final List<QueryDocumentSnapshot> documents = result.docs;
    return documents.length == 1;
  }

  static Stream<Map<int,bool>> streamlikeValue() async*{

          yield CommonData.likedMovies;

  }

  static Future<void> getLikedMovies(User user) async{
    likedMovies.clear();
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('/users/'+user.uid+'/movies')
        .get();

    querySnapshot.docs.forEach((doc) {
      likedMovies[doc["movie_id"]] = doc["liked"];
    });
    streamlikeValue();




    //Provider.of<MovieProvider>(context).setChange(likedMovies);

  }

  static Future<bool> addLikedMovie(User user,int movie_id,bool liked) async{
    CollectionReference movies = FirebaseFirestore.instance.collection('/users/'+user.uid+'/movies');
    //check if movieid exists
    DocumentSnapshot documentSnapshot = await movies.doc(movie_id.toString()).get();
    if(documentSnapshot.exists){
      print(documentSnapshot.data());
        print("detail exists");
        await movies.doc(movie_id.toString()).update({
          "liked":liked,
          "movie_id":movie_id
        }).then((value) async{
          print("Movie added successfully "+movie_id.toString());
         await getLikedMovies(user);
          return true;
        }).catchError((error){
          print("Failed to add movie: $error");
          return false;
        });

    }
    else{
      //create moviedid
      //add movie
      await movies.doc(movie_id.toString()).set({
        "liked":liked,
        "movie_id":movie_id
      }).then((value) async{
        print("Movie added successfully "+movie_id.toString());
        await getLikedMovies(user);
        return true;
      }).catchError((error){
        print("Failed to add movie: $error");
        return false;
      });
    }
  }

  static Future<bool> checkIfUserDetailExists(User user) async{

    CollectionReference users = FirebaseFirestore.instance.collection('users');
    //check if doc exists
    DocumentSnapshot documentSnapshot = await users.doc(user.uid).get();
    if(documentSnapshot.exists){
      print(documentSnapshot.data());
      if(documentSnapshot.data()['user_name']==null || documentSnapshot.data()['user_name'].toString().length<1){
        print("detail not exists");
        return false;
      }
      else{
        print("detail exists");
        return true;
      }
    }
    else{
      return false;
    }
  }

  static Future<bool> checkIfUserExists(User user) async{

    CollectionReference users = FirebaseFirestore.instance.collection('users');
    //check if doc exists
    DocumentSnapshot documentSnapshot = await users.doc(user.uid).get();
    if(documentSnapshot.exists){
      print("user exists");
      return true;
    }
    else{
      print("user does not exists");
      return false;
    }
  }




  static Future<bool> createUser(User user) async{
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    //check if user exists
    DocumentSnapshot documentSnapshot = await users.doc(user.uid).get();
    if(!documentSnapshot.exists){
      //if not then add the doc
      await users
          .doc(user.uid)
          .set({
        "mobile":user.phoneNumber
      }).then((value) {
        print("user added in db");
        return true;
      })
          .catchError((error){
            print("Error:failed to add user"+error.toString());
            return false;
      });

    }
    else{
      print("user already hai");
      return true;
      //check if
    }
  }

  static Future<bool> addUserData(String name,String username){
    final FirebaseAuth auth = FirebaseAuth.instance;
    User user  = auth.currentUser;
    if(user==null){
      print("Error : user null hai");
    }


      CollectionReference users = FirebaseFirestore.instance.collection('users');
      users.doc(user.uid).update({
          "name":name,
          "user_name":username
      }).then((value){
        print("detail added ");
        return true;
      }).
        catchError((error) {
          print("Failed to add user: $error");
          return false;
      });

    }

}