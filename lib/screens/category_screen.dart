import 'package:flutter/material.dart';

import '../widgets/new_category.dart';

class CategoryScreen extends StatefulWidget {
  static const routeName = '/category';

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  Map<String, bool> flag = {};
  bool switchbutton = true;

  void _updateScreen() {
    setState(() {});
  }

  void selectAll(Map<String, bool> flag, bool nvalue) {
    flag.forEach((key, value) {
      flag[key] = nvalue;
    });
  }

  void _deletedSelected(Function dx) {
    flag.removeWhere((key, value) {
      if (value == true) {
        dx(key);
        return true;
      } else {
        return false;
      }
    });
  }

  void _startdeleteSelected(Function dx, BuildContext ctx) {
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
                  _deletedSelected(dx);
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
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, Object>;

    Map<String, int> total = routeArgs['total'] as Map<String, int>;
    Map<String, int> noOfTransactions =
        routeArgs['noOfTransaction'] as Map<String, int>;
    List<String> localCategories = (routeArgs['categories'] as List<String>);
    Function _addCat = routeArgs['addCat'];
    Function _deleteCat = routeArgs['deleteCat'];

    localCategories.forEach((element) {
      if (flag[element] == null) flag[element] = false;
    });

    print(flag);

    return Scaffold(
      appBar: AppBar(
        title: Text('Overview'),
        actions: <Widget>[
          FlatButton.icon(
              onPressed: () {
                setState(() {
                  selectAll(flag, switchbutton);
                  switchbutton = !switchbutton;
                });
              },
              icon: Icon(Icons.select_all),
              label: Text('')),
          FlatButton.icon(
              onPressed: () {
                _startdeleteSelected(_deleteCat, context);
              },
              icon: Icon(Icons.delete),
              label: Text(''))
        ],
      ),
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
                  return NewCategory(_addCat, _updateScreen);
                },
              )),
    );
  }
}
