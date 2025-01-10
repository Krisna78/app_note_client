import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Dropdownbutton extends StatelessWidget {
  final List<String> proposalList = ["ya", "tidak"];
  Dropdownbutton({super.key});

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      items: proposalList.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (value) {},
    );
  }
}
