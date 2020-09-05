import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:personal_expenses/providers/transaction.dart';
import 'package:provider/provider.dart';
//import 'package:multiselect_formfield/multiselect_formfield.dart';


class NewTransaction extends StatefulWidget {

  final listkey;
  NewTransaction(this.listkey);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  var _selectedDate = DateTime.now();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _amountFocusNode = FocusNode();
  String _category;

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _submitData(Function addTx) async {
    final title = _titleController.text;
    final amount = _amountController.text;

    try {
      await addTx(title, int.parse(amount), _selectedDate, _category);
      Navigator.of(context).pop();
      if (widget.listkey.currentState != null) {
        /*      int index = Provider.of<TransactionListProvider>(context, listen: false)
                .noOfTransactions -
            1;  */
        widget.listkey.currentState
            .insertItem(0, duration: Duration(milliseconds: 500));
      }
    } catch (e) {
      print(e);
      return;
    }
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: _selectedDate,
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
    final transactionsProvider =
        Provider.of<TransactionListProvider>(context, listen: false);
    final categoryProvider =
        Provider.of<CategoryListProvider>(context, listen: true);
    final allCategories = categoryProvider.allCategory;
    final Function addTransaction = transactionsProvider.addTransaction;

    return (allCategories.length == 0)
        ? Container(
            child: CircularProgressIndicator(),
          )
        : SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.5,
              padding: EdgeInsets.all(6),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      autofocus: true,
                      controller: _titleController,
                      decoration: InputDecoration(labelText: 'Title'),
                      validator: (value) {
                        if (value.isEmpty || value == null)
                          return 'Please Enter Title';
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_amountFocusNode);
                      },
                    ),
                    TextFormField(
                      focusNode: _amountFocusNode,
                      controller: _amountController,
                      decoration: InputDecoration(labelText: 'Amount'),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        WhitelistingTextInputFormatter.digitsOnly
                      ],
                      validator: (value) {
                        if (value.isEmpty ||
                            value == null ||
                            int.parse(value) <= 0) return 'Please Enter Amount';
                        return null;
                      },
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Selected date :- ${DateFormat('d/M/y').format(_selectedDate)}',
                          ),
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
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Focus(
                          child: Container(
                            width: 200,
                            child: DropdownButtonFormField<String>(
                                //isExpanded: true,
                                validator: (value) {
                                  if (value == null) return 'Select category';
                                  return null;
                                },
                                value: _category,
                                hint: Text(
                                  'Select Category',
                                ),
                                icon: Icon(Icons.arrow_downward),
                                elevation: 16,
                                style: TextStyle(
                                  color: Colors.deepPurple,
                                ),
                                items: (allCategories).map((String each) {
                                  return DropdownMenuItem<String>(
                                    value: each,
                                    child: Text(each),
                                  );
                                }).toList(),
                                onChanged: (String newValue) {
                                  _category = newValue;
                                }),
                          ),
                        ),
                        Container(
                          child: RaisedButton(
                            child: Text('Add Transaction'),
                            color: Colors.purple,
                            textColor: Colors.white,
                            onPressed: () {
                              var form = _formKey.currentState;
                              if (form.validate()) {
                                form.save();
                                _submitData(addTransaction);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
