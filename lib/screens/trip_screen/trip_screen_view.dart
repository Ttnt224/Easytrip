import 'package:flutter/material.dart';
import 'package:myapplication/data/contry_mockuo.dart';
import 'package:myapplication/data/trip_mockup.dart';
import 'package:myapplication/screens/trip_screen/add_item_trip_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class TripScreenView extends StatefulWidget {
  const TripScreenView({super.key});

  @override
  State<TripScreenView> createState() => _TripScreenViewState();
}

class _TripScreenViewState extends State<TripScreenView> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _dateofdepartController = TextEditingController();
  final TextEditingController _dateofreturnController = TextEditingController();
  //list เปล่า
  List<String> filteredCountry = [];
  //ใช้สำหรับแสดงรายการประเทศ
  bool _showList = false;

  @override
  void dispose() {
    _countryController.dispose();
    _dateofdepartController.dispose();
    _dateofreturnController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "สร้างแผนการท่องเที่ยว",
          style: GoogleFonts.kanit(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 21, 20, 95),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        "https://media.istockphoto.com/id/1280010427/vector/happy-family-travelling-by-car.jpg?s=612x612&w=0&k=20&c=fa7mMlFOVGzp4Rkgavdfvl-kmzcyLiCzOFLX5c-yL_U=",
                      ),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "เลือกจุดหมาย",
                  style: GoogleFonts.kanit(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                //ตัว searchbar
                TextFormField(
                  controller: _countryController,
                  onChanged: (value) {
                    final query = value.trim().toLowerCase();
                    setState(() {
                      if (query.isNotEmpty) {
                        _showList = true;
                        filteredCountry = allCountries
                            .where((c) => c.toLowerCase().contains(query))
                            .toList();
                      } else {
                        _showList = false;
                        filteredCountry = [];
                      }
                    });
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: "ค้นหา..",
                    hintStyle: GoogleFonts.kanit(
                      fontSize: 18,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "กรุณากรอกจุดหมายปลายทาง";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                //จะแสดงเมื่อกดพิมพ์เท่านั้น
                if (_showList)
                  Container(
                    constraints: const BoxConstraints(
                      maxHeight: 200,
                    ), //กำหนดขนาดมากสุดให้ container
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ListView.builder(
                      itemCount: filteredCountry.length,
                      itemBuilder: (context, index) {
                        final countryName = filteredCountry[index];
                        return ListTile(
                          title: Text(countryName),
                          onTap: () {
                            setState(() {
                              _countryController.text =
                                  countryName; // ใส่ชื่อใน TextformField
                              _showList = false; // ซ่อนรายการ
                              FocusScope.of(context).unfocus(); // ปิดคีย์บอร์ด
                            });
                          },
                        );
                      },
                    ),
                  ),
                const SizedBox(height: 10),
                Text(
                  "เลือกวันเดินทาง",
                  style: GoogleFonts.kanit(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _dateofdepartController,
                        decoration: InputDecoration(
                          labelText: "วันเดินทาง",
                          labelStyle: GoogleFonts.kanit(fontSize: 20),
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
                              _dateofdepartController.text = picked
                                  .toString()
                                  .split(" ")[0];
                            });
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "กรุณากรอกวันที่ออกเดินทาง";
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: TextFormField(
                        controller: _dateofreturnController,
                        decoration: InputDecoration(
                          labelText: "วันกลับ",
                          labelStyle: GoogleFonts.kanit(fontSize: 20),
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
                              _dateofreturnController.text = picked
                                  .toString()
                                  .split(" ")[0];
                            });
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "กรุณากรอกวันที่กลับจากการเดินทาง";
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                //ทำปุ่มบันทึก
                const SizedBox(height: 25),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final country = _countryController.text;
                      final departDate = DateTime.parse(
                        _dateofdepartController.text,
                      );
                      final returnDate = DateTime.parse(
                        _dateofreturnController.text,
                      );
                      //ตรวจสอลวันที่และแสดงข้อผิดพลาดถ้ามี
                      /// !!!! เปลี่ยนจาก snack bar เป็น
                      if (returnDate.isBefore(departDate)) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.info, color: Colors.red, size: 50),
                              ],
                            ),
                            content: Text(
                              'วันที่ไม่ถูกต้อง',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.kanit(fontSize: 17),
                            ),
                            actions: [
                              TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.green
                                ),
                                onPressed: () => Navigator.of(context).pop(),
                                child: Text(
                                  "ตกลง",
                                  style: GoogleFonts.kanit(fontSize: 17,color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        );
                        return;
                      }
                      //รอส่งข้อมูลกลับเพื่อล้างฟอร์มก่อนหน้านี้ที่กรอกไป พวก ประเทศ วันที่ เวลา
                      final Trip? result = await Navigator.of(context)
                          .push<Trip>(
                            MaterialPageRoute(
                              builder: (context) => AddItemTripScreen(
                                country: country,
                                departDate: departDate,
                                returnDate: returnDate,
                              ),
                            ),
                          );
                      if (result != null) {
                        _countryController.clear();
                        _dateofdepartController.clear();
                        _dateofreturnController.clear();
                        setState(() {
                          _showList = false;
                          filteredCountry = [];
                        });
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    backgroundColor: Color.fromARGB(255, 21, 20, 95),
                  ),
                  child: Text(
                    "หน้าถัดไป",
                    style: GoogleFonts.kanit(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.normal,
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
