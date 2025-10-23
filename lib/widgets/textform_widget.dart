import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTextfield extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obsecureText;
  final String labeltext;
  final IconData? prefixicon;
  final Widget? suffixicon;
  final String? Function(String?)? validator;

  const MyTextfield({
    super.key,
    required this.controller,
    required this.labeltext,
    required this.hintText,
    required this.obsecureText,
    this.prefixicon,
    this.suffixicon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: TextFormField(
        controller: controller,
        obscureText: obsecureText,
        validator: validator,
        decoration: InputDecoration(
          prefixIcon: Icon(prefixicon),
          suffixIcon: suffixicon,
          labelText: labeltext,
          labelStyle: GoogleFonts.kanit(
            //
          ),
          hintText: hintText,
          hintStyle: GoogleFonts.kanit(
            //
          ),
          filled: true,
          fillColor: Colors.grey[50],
          border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        ),
      ),
    );
  }
}
