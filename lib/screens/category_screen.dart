import 'package:flutter/material.dart';

import '../models/transaction.dart';

import '../widgets/new_category.dart';

class CategoryScreen extends StatefulWidget {
  static const routeName = '/category';

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  Map<String, bool> flag = {};
  Map<String, int> total = {};
  Map<String, int> noOfTransactions = {};
  List<String> localCategories = [];
  List<Transaction> allTransactions = [];
  bool _loadData = false;

  @override
  void didChangeDependencies() {
    if (!_loadData) {
      print('load category data');
      final routeArgs =
          ModalRoute.of(context).settings.arguments as Map<String, Object>;

      allTransactions = routeArgs['alltransactions'] as List<Transaction>;
      total = routeArgs['total'] as Map<String, int>;
      noOfTransactions = routeArgs['noOfTransaction'] as Map<String, int>;
      localCategories = (routeArgs['categories'] as List<String>);
      localCategories.forEach((element) {
        flag[element] = false;
      });
    }
    _loadData = true;
    super.didChangeDependencies();
  }

  void _updateScreen() {
    setState(() {});
  }

  void selectAll() {
    if (flag.containsValue(false)) {
      flag.forEach((key, value) {
        flag[key] = true;
      });
    } else {
      flag.forEach((key, value) {
        flag[key] = false;
      });
    }
  }

  void _addCategory(String cat) {
    print('adding category $cat');
    flag[cat] = false;
    localCategories.add(cat);
    noOfTransactions[cat] = 0;
    total[cat] = 0;
    Navigator.of(context).pop();
  }

  void _deleteCat(String category) {
    print("deleting category $category");
    allTransactions.removeWhere((element) {
      if (element.category == category) {
        return true;
      } else {
        return false;
      }
    });
    localCategories.removeWhere((element) => element == category);
    total.removeWhere((key, value) => key == category);
    noOfTransactions.removeWhere((key, value) => key == category);
  }

  void _deletedSelected() {
    flag.removeWhere((key, value) {
      if (value == true) {
        _deleteCat(key);
        return true;
      } else {
        return false;
      }
    });
  }

  void _startdeleteSelected(BuildContext ctx) {
    showDialog(
        context: ctx,
        barrierDismissible: false,
        builder: (_) {
          return AlertDialog(
            title: Text('Are you sure want to delete?'),
            content: Text(
                'All transactions related to selected category will also be deleted.'),
            elevation: 24.0,
            actions: <Widget>[
              FlatButton(
                child: Text("Yes"),
                onPressed: () {
                  _deletedSelected();
                  Navigator.of(ctx).pop();
                  _updateScreen();
                },
              ),
              FlatButton(
                child: Text("No"),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Widget appBar = AppBar(
      title: Text('Overview'),
      actions: <Widget>[
        FlatButton.icon(
            onPressed: () {
              setState(() {
                selectAll();
              });
            },
            icon: Container(
              decoration: BoxDecoration(
                color: Colors.white54,
              ),
              child: Icon(
                Icons.select_all,
                color: Colors.black,
              ),
            ),
            label: Text('')),
        FlatButton.icon(
            onPressed: () {
              _startdeleteSelected(context);
            },
            icon: Icon(Icons.delete),
            label: Text(''))
      ],
    );

    print('build category page');
    return Scaffold(
      appBar: appBar,
      body: Container(
        padding: EdgeInsets.only(top: 10, left: 10, right: 10),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 3 / 2,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
          ),
          itemBuilder: (ctx, index) {
            return InkWell(
              onDoubleTap: () {
                setState(() {
                  flag[localCategories[index]] = !flag[localCategories[index]];
                });
              },
              onLongPress: () {
                setState(() {
                  flag[localCategories[index]] = !flag[localCategories[index]];
                });
              },
              onTap: () {},
              splashColor: Colors.black54,
              borderRadius: BorderRadius.circular(15),
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      localCategories[index],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      '\u{20B9}${(total[localCategories[index]])}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${(noOfTransactions[localCategories[index]])} transactions',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      if (flag[localCategories[index]] == false) ...[
                        Colors.tealAccent.withOpacity(0.7),
                        Colors.tealAccent
                      ] else ...[
                        Colors.black12,
                        Colors.black54
                      ]
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            );
          },
          itemCount: localCategories.length,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => showModalBottomSheet(
                context: context,
                builder: (_) {
                  return NewCategory(_addCategory, _updateScreen);
                },
              )),
    );
  }
}
