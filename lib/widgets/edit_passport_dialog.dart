import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapplication/data/passport_mockup.dart';

class EditPassportDialog extends StatefulWidget {
  final Passport passport;
  final Function(Passport) editPassport;

  const EditPassportDialog({
    required this.passport,
    required this.editPassport,
    super.key,
  });

  @override
  State<EditPassportDialog> createState() => _EditPassportDialogState();
}

class _EditPassportDialogState extends State<EditPassportDialog> {
  //กำหนดค่าทีหลัง
  late TextEditingController _dateIssueController;
  late TextEditingController _dateExpireController;
  late TextEditingController _passportNumberController;

  @override
  void initState() {
    super.initState();
    // กำหนดค่าเริ่มต้นจากข้อมูลเดิม
    _passportNumberController = TextEditingController(
      text: widget.passport.passportNumber,
    );
    _dateIssueController = TextEditingController(
      text: widget.passport.issueDate.toString().split(" ")[0],
    );
    _dateExpireController = TextEditingController(
      text: widget.passport.expiryDate.toString().split(" ")[0],
    );
  }

  @override
  //ล้างข้อมูลในฟอร์มหลังปิด
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
        child: Text(
          "แก้ไขหนังสือเดินทาง",
          style: GoogleFonts.kanit(fontSize: 20),
        ),
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
                hintText: "หมายเลขหนังสือเดินทาง",
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
                labelStyle: GoogleFonts.kanit(fontSize: 17),
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
                    _dateIssueController.text = picked.toString().split(" ")[0];
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
                labelStyle: GoogleFonts.kanit(fontSize: 17),
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
            color: Colors.white,
            fontSize: 14
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
              final passportEdited = Passport(
                passportNumber: _passportNumberController.text,
                issueDate: DateTime.parse(_dateIssueController.text),
                expiryDate: DateTime.parse(_dateExpireController.text),
              );
              // เรียก callback function
              widget.editPassport(passportEdited);
              // ปิด dialog
              Navigator.of(context).pop();
            }
          },
          child: Text("เพิ่ม",style: GoogleFonts.kanit(
            fontSize: 14,
            color: Colors.white
          ),),
        ),
      ],
    );
  }
}
