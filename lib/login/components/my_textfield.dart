import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget{
  final controller;
  final String hintText;
  final bool obscureText;

   MyTextField({
    super.key,
    
    required this.controller,
    required this.hintText,
    required this.obscureText,
   });

@override
Widget build(BuildContext context) {
  return  Padding(

      padding:  const EdgeInsets.symmetric(horizontal: 25.0),
      
        child: TextField(
         controller: controller,
         obscureText: obscureText,
          decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
              borderSide: BorderSide(color: Color.fromRGBO(217, 217, 217, 100))),
              fillColor:const Color.fromRGBO(217, 217, 217, 100),
              filled: true,
              hintText: hintText,
              hintStyle: const TextStyle(
                color: Color.fromRGBO(171, 171, 171, 100)
              )
             )
             
          ),
  );
}

}