import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simple_expense_tracker/data/expense.dart';

class ExpenseTracker extends StatefulWidget {
  const ExpenseTracker({super.key});

  @override
  State<ExpenseTracker> createState() => _ExpenseTrackerState();
}

class _ExpenseTrackerState extends State<ExpenseTracker> {
  final List<Expense> _expense = [];
  final List<String> _categories = [
    'Food',
    'Transport',
    'Entertainment',
    'Bills',
  ];

  double _total = 0.0;

  _addExpense(String title, double amount, DateTime date, String category) {
    setState(() {
      _expense.add(
        Expense(title: title, amount: amount, date: date, category: category),
      );
      _total += amount;
    });
  }

  void _showForm(context) {
    TextEditingController titleController = TextEditingController();
    TextEditingController amountController = TextEditingController();
    String selectedCategory = _categories.first;

    showModalBottomSheet(
      context: context,
      // isScrollControlled: true,
      builder: (context) {
        return Column(
          spacing: 10,
          children: [
            SizedBox(height: 5),
            Center(
              child: Container(
                height: 3,
                width: 25,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: DropdownButtonFormField(
                items:
                    _categories
                        .map(
                          (category) => DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          ),
                        )
                        .toList(),
                onChanged: (value) => selectedCategory = value!,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Category',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
              child: ElevatedButton(
                onPressed: () {
                  if (titleController.text.isNotEmpty &&
                      selectedCategory.isNotEmpty &&
                      amountController.text.isNotEmpty) {
                    _addExpense(
                      titleController.text,
                      double.parse(amountController.text),
                      DateTime.now(),
                      selectedCategory,
                    );
                    titleController.clear();
                    amountController.clear();
                    selectedCategory = _categories.first;
                    Navigator.of(context).pop();
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Warning'),
                          content: Text('All fields required'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Close'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 45),
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                ),
                child: Text('Add Expense'),
              ),
            ),
          ],
        );
      },
    );
  }

  void _deleteExpense(index) {
    setState(() {
      _total -= _expense[index].amount;
      _expense.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Tracker'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(context),
        shape: CircleBorder(),
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        child: Icon(Icons.add, size: 30),
      ),

      body: Column(
        children: [
          Center(
            child: Card(
              margin: EdgeInsets.all(20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 40,
                  right: 40,
                  top: 20,
                  bottom: 20,
                ),
                child: Text(
                  'Total: \$${_total.toString()}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _expense.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(index.toString()),
                  background: Container(color: Colors.red, child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(Icons.delete,color: Colors.white,),
                      SizedBox(width: 15,)
                    ],
                  )),
                  onDismissed: (direction) => _deleteExpense(index),
                  child: Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blueAccent,
                        child: Text(
                          _expense[index].category,
                          style: TextStyle(fontSize: 10),
                        ),
                      ),
                      trailing: Text(
                        '\$${_expense[index].amount.toString()}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      title: Text(_expense[index].title),
                      subtitle: Text(
                        DateFormat(
                          "d MMM, yyyy hh:mm a",
                        ).format(_expense[index].date),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
