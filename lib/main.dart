import 'package:flutter/material.dart';

void main() {
  runApp(const UnitConverterApp());
}

class UnitConverterApp extends StatelessWidget {
  const UnitConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: UnitConverterScreen(),
    );
  }
}

class UnitConverterScreen extends StatefulWidget {
  const UnitConverterScreen({super.key});

  @override
  State<UnitConverterScreen> createState() => _UnitConverterScreen();
}

class _UnitConverterScreen extends State<UnitConverterScreen> {
  final List<Unit> unit = [
    Unit("Cantimeter", 0.01),
    Unit("Meters", 1.0),
    Unit("Feet", 0.3048),
    Unit("Millimeter", 0.001)
  ];

  String inputUnit = "Meters";
  String outputUnit = "Meters";
  double inputFactor = 1.0;
  double outputFactor = 1.0;
  String inputValue = "";
  String outputValue = "";

  void convertUnit() {
    final input = double.tryParse(inputValue) ?? 0.0;
    final result =
        ((input * inputFactor / outputFactor) * 100).roundToDouble() / 100.0;

    setState(() {
      outputValue = result.toString();
    });
  }

  Widget _buildUnitDropdown(String selectedUnit, Function(String) onChanged) {
    return DropdownButton<String>(
        value: selectedUnit,
        borderRadius: BorderRadius.circular(12),
        dropdownColor: Colors.indigo.shade100,
        onChanged: (String? newValue) {
          if (newValue != null) {
            onChanged(newValue);
          }
        },
        items: unit.map((unit) {
          return DropdownMenuItem(
            child: Text(unit.name),
            value: unit.name,
          );
        }).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Unit Converter"),
          centerTitle: true,
        ),
        body: Padding(
            padding: EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        inputValue = value;
                        convertUnit();
                      });
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Enter a Value",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      fillColor: Colors.indigo.shade50,
                      filled: true,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: _buildUnitDropdown(inputUnit, (newUnit) {
                        setState(() {
                          inputUnit = newUnit;
                          inputFactor = unit
                              .firstWhere((u) => u.name == inputUnit)
                              .factor;
                          convertUnit();
                        });
                      })),
                      const SizedBox(width: 16),
                      const Icon(
                        Icons.swap_horiz,
                        size: 32,
                        color: Colors.indigo,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                          child: _buildUnitDropdown(outputUnit, (newUnit) {
                        setState(() {
                          outputUnit = newUnit;
                          outputFactor = unit
                              .firstWhere((u) => u.name == outputUnit)
                              .factor;
                          convertUnit();
                        });
                      })),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.indigo.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Result",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: Colors.indigo),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              transitionBuilder:
                                  (Widget child, Animation<double> animation) {
                                return FadeTransition(
                                    opacity: animation, child: child);
                              },
                              child: Text(
                                "$outputValue $outputUnit",
                                key: ValueKey<String>(outputValue),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ))
                        ],
                      )),
                ],
              ),
            )));
  }
}

class Unit {
  final String name;
  final double factor;

  Unit(this.name, this.factor);
}
