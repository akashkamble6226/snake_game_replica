import 'package:flutter/material.dart';
class SnakePixel extends StatelessWidget {
  const SnakePixel({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Container(
                    decoration: BoxDecoration(color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(5)),
                  ),
                );
  }
}