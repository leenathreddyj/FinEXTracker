import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewInvestmentForm extends StatefulWidget {
  final Function _addInvestment;

  const NewInvestmentForm(this._addInvestment, {super.key});

  @override
  NewInvestmentFormState createState() => NewInvestmentFormState(); // Changed from _NewInvestmentFormState
}

class NewInvestmentFormState extends State<NewInvestmentForm> { // Changed from _NewInvestmentFormState
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _titleFocus = FocusNode();
  final _amountFocus = FocusNode();
  final _dateFocus = FocusNode();
  final _timeFocus = FocusNode();

  late DateTime _selectedDate = DateTime.now();
  TimeOfDay? _selectedTime; // Kept to use in invDateTime

  Future<Null> _selectDate(BuildContext context) async {
    final today = DateTime.now();
    DateTime firstDate = DateTime(today.year, today.month, 1);
    DateTime lastDate = DateTime(today.year, today.month + 1, 0);
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: today,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _dateController.value = TextEditingValue(text: DateFormat('d/M/y').format(pickedDate));
      });
    }
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
        _timeController.value = TextEditingValue(
            text: DateFormat.jm().format(
          DateTime(
            _selectedDate.year,
            _selectedDate.month,
            _selectedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          ),
        ));
      });
    }
  }

  void _fieldFocusChange(BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      final invTitle = _titleController.text;
      final invAmount = double.parse(_amountController.text);
      // Use _selectedTime if available, otherwise default to midnight
      final invDateTime = _selectedTime != null
          ? DateTime(
              _selectedDate.year,
              _selectedDate.month,
              _selectedDate.day,
              _selectedTime!.hour,
              _selectedTime!.minute,
            )
          : DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);

      widget._addInvestment(
        invTitle,
        invAmount,
        invDateTime,
      );
      Navigator.of(context).pop();
    } // Removed else block with _autoValidateToggle
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            SizedBox(height: 15.0),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                ),
                prefixIcon: Icon(Icons.title),
                hintText: "Enter a title",
              ),
              validator: (value) {
                if (value!.isEmpty) return "Title cannot be empty";
                return null;
              },
              focusNode: _titleFocus,
              onEditingComplete: () => _fieldFocusChange(context, _titleFocus, _amountFocus),
              controller: _titleController,
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: 20.0),
            TextFormField(
              focusNode: _amountFocus,
              decoration: InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                ),
                prefixIcon: Icon(Icons.local_atm),
                hintText: "Enter the amount",
              ),
              validator: (value) {
                RegExp regex = RegExp('[0-9]+(.[0-9]+)?');
                if (!regex.hasMatch(value!) || double.tryParse(value) == null) {
                  return "Please enter valid amount";
                }
                return null;
              },
              controller: _amountController,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: GestureDetector(
                    onTap: () => _selectDate(context),
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: _dateController,
                        focusNode: _dateFocus,
                        keyboardType: TextInputType.datetime,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(25.0)),
                          ),
                          labelText: 'Date',
                          hintText: 'Date of Investment',
                          prefixIcon: Icon(Icons.calendar_today),
                          suffixIcon: Icon(Icons.arrow_drop_down),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) return "Please select a date";
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.0),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _selectTime(context),
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: _timeController,
                        focusNode: _timeFocus,
                        keyboardType: TextInputType.datetime,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(25.0)),
                          ),
                          labelText: 'Time',
                          hintText: 'Time of Investment',
                          prefixIcon: Icon(Icons.schedule),
                          suffixIcon: Icon(Icons.arrow_drop_down),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) return "Please select a time";
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            SizedBox(
              width: double.infinity,
              height: 55.0,
              child: ElevatedButton.icon(
                icon: Icon(Icons.check),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0)),
                  backgroundColor: Colors.green[700], // Matches FinEXTracker theme
                ),
                label: Text(
                  'ADD Investment',
                  style: TextStyle(
                    fontFamily: "Rubik",
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
                onPressed: _onSubmit,
              ),
            ),
          ],
        ),
      ),
    );
  }
}