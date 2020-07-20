import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/transaction.dart';

class Category extends StatelessWidget {
  static const routeName = '/category';

  @override
  Widget build(BuildContext context) {
    final title =
        ModalRoute.of(context).settings.arguments as String;

    final providers = Provider.of<TransactionListProvider>(context, listen:false);
    List<Transaction> txlist = providers.filterTransactions(title);

    int total = 0;
    txlist.forEach((element) {total += element.amount; });

    return Scaffold(
      appBar: AppBar(
        title: Text('$title'),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: ListView.builder(
            itemBuilder: (ctx, index) {
              return Card(
                elevation: 10,
                //margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                child: InkWell(
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
