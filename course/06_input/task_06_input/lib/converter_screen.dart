// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'unit.dart';

const _padding = EdgeInsets.all(16.0);

/// [ConverterScreen] where users can input amounts to convert in one [Unit]
/// and retrieve the conversion in another [Unit] for a specific [Category].
///
/// While it is named ConverterRoute, a more apt name would be ConverterScreen,
/// because it is responsible for the UI at the route's destination.
class ConverterScreen extends StatefulWidget {
  /// Color for this [Category].
  final Color color;

  /// Units for this [Category].
  final List<Unit> units;

  /// This [ConverterScreen] requires the color and units to not be null.
  const ConverterScreen({
    @required this.color,
    @required this.units,
  })
      : assert(color != null),
        assert(units != null);

  @override
  _ConverterScreenState createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  // Set some variables, such as for keeping track of the user's input
  // value and units
  double _inputValue;
  // From units.dart, this is a unit string and a conversion value
  Unit _inputUnit;
  String _outputString = '';
  Unit _outputUnit;
  List<DropdownMenuItem> _unitMenuItems;

  bool _inputValidationError = false;

  // Determine whether you need to override anything, such as initState()
  // Assume the drop down of units is constant
  @override
  void initState() {
    super.initState();

    // Create a list of DropdownMenu items from [Units]

    var _dropdownUnits = <DropdownMenuItem>[];

    // Suck down the original units passed into the widget
    for (var unit in widget.units) {
      _dropdownUnits.add(
          DropdownMenuItem(
            value: unit.name,
            child: Container(
              child: Text(
                unit.name,
                softWrap: true,
              ),
            ),
          ));
    }

    // NOw update the state variable
    // And set random defaults for the units
    setState(
            () {
          _unitMenuItems = _dropdownUnits;
          _inputUnit = widget.units[0];
          _outputUnit = widget.units[1];
        }
    );
  }

  // Add other helper functions. We've given you one, _format()
  void _updateOutputString() {
    setState(() {
      _outputString = _format(
          _inputValue * _inputUnit.conversion / _outputUnit.conversion);
    });
  }

  // Use set state so the display also updates
  void _updateInputValue(String input) {
    setState(() {
      if (input == null || input.isEmpty) {
        _outputString = '';
      } else {
        // use a try in case of errors
        try {
          final parseResult = double.parse(input);
          _inputValidationError = false;
          _inputValue = parseResult;
          _updateOutputString();
        } on Exception catch (e) {
          print('Error $e');
          _inputValidationError = true;
        }
      }
    });
  }

  /// Clean up conversion; trim trailing zeros, e.g. 5.500 -> 5.5, 10.0 -> 10
  String _format(double conversion) {
    var outputNum = conversion.toStringAsPrecision(7);
    if (outputNum.contains('.') && outputNum.endsWith('0')) {
      var i = outputNum.length - 1;
      while (outputNum[i] == '0') {
        i -= 1;
      }
      outputNum = outputNum.substring(0, i + 1);
    }
    if (outputNum.endsWith('.')) {
      return outputNum.substring(0, outputNum.length - 1);
    }
    return outputNum;
  }

  // Utilities to find the unit conversion from a name
  Unit _getUnit(String unitName) =>
      widget.units.firstWhere(
            (Unit unit) => unit.name == unitName,
        orElse: null,
      );

  // If the units change, rerun the conversion
  void _updateInputUnit(dynamic unitName) {
    setState(() {
      _inputUnit = _getUnit(unitName);
    });
    if (_inputUnit != null) {
      _updateOutputString();
    }
  }

  void _updateOutputUnit(dynamic unitName) {
    setState(() {
      _outputUnit = _getUnit(unitName);
    });
    if (_outputUnit != null) {
      _updateOutputString();
    }
  }

  // Now the biggest helper of all
  Widget _createDropdown(String currentValue,
      ValueChanged<dynamic> onChanged) {
    return Container(
      margin: EdgeInsets.only(top: 16.0),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border.all(
          color: Colors.grey[400],
          width: 1.0,
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Theme(
        // The color set
        data: Theme.of(context).copyWith(
          canvasColor: Colors.grey[50],
        ),
        child: DropdownButtonHideUnderline(
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton(
              value: currentValue,
              items: _unitMenuItems,
              onChanged: onChanged,
              style: Theme.of(context).textTheme.title,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Create the 'input' group of widgets. This is a Column that
    // includes the input value, and 'from' unit [Dropdown].
    // Scaffold is what you use for a standard pane
    final inputWidget = Padding(
      padding: _padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // https://androidmonks.com/textfield-flutter/
          TextField(
            style: Theme
                .of(context)
                .textTheme
                .display1,
            decoration: InputDecoration(
              labelStyle: Theme
                  .of(context)
                  .textTheme
                  .display1,
              errorText: _inputValidationError ? 'Invalid entered' : null,
              labelText: 'Input',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(0.0),
              ),
            ),
            keyboardType: TextInputType.number,
            onChanged: _updateInputValue,
          ),
          // https://www.developerlibs.com/2019/09/flutter-drop-down-menu-list-example.html
          _createDropdown(_inputUnit.name, _updateInputUnit),
        ],
      ),
    );

    // Create a compare arrows icon.
    final arrowWidget = RotatedBox(
      quarterTurns: 1,
      child: Icon(
        Icons.compare_arrows,
        size: 48.0,
      ),
    );

    // Create the 'output' group of widgets. This is a Column that
    // includes the output value, and 'to' unit [Dropdown].
    final outputWidget = Padding(
      padding: _padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InputDecorator(
            child: Text(
              _outputString,
              style: Theme.of(context).textTheme.display1,
            ),
            decoration: InputDecoration(
              labelText: 'Output',
              labelStyle: Theme.of(context).textTheme.display1,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(0.0),
              ),
            ),
          ),
          _createDropdown(_outputUnit.name, _updateOutputUnit),
        ],
      ),
    );

    // Return the input, arrows, and output widgets, wrapped in a Column.
    final converter = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        inputWidget,
        arrowWidget,
        outputWidget
      ],
    );

    return Padding(
      padding: _padding,
      child: converter,
    );

    // TODO: Delete the below placeholder code.
    final unitWidgets = widget.units.map((Unit unit) {
      return Container(
        color: widget.color,
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Text(
              unit.name,
              style: Theme
                  .of(context)
                  .textTheme
                  .headline,
            ),
            Text(
              'Conversion: ${unit.conversion}',
              style: Theme
                  .of(context)
                  .textTheme
                  .subhead,
            ),
          ],
        ),
      );
    }).toList();

    return ListView(
      children: unitWidgets,
    );
  }

}
