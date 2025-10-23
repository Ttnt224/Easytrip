import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ConfirmationDialog extends StatelessWidget {
  final Widget content;
  final VoidCallback onConfirm;
  final Widget icon;

  const ConfirmationDialog({
    super.key,
    required this.content,
    required this.onConfirm,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [icon, SizedBox(width: 8)],
      ),
      content: content,
      actions: [
        Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red, //สีตัวอักษร
                  //backgroundColor: Colors.red, //สีปุ่ม
                ),
                child: Text(
                  "ยกเลิก",
                  style: GoogleFonts.kanit(
                    //
                  ),
                ),
              ),
            ),
            const SizedBox(width: 7,),
            Expanded(
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onConfirm();
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.green, //สีตัวอักษร
                  //backgroundColor: Colors.green, //สีปุ่ม
                ),
                child: Text(
                  "ยืนยัน",
                  style: GoogleFonts.kanit(
                    //
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
