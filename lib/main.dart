import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

// importing other widgets
import './widgets/chart.dart';
import './widgets/new_transaction.dart';
import './models/transaction.dart';
import './widgets/transaction_list.dart';
import './widgets/new_category.dart';

// import other screen
import './screens/category_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      //home: MyHomePage(title: 'Flutter Demo Home Page'),
      initialRoute: '/',
      routes: {
        '/': (ctx) => MyHomePage(title: 'Flutter Demo Home Page'),
        CategoryScreen.routeName: (ctx) => CategoryScreen(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  MyHomePage({this.title});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ScrollController _scrollController = ScrollController();
  List<Transaction> _allTransaction = [];
  List<Map<String, int>> _lastSevenDays = [];
  DateTime _today = DateTime.now().subtract(Duration(days: 7));
  int _totalLastSevenDays = 0;
  List<String> _categories = [];

  Map<String, int> _noOfTransaction = {};
  Map<String, int> _total = {};
  //Set<String> _categories;

  _MyHomePageState() {
    int test = _today.weekday;
    for (int i = test + 1; i <= 7; i++) {
      _lastSevenDays.add({'day': i, 'amount': 0});
    }
    for (int i = 1; i <= test; i++) {
      _lastSevenDays.add({'day': i, 'amount': 0});
    }
  }

  void _addCategory(String cat) {
    _categories.add(cat);
    _noOfTransaction[cat] = 0;
    _total[cat] = 0;
    Navigator.of(context).pop();
  }

  void _deleteCat(String category) {
    print("deleting $category");
    _allTransaction.removeWhere((element) {
      if (element.category == category) {
        _total[category] -= element.amount;
        _noOfTransaction[category] -= 1;
        return true;
      } else {
        return false;
      }
    });
    _categories.removeWhere((element) => element == category);
  }

  void _changeLastSevenDay() {
    _lastSevenDays = [];
    _totalLastSevenDays = 0;

    DateTime _today = DateTime.now().subtract(
      Duration(days: 7),
    );

    int test = _today.weekday;
    for (int i = test + 1; i <= 7; i++) {
      _lastSevenDays.add({'day': i, 'amount': 0});
    }
    for (int i = 1; i <= test; i++) {
      _lastSevenDays.add({'day': i, 'amount': 0});
    }

    Map<int, int> _lastSevenDaysDetails = {};
    for (int i = _allTransaction.length - 1; i >= 0; i--) {
      if (_allTransaction[i].date.isBefore(_today)) {
        continue;
      }
      if (_lastSevenDaysDetails[_allTransaction[i].date.weekday] == null) {
        _lastSevenDaysDetails[_allTransaction[i].date.weekday] =
            _allTransaction[i].amount;
      } else {
        _lastSevenDaysDetails[_allTransaction[i].date.weekday] +=
            _allTransaction[i].amount;
      }
    }

    _lastSevenDays.forEach((ele) {
      if (_lastSevenDaysDetails[ele['day']] != null) {
        ele['amount'] += _lastSevenDaysDetails[ele['day']];
        _totalLastSevenDays += _lastSevenDaysDetails[ele['day']];
      }
    });

    return;
  }

  void _addTransaction(
      String title, int amount, DateTime date, String category) {
    setState(() {
      _allTransaction.add(
        Transaction(
            title: title, amount: amount, date: date, category: category),
      );
      _total[category] += amount;
      _noOfTransaction[category] += 1;
      _changeLastSevenDay();
    });
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    });
    return;
  }

  void _deleteTransaction(int index) {
    //showDialog(context: null)
    setState(() {
      String category = _allTransaction[index].category;
      int amount = _allTransaction[index].amount;
      _allTransaction.removeAt(index);
      _total[category] -= amount;
      _noOfTransaction[category] -= 1;
      _changeLastSevenDay();
    });
    return;
  }

  void _startAddNewTransaction(BuildContext cntx) {
    showModalBottomSheet(
      context: cntx,
      builder: (_) => (_categories.length != 0)
          ? NewTransaction(_addTransaction, _categories)
          : NewCategory(_addCategory, () {}),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("build main");
    final appBar = AppBar(
      title: Text(widget.title),
      actions: <Widget>[
        FlatButton.icon(
          textColor: Colors.tealAccent,
          onPressed: () {
            Navigator.of(context)
                .pushNamed(CategoryScreen.routeName, arguments: {
              'categories': _categories,
              'total': _total,
              'noOfTransaction': _noOfTransaction,
              'addCat': _addCategory,
              'deleteCat': _deleteCat,
            }).then((value) => setState(() {}));
          },
          label: Text('Details'),
          icon: Icon(Icons.add_circle_outline),
        ),
      ],
    );

    final availHeight = (MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        appBar.preferredSize.height);

    return Scaffold(
        appBar: appBar,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: (availHeight * 0.3),
                  padding: EdgeInsets.all(10),
                  child: Chart(_lastSevenDays, _totalLastSevenDays),
                ),
                Container(
                  height: (availHeight * 0.7),
                  child: TransactionList(
                      _allTransaction, _deleteTransaction, _scrollController),
                ),
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            return _startAddNewTransaction(context);
          },
        ));
  }
}
