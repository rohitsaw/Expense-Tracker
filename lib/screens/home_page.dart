import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// import provider
import '../providers/transaction.dart';

// importing other widgets
import '../widgets/chart.dart';
import '../widgets/new_transaction.dart';
import '../widgets/transaction_list.dart';
import '../widgets/new_category.dart';
import '../widgets/drawer.dart';

class MyHomePage extends StatefulWidget {
  static const routeName = '/';
  final String title;

  MyHomePage({this.title});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Transaction> tx = [];
  int txlength = 0;
  bool _isLoading = true;
  bool _isInit = false;
  GlobalKey<AnimatedListState> listkey = GlobalKey<AnimatedListState>();

  @override
  void didChangeDependencies() {
    if (_isInit == false) {
      Provider.of<TransactionListProvider>(context, listen: false)
          .loadTransactions()
          .then((_) {
        setState(() {
          tx = Provider.of<TransactionListProvider>(context, listen: false)
              .getAllTransactions;
          txlength = tx.length;
          _isLoading = false;
        });
      });
      Provider.of<CategoryListProvider>(context, listen: false)
          .loadCategories()
          .then((value) => null);
    }
    _isInit = true;
    super.didChangeDependencies();
  }

  void _startAddNewTransaction(BuildContext cntx) {
    final categoriesLength =
        Provider.of<CategoryListProvider>(cntx, listen: false).noOfCategory;
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      //isScrollControlled: true,
      context: cntx,
      builder: (_) => (categoriesLength != 0)
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: NewTransaction(listkey),
            )
          : NewCategory(),
    );
  }

  @override
  Widget build(BuildContext context) {
    //final provider =
    //    Provider.of<TransactionListProvider>(context, listen: true);

    final appBar = const MyAppBar();

    final availHeight = (MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        appBar.preferredSize.height);

    return Scaffold(
        drawer: const MyDrawer(),
        appBar: appBar,
        body: (_isLoading)
            ? Center(child: CircularProgressIndicator())
            : SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: (availHeight * 0.3),
                        padding: EdgeInsets.all(10),
                        child: Chart(),
                      ),
                      Container(
                        height: (availHeight * 0.7),
                        child: TransactionList(listkey),
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

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar();
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('Expense Tracker'),
      actions: <Widget>[],
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(50.0);
}
