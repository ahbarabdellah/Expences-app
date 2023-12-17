import 'package:flutter/material.dart';

class AddExpenseDialog extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController dolarControler;
  final TextEditingController centControler;
  DateTime selectedDate;
  final update;

  AddExpenseDialog(
      {super.key,
      required this.nameController,
      required this.dolarControler,
      required this.centControler,
      required this.selectedDate,
      required this.update});

  @override
  State<AddExpenseDialog> createState() => _AddExpenseDialogState();
}

class _AddExpenseDialogState extends State<AddExpenseDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Add an Expense"),
            TextField(
              controller: widget.nameController,
              decoration: const InputDecoration(hintText: 'name'),
            ),
            Row(
              children: [
                Expanded(
                    child: TextField(
                  controller: widget.dolarControler,
                  keyboardType: const TextInputType.numberWithOptions(),
                  decoration: const InputDecoration(hintText: 'dollars'),
                )),
                const SizedBox(width: 10), // Add a gap between the text fields
                Expanded(
                    child: TextField(
                  controller: widget.centControler,
                  keyboardType: const TextInputType.numberWithOptions(),
                  decoration: const InputDecoration(hintText: 'cents'),
                )),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "${widget.selectedDate.day} / ${widget.selectedDate.month} / ${widget.selectedDate.year}",
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(5)),
                    child: MaterialButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return DatePickerDialog(
                              initialDate:
                                  DateTime.now(), // Set an initial date
                              firstDate: DateTime.now()
                                  .subtract(const Duration(days: 50)),
                              lastDate:
                                  DateTime.now().add(const Duration(days: 50)),
                            );
                          },
                        ).then((selectedDate) {
                          if (selectedDate != null) {
                            // Handle the selected date
                            widget.selectedDate = selectedDate;
                          }
                        });
                      },
                      child: const Text(
                        'Select a Date',
                        style: TextStyle(color: Colors.white),
                      ), // Add a child to MaterialButton to show something on the button
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text("Cancel"),
          onPressed: () => Navigator.of(context).pop(), // Closes the dialog
        ),
        TextButton(
            child: const Text("Save"),
            onPressed: () {
              widget.update();

              Navigator.of(context).pop(); // Closes the dialog
            }),
      ],
    );
    ;
  }
}
