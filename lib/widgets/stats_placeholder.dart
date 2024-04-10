import 'package:flutter/material.dart';

class StatsPlaceholder extends StatelessWidget {
  final String index;
  const StatsPlaceholder({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Colors.grey, borderRadius: BorderRadius.circular(4)),
          height: 180,
          width: 150,
          child: Text('Graph $index'),
        ),
        const Text("_________"),
        const Text("_________"),
      ],
    );
  }
}
