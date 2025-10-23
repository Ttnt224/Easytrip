import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapplication/data/proflie_mockup.dart';
import 'package:myapplication/widgets/collect_info_textformfield.dart';

class EditedProfile extends StatefulWidget {
  const EditedProfile({super.key});

  @override
  State<EditedProfile> createState() => _EditedProfileState();
}

class _EditedProfileState extends State<EditedProfile> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fnameController = TextEditingController();
  final TextEditingController _lnameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _fnameController.dispose();
    _lnameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "แก้ไขโปรไฟล์",
          style: GoogleFonts.kanit(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 21, 20, 95),
      ),
      //Scrollview ไม่ให้เกิด error เมื่อเนื้อหายาวเกินไป
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 80),
                InfoTextForm(
                  labelText: "ชื่อ",
                  keyboardType: TextInputType.text,
                  controller: _fnameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "กรุณากรอกชื่อ";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                InfoTextForm(
                  labelText: "นามสกุล",
                  keyboardType: TextInputType.text,
                  controller: _lnameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "กรุณากรอกนามสกุล";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                InfoTextForm(
                  labelText: "เบอร์โทร",
                  keyboardType: TextInputType.text,
                  controller: _phoneController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "กรุณากรอกเบอร์โทร";
                    }
                    if (value.length > 10) {
                      return "กรุณากรอกเบอร์ให้ไม่เกิน 10 ตัวเลข";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 50),
                //ปุ่มยืนยัน
                TextButton(
                  onPressed: () {
                    //ใส่ save
                    if (_formKey.currentState!.validate()) {
                      profiledata.add(
                        Profile(
                          fname: _fnameController.text,
                          lname: _lnameController.text,
                          phonenum: _phoneController.text,
                        ),
                      );
                      Navigator.pop(context);
                    }
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white, 
                    backgroundColor:Colors.green,
                    padding: const EdgeInsets.symmetric(
                      //ขนาดปุ่ม
                      horizontal: 40,
                      vertical: 15,
                    ),
                  ),
                  child: Text(
                    "บันทึก",
                    style: GoogleFonts.kanit(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
