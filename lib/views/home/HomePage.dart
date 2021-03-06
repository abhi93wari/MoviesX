import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_svg/svg.dart';
import 'package:logging/logging.dart';
import 'package:movie_app/Services/CommonData.dart';
import 'package:movie_app/views/Social/Profile.dart';
import 'package:movie_app/views/Social/SocialMedia.dart';
import 'package:movie_app/views/home/Feed.dart';
import 'package:movie_app/views/profile/profile.dart';
import 'package:movie_app/widgets/SearchBar.dart';
import '../../constants.dart';

class HomePage extends StatefulWidget {
  User user;
  HomePage(this.user);
  @override
  _HomePageState createState() => _HomePageState(user);
}

class _HomePageState extends State<HomePage> {
  final _logger = Logger('com.thesandx.movie_app');
  User user;
  _HomePageState(this.user);
  int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = 0;
  }




  changePage(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      backgroundColor: kTextLightColor,
      body: getCurrentPage(),
      bottomNavigationBar: Container(height: 60, child: BottomNavigationBar()),
    );
  }

  Widget getCurrentPage() {
    if (currentIndex == 1) {
      _logger.info("going to trending page");
      return Feed();
    }
    if(currentIndex==0){
      _logger.info("going to feed page");
      return SocialMedia();
    }
    if(currentIndex==2){
      _logger.info("going to profile page");
      //return ProfileScreen();
      return ProfilPage(url: "https://images.pexels.com/photos/2379005/pexels-photo-2379005.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=100&w=940");
    }
  }

  Widget BottomNavigationBar() {
    const TextStyle style = TextStyle(
        fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black);
    const Color iconColor = Colors.grey;
    const Color iconActiveColor = Colors.black;
    return BubbleBottomBar(
      opacity: 0.2,
      backgroundColor: Colors.white,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(32.0),
        topRight: Radius.circular(32.0),
      ),
      currentIndex: currentIndex,
      hasInk: true,
      inkColor: Colors.black12,
      hasNotch: false, //border radius doesn't work when the notch is enabled.
      onTap: changePage,
      items: [
        BubbleBottomBarItem(
          backgroundColor: Colors.grey,
          icon: Icon(
            Icons.dashboard_outlined,
            color: iconColor,
          ),
          activeIcon: Icon(
            Icons.dashboard_rounded,
            color: iconActiveColor,
          ),
          title: Text('Feed', style: style),
        ),
        BubbleBottomBarItem(
          backgroundColor: Colors.grey,
          icon: Icon(
            Icons.trending_up_rounded,
            color: iconColor,
          ),
          activeIcon: Icon(
            Icons.trending_up,
            color: iconActiveColor,
          ),
          title: Text('Explore', style: style),
        ),
        BubbleBottomBarItem(
          backgroundColor: Colors.grey,
          icon: Icon(
            Icons.account_circle_outlined,
            color: iconColor,
          ),
          activeIcon: Icon(
            Icons.account_circle_rounded,
            color: iconActiveColor,
          ),
          title: Text('Profile', style: style),
        ),
      ],
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      centerTitle: true,
      backgroundColor: Color(0xfff3f5f7),
      elevation: 0,
      leading: IconButton(
        padding: EdgeInsets.only(left: kDefaultPadding),
        icon: SvgPicture.asset("assets/icons/menu.svg"),
        onPressed: () {},
      ),
      title: Text("MoviesX",
          style: Theme.of(context)
              .textTheme
              .headline5
              .copyWith(fontWeight: FontWeight.w800, color: Colors.black)),
      actions: <Widget>[
        IconButton(
          padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
          icon: SvgPicture.asset("assets/icons/search.svg"),
          onPressed: () {
            showSearch(context: context, delegate: MovieSearch());
          },
        ),
      ],
    );
  }
}
