// import dart package

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

// import other screen
import './screens/category_screen.dart';
import './screens/each_category.dart';
import './screens/home_page.dart';
import './screens/pie_chart.dart';
import './screens/about.dart';

// import provider
import 'providers/transaction.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print("main executes");
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CategoryListProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => TransactionListProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Expense Tracker',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.amber,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: 'Roboto',
        ),
        initialRoute: '/',
        routes: {
          '/': (ctx) => MyHomePage(title: 'Expense Tracker'),
          CategoryScreen.routeName: (ctx) => CategoryScreen(),
          Category.routeName: (ctx) => Category(),
          OverView.routeName: (ctx) => OverView(),
          About.routeName: (ctx) => About(),
        },
      ),
    );
  }
}
