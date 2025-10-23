import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ContainerShowDetail extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const ContainerShowDetail({
    super.key,
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      //จัดขนาดตัวกล่องไม่ให้ชนกับขอบต่างๆภายนอก
      margin: EdgeInsets.all(15),
      child: Card(
        //เงาใช้สีขาวเลยใส่เงา
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          //จัดพื้นที่ภายใน
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon), //รับ Icon
                  SizedBox(width: 15),
                  Text(
                    title,
                    style: GoogleFonts.kanit(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ), //รับชื่อของตาราง
                ],
              ),
              SizedBox(height: 10),
              ...children,
            ],
          ),
        ),
      ),
    );
  }
}
//function
Widget buildRow(String label, String? value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: GoogleFonts.kanit(
              fontSize: 15
            ),
          ),
        ),
        Text(": "),
        Expanded(
          child: Text(
            value ?? "ยังไม่ได้ระบุ",
            style: GoogleFonts.kanit(
              fontSize: 15
            ),
          ),
        ), //ให้รับค่า null ได้
      ],
    ),
  );
}
