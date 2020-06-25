import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NewCategory extends StatelessWidget {
  final _ccontroller = TextEditingController();
  final Function _addCat, _updateScreen;

  NewCategory(this._addCat, this._updateScreen);

  void updateCategory() {
    String cat = _ccontroller.text;
    if (cat.isEmpty) return;
    _addCat(cat);

    _updateScreen();
  }

  @override
  Widget build(BuildContext context) {
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
                  WhitelistingTextInputFormatter(RegExp("[a-zA-Z0-9]"))
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
                  updateCategory();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
