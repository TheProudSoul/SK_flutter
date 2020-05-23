import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:super_knowledge/bloc/bloc.dart';
import 'package:super_knowledge/common/operations.dart';
import 'package:super_knowledge/screens/profile_screen.dart';
import 'package:super_knowledge/screens/settings_screen.dart';

import 'category_screen.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  MenuItem item1 = new MenuItem(
      title: "Knowledge Base",
      img: "assets/wisdom.png");
  MenuItem item2 = new MenuItem(
    title: "PicBed",
    img: "assets/image.png",
  );
  MenuItem item3 = new MenuItem(
    title: "To do",
    img: "assets/to-do.png",
  );
  MenuItem item4 = new MenuItem(
    title: "Settings",
    img: "assets/tools.png",
  );
  MenuItem item5 = new MenuItem(
    title: "Profile",
    img: "assets/man.png",
  );
  MenuItem item6 = new MenuItem(
    title: "About",
    img: "assets/about.png",
  );

  void menuRoute(String item) {
    switch(item) {
      case("Knowledge Base"): {
        Navigator.push(context, MaterialPageRoute<Null>(
            builder: (BuildContext context) => BlocProvider(
                create: (context) => FileSystemBloc(),
                child: CategoryScreen())));
        break;
      }
      case("Profile"): {
        Navigator.push(context, MaterialPageRoute<Null>(
            builder: (BuildContext context) => ProfileScreen()));
        break;
      }
      case("PicBed"): {
        Operations.showUnimplementedMessage(context); break;
      }
      case("About"): {
        Operations.showUnimplementedMessage(context); break;
      }
      case("To do"): {
        Operations.showUnimplementedMessage(context); break;
      }
      case("Settings"): {
        Navigator.push(context, MaterialPageRoute<Null>(
            builder: (BuildContext context) => SettingsScreen()));
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<MenuItem> menuList = [item1, item2, item3, item4, item5, item6];
    var color = 0xFF61A4F1;
    return Scaffold(
      backgroundColor: Color(0xFF398AE5),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 110,
          ),
          Padding(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Super Knowledge",
                  style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold)),
                )
              ],
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Flexible(
            child: GridView.count(
                childAspectRatio: 1.0,
                padding: EdgeInsets.only(left: 16, right: 16),
                crossAxisCount: 2,
                crossAxisSpacing: 18,
                mainAxisSpacing: 18,
                children: menuList.map((data) {
                  return GestureDetector(
                    onTap: () => menuRoute(data.title),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color(color),
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            data.img,
                            width: 42,
                          ),
                          SizedBox(
                            height: 14,
                          ),
                          Text(
                            data.title,
                            style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList()),
          )
        ],
      ),
    );
  }
}

class MenuItem {
  String title;
  String img;
  MenuItem({this.title, this.img});
}
