import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {

   final Function()? onTap;
   MyButton({super.key, required this.onTap});

@override
Widget build(BuildContext context){
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(15),
      margin:const EdgeInsets.symmetric(horizontal: 75),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(28, 53, 80, 1),
        borderRadius: BorderRadius.circular(8),
        ),
      child: const Center(
        child: Text(
          "L  O  G  I  N",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          )),
    ),
  );
}

}