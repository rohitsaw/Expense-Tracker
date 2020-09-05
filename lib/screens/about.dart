import "package:flutter/material.dart";
import 'package:url_launcher/url_launcher.dart';

import '../widgets/drawer.dart';

class About extends StatelessWidget {
  static const routeName = '/about';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: MyDrawer(),
        appBar: AppBar(
          title: Text('About'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Expense Tracker',
              style: TextStyle(
                color: Colors.blueAccent,
                fontFamily: 'Roboto',
                fontSize: 40.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Clean and Easy to Use UI',
              style: TextStyle(
                color: Colors.blueGrey,
                fontFamily: 'Roboto',
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 10,
              width: 200.0,
              child: Divider(
                color: Colors.teal.shade50,
              ),
            ),
            Text(
              'By Rohit',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 20.0,
                letterSpacing: 2.5,
                color: Colors.teal.shade100,
              ),
            ),
            SizedBox(
              height: 10,
              width: 200.0,
              child: Divider(
                color: Colors.teal.shade50,
              ),
            ),
            Card(
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
              color: Colors.white,
              child: ListTile(
                onTap: () {
                  return launch(
                      'https://play.google.com/store/apps/details?id=com.rohitsaw.personal_expenses');
                },
                leading: Icon(
                  Icons.verified_user,
                  color: Colors.teal,
                ),
                title: Text(
                  'Version 1.1.11',
                  style: TextStyle(
                    color: Colors.teal.shade900,
                    fontSize: 20.0,
                  ),
                ),
              ),
            ),
            Card(
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
              color: Colors.white,
              child: ListTile(
                onTap: () => launch('mailto: developer.rohitsaw@gmail.com'),
                leading: Icon(
                  Icons.email,
                  color: Colors.teal,
                ),
                title: Text(
                  'developer.rohitsaw@gmail.com',
                  style: TextStyle(
                    color: Colors.teal.shade900,
                    fontSize: 17.0,
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
