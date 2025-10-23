import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InfoTextForm extends StatelessWidget {
  final String labelText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final TextEditingController controller;


  const InfoTextForm({
    super.key,
    required this.labelText,
    required this.keyboardType,
    this.validator,
    required this.controller
  });
  
  @override
  Widget build(BuildContext context) {
    return  TextFormField(
      style: GoogleFonts.kanit(
        color: Colors.black,
      ),
      keyboardType: keyboardType,
      validator: validator,
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: GoogleFonts.kanit(
          //
        ),
        floatingLabelBehavior:
            FloatingLabelBehavior.always, //ทำให้ Label ไม่ตกลงมา
        //กรอบของกล่องรับข้อความ
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
      ),
    );
  }
}
