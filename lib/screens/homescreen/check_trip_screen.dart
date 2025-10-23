import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:myapplication/data/trip_mockup.dart';

class CheckTripScreen extends StatefulWidget {
  final Trip trip;
  const CheckTripScreen({super.key, required this.trip});

  @override
  State<CheckTripScreen> createState() => _CheckTripScreenState();
}

class _CheckTripScreenState extends State<CheckTripScreen> {
  late List<bool> checkedItems;

  String formatDateThai(DateTime date) {
    return DateFormat('d MMMM yyyy', 'th').format(date);
  }

  @override
  void initState() {
    super.initState();
    checkedItems = List.filled(widget.trip.items.length, false);
  }

  void _chnageValueChecked(int index) {
    setState(() {
      checkedItems[index] = !checkedItems[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color.fromARGB(255, 21, 20, 95),
        title: Text(
          "ตรวจสอบสิ่งของ",
          style: GoogleFonts.kanit(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // card แสดงประเทศ + วันที่
              Container(
                height: 170,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF667eea),
                      Color.fromARGB(255, 21, 20, 95),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  children: [
                    Padding(padding: EdgeInsets.all(5)),
                    Icon(Icons.location_on, color: Colors.white),
                    Text(
                      widget.trip.country,
                      style: GoogleFonts.kanit(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Icon(Icons.flight_takeoff, color: Colors.white),
                              Text(
                                "ออกเดินทาง",
                                style: GoogleFonts.kanit(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                formatDateThai(widget.trip.departDate),
                                style: GoogleFonts.kanit(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(height: 40, width: 1, color: Colors.white30),
                        Expanded(
                          child: Column(
                            children: [
                              Icon(Icons.flight_land, color: Colors.white),
                              Text(
                                "วันกลับ",
                                style: GoogleFonts.kanit(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                formatDateThai(widget.trip.returnDate),
                                style: GoogleFonts.kanit(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // List ของสิ่งของ
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.trip.items.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 220, 220, 220),
                          blurRadius: 10,
                          spreadRadius: 1,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    margin: EdgeInsets.only(bottom: 15),
                    child: ListTile(
                      onTap: () {
                        _chnageValueChecked(index);
                      },
                      title: Text(
                        widget.trip.items[index],
                        style: GoogleFonts.kanit(
                          fontSize: 18,
                          color: Colors.black,
                          decoration: checkedItems[index]
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      trailing: Checkbox(
                        value: checkedItems[index],
                        onChanged: (newValue) {
                          _chnageValueChecked(index);
                        },
                        activeColor: Color.fromARGB(255, 55, 196, 50),
                        checkColor: Colors.white,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      //ส่วนด้านล่าง
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // แสดงเมื่อตรวจสอบครบเเล้วเมื่อครบแล้ว
              if (checkedItems.every((item) => item))
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.all(16),
                  child: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 55, 196, 50),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "เสร็จสิ้น",
                      style: GoogleFonts.kanit(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}