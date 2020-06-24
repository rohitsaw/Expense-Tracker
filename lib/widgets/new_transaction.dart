import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;

  NewTransaction(this.addTx);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  var _selectedDate = DateTime.now();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  String _category;

  void _submitData() {
    final title = _titleController.text;
    final amount = _amountController.text;

    if (title.isEmpty || amount.isEmpty || (_category == null)) {
      return;
    }
    try {
      widget.addTx(title, int.parse(amount), _selectedDate, _category);
      Navigator.of(context).pop();
    } catch (e) {
      return;
    }
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      } else {
        setState(() {
          _selectedDate = pickedDate;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(labelText: 'Title'),
              controller: _titleController,
              onSubmitted: (_) => _submitData(),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Amount'),
              controller: _amountController,
              keyboardType: TextInputType.number,
              inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
              onSubmitted: (_) => _submitData(),
            ),
            Container(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                    'Selected date :- ${DateFormat('d/M/y').format(_selectedDate)}'),
                Container(
                  padding: EdgeInsets.only(top: 5),
                  child: FlatButton(
                    textColor: Colors.blue,
                    child: Text(
                      'Change Date',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: _presentDatePicker,
                  ),
                ),
              ],
            )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: DropdownButton<String>(
                      value: _category,
                      hint: Text('Select Category'),
                      icon: Icon(Icons.arrow_downward),
                      elevation: 16,
                      style: TextStyle(
                        color: Colors.deepPurple,
                      ),
                      underline: Container(
                        height: 2,
                        color: Colors.deepPurple,
                      ),
                      items:
                          <String>['c1', 'c2', 'c3', 'c4'].map((String each) {
                        return DropdownMenuItem<String>(
                          value: each,
                          child: Text(each),
                        );
                      }).toList(),
                      onChanged: (String newValue) {
                        setState(() {
                          _category = newValue;
                        });
                      }),
                ),
                Container(
                  child: RaisedButton(
                    child: Text('Add Transaction'),
                    color: Colors.purple,
                    textColor: Colors.white,
                    onPressed: _submitData,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
