import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/transaction.dart';

import '../widgets/drawer.dart';
import '../widgets/new_category.dart';
import '../screens/each_category.dart';



class CategoryScreen extends StatefulWidget {
  static const routeName = '/categoryScreen';

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  Map<String, bool> flag = {};
  // bool _loadData = false;
  int _noOfSelected = 0;

  dynamic categoryProvider;
  dynamic transactionProvider;
  Map<String, Map<String, int>> categoryWiseTransaction;

  void selectAll() {
    if (flag.containsValue(false)) {
      flag.forEach((key, value) {
        flag[key] = true;
      });
      _noOfSelected = flag.length;
    } else {
      flag.forEach((key, value) {
        flag[key] = false;
      });
      _noOfSelected = 0;
    }
    setState(() {});
  }

  void _deletedSelected(Function deleteCat, Function deleteTransaction) {
    flag.removeWhere((key, value) {
      if (value == true) {
        deleteCat(key);
        deleteTransaction(key);
        _noOfSelected -= 1;
        return true;
      } else {
        return false;
      }
    });
  }

  void _startdeleteSelected(
      BuildContext ctx, Function deleteCat, Function deleteTransaction) {
    if (!flag.containsValue(true)) {
      Scaffold.of(ctx).removeCurrentSnackBar();
      Scaffold.of(ctx).showSnackBar(
        SnackBar(
            duration: Duration(milliseconds: 700),
            content: Text('long press on category to select')),
      );
      return;
    }
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
                  _deletedSelected(deleteCat, deleteTransaction);
                  Navigator.of(ctx).pop();
                  setState(() {});
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
    categoryProvider = Provider.of<CategoryListProvider>(context, listen: true);
    transactionProvider =
        Provider.of<TransactionListProvider>(context, listen: false);
    final List<String> allCategories = categoryProvider.allCategory;
    categoryWiseTransaction = transactionProvider.categoryWiseTransactions();
    allCategories.forEach((element) {
      if (flag[element] == null) flag[element] = false;
    });

    return Scaffold(
      drawer: const MyDrawer(),
      appBar: MyAppBar(
        appBar: AppBar(),
        deleteCat: categoryProvider.deleteCategory,
        deleteCategoryTransaction:
            transactionProvider.deleteCategoryTransaction,
        selectAll: selectAll,
        startDeleteSelected: _startdeleteSelected,
      ),
      body: (categoryProvider.noOfCategory == 0)
          ? Container()
          : Container(
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
                    onLongPress: () {
                      setState(() {
                        flag[allCategories[index]] =
                            !flag[allCategories[index]];
                        if (flag[allCategories[index]])
                          _noOfSelected += 1;
                        else
                          _noOfSelected -= 1;
                      });
                    },
                    onTap: () {
                      if (_noOfSelected > 0) {
                        setState(() {
                          flag[allCategories[index]] =
                              !flag[allCategories[index]];
                          if (flag[allCategories[index]])
                            _noOfSelected += 1;
                          else
                            _noOfSelected -= 1;
                        });
                      } else {
                        Navigator.of(context).pushNamed(
                          Category.routeName,
                          arguments: allCategories[index],
                        );
                      }
                    },
                    splashColor: Colors.green,
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text(
                            //localCategories[index],
                            allCategories[index],
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            '\u{20B9}${((categoryWiseTransaction[allCategories[index]] == null) ? 0 : categoryWiseTransaction[allCategories[index]]['total'])}',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '${((categoryWiseTransaction[allCategories[index]] == null) ? 0 : categoryWiseTransaction[allCategories[index]]['length'])} transactions',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            if (flag[allCategories[index]] == false ||
                                flag[allCategories[index]] == null) ...[
                              Colors.tealAccent.withOpacity(0.4),
                              Colors.teal
                            ] else ...[
                              Colors.black54,
                              Colors.black12,
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
                itemCount: allCategories.length,
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => showModalBottomSheet(
                context: context,
                builder: (_) {
                  return NewCategory();
                },
              )),
    );
  }
}

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final AppBar appBar;
  final Function deleteCat,
      deleteCategoryTransaction,
      selectAll,
      startDeleteSelected;

  MyAppBar({
    this.appBar,
    this.deleteCat,
    this.deleteCategoryTransaction,
    this.selectAll,
    this.startDeleteSelected,
  });

  @override
  Size get preferredSize => new Size.fromHeight(appBar.preferredSize.height);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Categories'),
      actions: <Widget>[
        FlatButton.icon(
            onPressed: () {
              selectAll();
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
            startDeleteSelected(context, deleteCat, deleteCategoryTransaction);
          },
          icon: Icon(
            Icons.delete,
            color: Colors.white,
          ),
          label: Text(''),
        )
      ],
    );
  }
}
