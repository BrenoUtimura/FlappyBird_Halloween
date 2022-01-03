import 'package:flutter/material.dart';

class MyBarrier extends StatelessWidget {
  final size;
  //double pumpHeight = ;
  //double pumpWidht =  ;
  //double barrierHeight
  //double barrierWidth

  MyBarrier({this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: 100,
      decoration: BoxDecoration(
        color: Colors.green,
        border: Border.all(width: 10, color: Colors.green.shade800),
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }
}
