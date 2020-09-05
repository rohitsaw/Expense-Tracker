import 'package:flutter/material.dart';

import "../screens/category_screen.dart";
import "../screens/home_page.dart";
import "../screens/pie_chart.dart";
import "../screens/about.dart";

class MyDrawer extends StatelessWidget {
  const MyDrawer();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.purpleAccent,
            ),
            child: Text(
              'Quick Links',
              style: TextStyle(
                color: Colors.white,
                fontSize: 36,
              ),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pop();
              Navigator.pushReplacementNamed(context, MyHomePage.routeName);
            },
            leading: Icon(Icons.home),
            title: Text('Home'),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pop();
              Navigator.pushReplacementNamed(context, CategoryScreen.routeName);
            },
            leading: Icon(Icons.category),
            title: Text('Categories'),
          ),
          ListTile(
            leading: Icon(Icons.pie_chart),
            title: Text('Overview'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.pushReplacementNamed(context, OverView.routeName);
            },
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('About'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.pushReplacementNamed(context, About.routeName);
            },
          ),
        ],
      ),
    );
  }
}
