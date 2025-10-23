import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapplication/data/passport_mockup.dart';

class AddPassportDialog extends StatefulWidget {
  final Function(Passport) addPassport;

  const AddPassportDialog({super.key, required this.addPassport});

  @override
  State<AddPassportDialog> createState() => _AddPassportDialogState();
}

class _AddPassportDialogState extends State<AddPassportDialog> {
  final TextEditingController _dateIssueController = TextEditingController();
  final TextEditingController _dateExpireController = TextEditingController();
  final TextEditingController _passportNumberController = TextEditingController();

  //function clear ข้อมูลที่เคยกรอก จะเรียกใช้หลังปิด dialog
  @override
  void dispose() {
    _dateIssueController.dispose();
    _dateExpireController.dispose();
    _passportNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      //หัวชื่อของ alertdialog
      title: Center(
        child: Text("เพิ่มหนังสือเดินทาง ",style: GoogleFonts.kanit(
          fontSize: 20
        ),),
      ),
      //ส่วนเนื้อหา alertdialog
      content: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            //กรอกข้อมูลหมายเลข passport
            TextField(
              controller: _passportNumberController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.credit_card),
                hintText: "หมายเลขหนังสือเดินทาง", ///ต้องเพิ่มเงื่อนไขตรวจสอบ
                hintStyle: GoogleFonts.kanit(
                  fontSize: 12
                ),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
            const SizedBox(height: 20),
            //เลือกวันที่ออกหนังสือ
            TextField(
              controller: _dateIssueController,
              decoration: InputDecoration(
                labelText: "วันออกหนังสือ",
                labelStyle: GoogleFonts.kanit(
                  fontSize: 17
                ),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                prefixIcon: Icon(Icons.calendar_today),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              readOnly: true,
              onTap: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  setState(() {
                    _dateIssueController.text = picked.toString().split(
                      " ",
                    )[0];
                  });
                }
              },
            ),
            const SizedBox(height: 20),
            //เลือกวันที่หมดอายุ
            TextField(
              controller: _dateExpireController,
              decoration: InputDecoration(
                labelText: "วันหมดอายุ",
                labelStyle: GoogleFonts.kanit(
                  fontSize: 17
                ),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                prefixIcon: Icon(Icons.event_busy),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              readOnly: true,
              onTap: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  setState(() {
                    _dateExpireController.text = picked.toString().split(
                      " ",
                    )[0];
                  });
                }
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.red
          ),
          onPressed: () {
            //กดเเล้วกลับไปหน้าก่อนหน้า
            Navigator.of(context).pop();
          },
          child: Text("ยกเลิก",style: GoogleFonts.kanit(
            fontSize: 14,
            color: Colors.white
          ),),
        ),
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.green
          ),
          onPressed: () {
            //กดเพิ่มข้อมูล
            // ตรวจสอบว่าข้อมูลครบถ้วนหรือไม่ 
            if (_passportNumberController.text.isNotEmpty &&
                _dateIssueController.text.isNotEmpty &&
                _dateExpireController.text.isNotEmpty) {
              // สร้าง Passport object ใหม่ //อันนี้แค่ลองเขียนตรวจสอบเสร็จก็เพิ่มข้อมูล
              final newPassport = Passport(
                passportNumber: _passportNumberController.text,
                issueDate: DateTime.parse(_dateIssueController.text),
                expiryDate: DateTime.parse(_dateExpireController.text),
              );
              
              // เรียก callback function
              widget.addPassport(newPassport);           

              // ปิด dialog
              Navigator.of(context).pop();
            } else {
              // แสดง error message ถ้าข้อมูลไม่ครบ
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("กรุณากรอกข้อมูลให้ครบถ้วน")),
              );
            }
          },
          child: Text("บันทึก",style: GoogleFonts.kanit(
            fontSize: 14,
            color: Colors.white
          ),),
        ),
      ],
    );
  }
}
