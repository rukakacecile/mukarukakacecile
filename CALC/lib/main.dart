import 'package:flutter/material.dart';

void main() {
  runApp(SimpleCalculator());
}

class SimpleCalculator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Calculator',
        home: Calculation(),
        theme: ThemeData.dark()
    );
  }
}

class Calculation extends StatefulWidget{
  @override
  _CalculationState createState() => _CalculationState();
}

class _CalculationState extends State<Calculation> {
  List<dynamic> inputList = [0];
  String output = '0';

  void _handleClear() {
    setState(() {
      inputList = [0];
      output = '0';
    });
  }

  void _handlePress(String input) {
    setState(() {
      if (_isOperator(input)) {
        if (inputList.last is int) {
          inputList.add(input);
          output += input;
        }
      } else if (input == '=') {
        while (inputList.length > 2) {
          int firstNumber = inputList.removeAt(0) as int;
          String operator = inputList.removeAt(0);
          int secondNumber = inputList.removeAt(0) as int;
          int partialResult = 0;

          if (operator == '+') {
            partialResult = firstNumber + secondNumber;
          } else if (operator == '-') {
            partialResult = firstNumber - secondNumber;
          } else if (operator == '*') {
            partialResult = firstNumber * secondNumber;
          } else if (operator == '/') {
            partialResult = firstNumber ~/ secondNumber;
            // Protect against division by zero
            if(secondNumber == 0) {
              partialResult = firstNumber;
            }
          }

          inputList.insert(0, partialResult);
        }

        output = '${inputList[0]}';
      } else {
        int? inputNumber = int.tryParse(input);
        if (inputNumber != null) {
          if (inputList.last is int && !_isOperator(output[output.length - 1])) {
            int lastNumber = (inputList.last as int);
            lastNumber = lastNumber * 10 + inputNumber;
            inputList.last = lastNumber;

            output = output.substring(0, output.length - 1) + lastNumber.toString();
          } else {
            inputList.add(inputNumber);
            output += input;
          }
        }
      }
    });
  }

  bool _isOperator(String input) {
    if (input == "+" || input == "-" || input == "*" || input == "/") {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("CALCULATOR")),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              child: TextField(
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                textAlign: TextAlign.right,
                decoration: InputDecoration(border: InputBorder.none,),
                controller: TextEditingController()..text = output,
                readOnly: true,
              ),
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 4,
                children: <Widget>[
                  for(var i = 0; i <= 9; i++)
                    TextButton(
                      child: Text("$i", style: TextStyle(fontSize: 25)),
                      onPressed: () => _handlePress("$i"),
                    ),
                  TextButton(
                    child: Text("C", style: TextStyle(fontSize: 25)),
                    onPressed: _handleClear,
                  ),
                  TextButton(
                    child: Text("+", style: TextStyle(fontSize: 25)),
                    onPressed: () => _handlePress("+"),
                  ),
                  TextButton(
                    child: Text("-", style: TextStyle(fontSize: 25)),
                    onPressed: () => _handlePress("-"),
                  ),
                  TextButton(
                    child: Text("*", style: TextStyle(fontSize: 25)),
                    onPressed: () => _handlePress("*"),
                  ),
                  TextButton(
                    child: Text("/", style: TextStyle(fontSize: 25)),
                    onPressed: () => _handlePress("/"),
                  ),
                  TextButton(
                    child: Text("=", style: TextStyle(fontSize: 25)),
                    onPressed: () => _handlePress("="),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}