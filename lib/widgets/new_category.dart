import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers/transaction.dart';

class NewCategory extends StatelessWidget {
  final _ccontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final categoryProviders =
        Provider.of<CategoryListProvider>(context, listen: false);
    final Function addCat = categoryProviders.addCategory;
    return Card(
      child: Container(
        height: MediaQuery.of(context).viewInsets.bottom + 70,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * 0.6,
              child: TextField(
                controller: _ccontroller,
                autofocus: true,
                decoration: InputDecoration(labelText: 'Create New Category'),
                inputFormatters: [
                  //WhitelistingTextInputFormatter(RegExp("[a-zA-Z0-9]"))
                  FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9]"))
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width * 0.3,
              height: 70,
              child: RaisedButton(
                child: Text('Create'),
                color: Colors.purple,
                textColor: Colors.white,
                onPressed: () {
                  if (_ccontroller.text.isNotEmpty) {
                    addCat(_ccontroller.text);
                    Navigator.pop(context);
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
