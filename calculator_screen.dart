// L. L. Uvindu Thamodya IM/2021/112
import 'package:uvical/Button_values.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String num1 = "";
  String operand = "";
  String num2 = "";
  String result = "";

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      reverse: true,
                      child: Text(
                        "$num1$operand$num2".isEmpty ? "0" : "$num1$operand$num2",
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.right,
                        maxLines: 1,
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      reverse: true,
                      child: Text(
                        result.isEmpty ? "" : result,
                        style: const TextStyle(
                          fontSize: 49,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.right,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Wrap(
              children: Btn.buttonValues.map(
                    (value) => SizedBox(
                  width: screenSize.width / 4,
                  height: screenSize.width / 5,
                  child: buildButton(value),
                ),
              ).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButton(String value) {
    bool isSpecialOperator = [
      Btn.divide,
      Btn.per,
      Btn.add,
      Btn.subtract,
      Btn.multiply,
      Btn.squareRoot,
    ].contains(value);

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Material(
        color: getBtnColor(value),
        clipBehavior: Clip.hardEdge,
        shape: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(20),
        ),
        child: InkWell(
          onTap: () => onBtnTap(value),
          child: Center(
            child: Text(
              value == Btn.squareRoot ? "√" : value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 34,
                color: isSpecialOperator ? Colors.green : Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onBtnTap(String value) {
    if (value == Btn.del) {
      delete();
      return;
    }
    if (value == Btn.clr) {
      clearAll();
      return;
    }
    if (value == Btn.per) {
      convertToPercentage();
      return;
    }
    if (value == Btn.calculate) {
      calculate();
      return;
    }
    if (value == Btn.squareRoot) {
      applySquareRoot();
      return;
    }
    if (operand.isNotEmpty && num2.isNotEmpty) {
      calculate();
    }
    if (operand.isNotEmpty && num1.isNotEmpty && num2.isEmpty) {
      calculate();
    }
    if (value == Btn.subtract) {
      if (num1.isEmpty && operand.isEmpty) {
        setState(() {
          num1 = "-";
        });
        return;
      } else if (num1.isNotEmpty && operand.isEmpty && num1 != "-") {
        setState(() {
          operand = Btn.subtract;
        });
        return;
      }
    }
    appendValue(value);
  }

  void applySquareRoot() {
    if (operand.isEmpty && num1.isNotEmpty) {
      try {
        double number = double.parse(num1);
        if (number < 0) {
          setState(() => result = "Error");
          return;
        }
        setState(() {
          result = sqrt(number).toStringAsFixed(6).replaceAll(RegExp(r"0+$"), "").replaceAll(RegExp(r"\.$"), "");
        });
      } catch (e) {
        setState(() => result = "Error");
      }
    }
  }

  void calculate() {
    if (num1.isEmpty || operand.isEmpty || num2.isEmpty) return;

    try {
      double firstNum = double.parse(num1);
      double secondNum = double.parse(num2);
      double resultValue = 0.0;

      switch (operand) {
        case Btn.add:
          resultValue = firstNum + secondNum;
          break;
        case Btn.subtract:
          resultValue = firstNum - secondNum;
          break;
        case Btn.multiply:
          resultValue = firstNum * secondNum;
          break;
        case Btn.divide:
          if (secondNum == 0) {
            setState(() => result = "Error");
            return;
          }
          resultValue = firstNum / secondNum;
          break;
        default:
          return;
      }

      setState(() {
        result = resultValue.toStringAsFixed(6).replaceAll(RegExp(r"0+$"), "").replaceAll(RegExp(r"\.$"), "");
        num1 = result;
        operand = "";
        num2 = "";
      });
    } catch (e) {
      setState(() {
        result = "Error";
        num1 = "";
        operand = "";
        num2 = "";
      });
    }
  }

  void convertToPercentage() {
    if (num1.isNotEmpty && operand.isEmpty) {
      try {
        double number = double.parse(num1);
        setState(() {
          num1 = (number / 100).toString().replaceAll(RegExp(r"\.0+$"), "");
        });
      } catch (e) {
        setState(() => num1 = "Error");
      }
    } else if (num1.isNotEmpty && operand.isNotEmpty && num2.isNotEmpty) {
      try {
        double number = double.parse(num2);
        setState(() {
          num2 = (number / 100).toString().replaceAll(RegExp(r"\.0+$"), "");
        });
      } catch (e) {
        setState(() => num2 = "Error");
      }
    }
  }

  void clearAll() {
    setState(() {
      num1 = "";
      operand = "";
      num2 = "";
      result = "";
    });
  }

  void delete() {
    if (num2.isNotEmpty) {
      num2 = num2.substring(0, num2.length - 1);
    } else if (operand.isNotEmpty) {
      operand = "";
    } else if (num1.isNotEmpty) {
      num1 = num1.substring(0, num1.length - 1);
    }
    setState(() {});
  }

  void appendValue(String value) {
    if (result.isNotEmpty) {
      if (int.tryParse(value) != null || value == Btn.dot) {
        num1 = result;
        result = "";
        num2 = "";
        operand = "";
      }
    }

    if (value != Btn.dot && int.tryParse(value) == null) {
      if (operand.isEmpty && num1.isNotEmpty && num1 != "-") {
        operand = value;
      } else if (num1.isNotEmpty && operand.isNotEmpty && num2.isNotEmpty) {
        calculate();
        operand = value;
      }
    } else if (operand.isEmpty) {
      if (value == Btn.dot && !num1.contains(Btn.dot)) {
        num1 += num1.isEmpty || num1 == "-" ? "0" : "";
      }
      num1 += value;
    } else {
      if (value == Btn.dot && !num2.contains(Btn.dot)) {
        num2 += num2.isEmpty ? "0" : "";
      }
      num2 += value;
    }
    setState(() {});
  }

  Color getBtnColor(String value) {
    if (value == Btn.calculate) {
      return Colors.orange.shade900;
    }
    if (value == Btn.clr) {
      return Colors.redAccent;
    }
    if (value == Btn.del) {
      return const Color.fromARGB(255, 83, 74, 30);
    }
    return const Color.fromARGB(255, 2, 3, 3);
  }
}


