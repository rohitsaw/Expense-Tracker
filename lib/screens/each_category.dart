import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/transaction.dart';

class Category extends StatefulWidget {
  static const routeName = '/category';

  @override
  _CategoryState createState() => _CategoryState();
}

enum SortBy { none, amount, date }

class _CategoryState extends State<Category> {
  SortBy _selected = SortBy.none;
  List<Transaction> orglist;
  List<Transaction> txlist;
  String title;
  bool _isLoad = false;
  int total = 0;

  @override
  void didChangeDependencies() {
    if (_isLoad == false) {
      title = ModalRoute.of(context).settings.arguments as String;
      orglist = Provider.of<TransactionListProvider>(context, listen: false)
          .filterTransactions(title);
      orglist.forEach((element) {
        total += element.amount;
      });
      _isLoad = true;
    }
    super.didChangeDependencies();
  }

  Widget _paddingpopup() {
    return PopupMenuButton<SortBy>(
      onSelected: (SortBy result) {
        setState(() {
          _selected = result;
        });
      },
      icon: Icon(
        Icons.sort,
        semanticLabel: 'Sort Categories',
      ),
      //label: Text('Categories'),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<SortBy>>[
        const PopupMenuItem<SortBy>(
          value: SortBy.none,
          child: Text('Default'),
        ),
        const PopupMenuItem<SortBy>(
          value: SortBy.amount,
          child: Text('Amount'),
        ),
        const PopupMenuItem<SortBy>(
          value: SortBy.date,
          child: Text('Date'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    txlist = [...orglist];
    if (_selected == SortBy.amount) {
      txlist.sort((a, b) => b.amount.compareTo(a.amount));
    } else if (_selected == SortBy.date) {
      txlist.sort((a, b) => b.date.compareTo(a.date));
    } else if (_selected == SortBy.none) {
      print("none is selected");
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('$title'),
        actions: [
          Center(child: Text("Sort By")),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: _paddingpopup(),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: ListView.separated(
            separatorBuilder: (context, index) {
              return Divider();
            },
            itemBuilder: (ctx, index) {
              return InkWell(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      child: Padding(
                        padding: EdgeInsets.all(6),
                        child: FittedBox(
                          child: Text('\u{20B9}${txlist[index].amount}'),
                        ),
                      ),
                    ),
                    title: Text(
                      '${txlist[index].title}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                        '${DateFormat.yMMMd().format(txlist[index].date)}'),
                  ),
                ),
              );
            },
            itemCount: txlist.length),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Card(
          color: Colors.tealAccent,
          child: InkWell(
            onTap: () {},
            child: Container(
              height: 70,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Total  ',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      '\u{20B9}$total ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text('in ${txlist.length} transactions...',
                        style: TextStyle(
                          fontSize: 18,
                        )),
                  ],
                ),
              ),
            ),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
      ),
    );
  }
}
