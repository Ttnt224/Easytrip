import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapplication/screens/profile%20screen/edited_profile_screen.dart';
import 'package:myapplication/data/passport_mockup.dart';
import 'package:myapplication/data/proflie_mockup.dart';
import 'package:myapplication/widgets/add_passport_dialog.dart';
import 'package:myapplication/widgets/build_passport_item.dart';
import 'package:myapplication/widgets/confimation_alert_dialog.dart';
import 'package:myapplication/widgets/container_show_detail.dart';
import 'package:myapplication/widgets/edit_passport_dialog.dart';
import 'package:intl/intl.dart';

class ProfileScreenView extends StatefulWidget {
  const ProfileScreenView({super.key});

  @override
  State<ProfileScreenView> createState() => _ProfileScreenViewState();
}

class _ProfileScreenViewState extends State<ProfileScreenView> {
  String formatDateThai(DateTime date) {
    return DateFormat('d MMMM yyyy', 'th').format(date);
  }

  //สร้าง passport ใหม่
  void _addPassport(Passport newPassport) {
    setState(() {
      passports.add(newPassport);
    });
  }

  void _editPassport(Passport oldPassport, Passport editPassport) {
    setState(() {
      int index = passports.indexWhere(
        (p) => p.passportNumber == oldPassport.passportNumber,
      );
      if (index != -1) {
        passports[index] = editPassport;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final profile = profiledata[0];
    return Scaffold(
      backgroundColor: Colors.white,
      //ส่วนหัว profile และ แก้ไข
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 21, 20, 95),
        title: Text(
          "โปรไฟล์",
          style: GoogleFonts.kanit(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: <Widget>[
          TextButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EditedProfile()),
            ),
            label: Text(
              "แก้ไข",
              style: GoogleFonts.kanit(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            icon: Icon(Icons.edit, color: Colors.white),
          ),
        ],
      ),
      //ส่วน body หน้าจอเลื่อนได้
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 50),
            const SizedBox(height: 10),
            ContainerShowDetail(
              title: "ข้อมูลส่วนตัว",
              icon: Icons.person,
              children: [
                //function ในการสร้างข้อมูลในแถว
                buildRow("ชื่อ", profile.fname), //รับค่าจาก mock up profile
                buildRow("นามสกุล", profile.lname),
                buildRow("เบอร์โทร", profile.phonenum),
              ],
            ),
            //หน้า passport
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.book),
                          const SizedBox(width: 10),
                          Text(
                            "ข้อมูลหนังสือเดินทาง",
                            style: GoogleFonts.kanit(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 50),
                          IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AddPassportDialog(
                                    addPassport: _addPassport,
                                  );
                                },
                              );
                            },
                            icon: Icon(Icons.add),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      //แสดง ทุกตัวใน list ของ passport
                      Column(
                        children: passports.map((passport) {
                          return BuildPassportItem(
                            passport: passport,
                            numpassport: passport.passportNumber,
                            onEditPressed: () {
                              //กดแก้ไข
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return EditPassportDialog(
                                    passport: passport,
                                    editPassport: (editedPassport) {
                                      _editPassport(passport, editedPassport);
                                    },
                                  );
                                },
                              );
                            },
                            onDeletePressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return ConfirmationDialog(
                                    icon: Icon(
                                      Icons.info,
                                      color: Colors.red,
                                      size: 50,
                                    ),
                                    content: Text(
                                      "คุณแน่ใจเเล้วใช่ไหมว่าต้องการลบข้อมูลนี้",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.kanit(
                                        //
                                      ),
                                    ),
                                    onConfirm: () {
                                      setState(() {
                                        //ลบข้อมูล
                                        passports.removeWhere(
                                          (p) =>
                                              p.passportNumber ==
                                              passport.passportNumber,
                                        );
                                      });
                                    },
                                  );
                                },
                              );
                            },
                            children: [
                              buildRow(
                                "วันออก",
                                formatDateThai(passport.issueDate),
                              ),
                              buildRow(
                                "วันหมดอายุ",
                                formatDateThai(passport.expiryDate),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            //ปุ่มออกจากระบบ
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return ConfirmationDialog(
                      content: Text(
                        "คุณต้องการออกจากระบบใช่หรือไม่",
                        style: GoogleFonts.kanit(
                          //
                        ),
                      ),
                      onConfirm: () {
                        //ใส่ว่าตอนออกจากระบบจะเด้งไปหน้าไหน
                      },
                      icon: Icon(Icons.warning, color: Colors.red, size: 50),
                    );
                  },
                );
              },
              style: TextButton.styleFrom(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.logout, size: 30, color: Colors.red),
                  Text(
                    "ออกจากระบบ",
                    style: GoogleFonts.kanit(
                      color: Colors.red,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
