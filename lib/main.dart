import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _output = "0";
  String _currentInput = "";
  double _num1 = 0;
  double _num2 = 0;
  String _operation = "";
  bool _isOperationSelected = false;

  void _buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        // Clear everything
        _output = "0";
        _currentInput = "";
        _num1 = 0;
        _num2 = 0;
        _operation = "";
        _isOperationSelected = false;
      } else if (buttonText == "⌫") {
        // Backspace
        if (_currentInput.isNotEmpty) {
          _currentInput = _currentInput.substring(0, _currentInput.length - 1);
          if (_currentInput.isEmpty) {
            _output = "0";
          } else {
            _output = _currentInput;
          }
        }
      } else if (buttonText == "=") {
        // Calculate result
        if (_operation.isNotEmpty && _currentInput.isNotEmpty) {
          _num2 = double.parse(_currentInput);

          switch (_operation) {
            case "+":
              _output = (_num1 + _num2).toString();
              break;
            case "-":
              _output = (_num1 - _num2).toString();
              break;
            case "×":
              _output = (_num1 * _num2).toString();
              break;
            case "÷":
              _output = _num2 != 0 ? (_num1 / _num2).toString() : "Error";
              break;
          }

          // Remove trailing .0 if it's an integer
          if (_output.endsWith('.0')) {
            _output = _output.substring(0, _output.length - 2);
          }

          _currentInput = _output;
          _operation = "";
          _isOperationSelected = false;
        }
      } else if (["+", "-", "×", "÷"].contains(buttonText)) {
        // Operation buttons
        if (_currentInput.isNotEmpty) {
          _num1 = double.parse(_currentInput);
          _operation = buttonText;
          _currentInput = "";
          _isOperationSelected = true;
        }
      } else if (buttonText == ".") {
        // Decimal point
        if (!_currentInput.contains(".")) {
          _currentInput += _currentInput.isEmpty ? "0." : ".";
          _output = _currentInput;
        }
      } else {
        // Number buttons (0-9)
        if (_output == "0" || _isOperationSelected) {
          _currentInput = buttonText;
          _isOperationSelected = false;
        } else {
          _currentInput += buttonText;
        }
        _output = _currentInput;
      }
    });
  }

  Widget _buildButton(String buttonText, {Color? color, Color? textColor}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () => _buttonPressed(buttonText),
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? Colors.grey[200],
            foregroundColor: textColor ?? Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(20),
          ),
          child: Text(
            buttonText,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Calculator',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Display Section
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              alignment: Alignment.bottomRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    _operation.isNotEmpty ? '$_num1 $_operation' : '',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    reverse: true,
                    child: Text(
                      _output,
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Buttons Section
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  // First Row
                  Expanded(
                    child: Row(
                      children: [
                        _buildButton("C", color: Colors.red, textColor: Colors.white),
                        _buildButton("⌫", color: Colors.orange, textColor: Colors.white),
                        _buildButton("÷", color: Colors.blue, textColor: Colors.white),
                        _buildButton("×", color: Colors.blue, textColor: Colors.white),
                      ],
                    ),
                  ),

                  // Second Row
                  Expanded(
                    child: Row(
                      children: [
                        _buildButton("7"),
                        _buildButton("8"),
                        _buildButton("9"),
                        _buildButton("-", color: Colors.blue, textColor: Colors.white),
                      ],
                    ),
                  ),

                  // Third Row
                  Expanded(
                    child: Row(
                      children: [
                        _buildButton("4"),
                        _buildButton("5"),
                        _buildButton("6"),
                        _buildButton("+", color: Colors.blue, textColor: Colors.white),
                      ],
                    ),
                  ),

                  // Fourth Row
                  Expanded(
                    child: Row(
                      children: [
                        _buildButton("1"),
                        _buildButton("2"),
                        _buildButton("3"),
                        _buildButton("=", color: Colors.green, textColor: Colors.white),
                      ],
                    ),
                  ),

                  // Fifth Row
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Row(
                            children: [
                              _buildButton("0"),
                            ],
                          ),
                        ),
                        _buildButton("."),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
