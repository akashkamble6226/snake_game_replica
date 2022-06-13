import 'package:flutter/material.dart';
class FoodPixel extends StatelessWidget {
  const FoodPixel({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Container(
                    decoration: BoxDecoration(color: Colors.orange[100],
                    borderRadius: BorderRadius.circular(5)),
                  ),
                );
  }
}