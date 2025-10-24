import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapplication/data/contry_mockuo.dart';
import 'package:myapplication/data/trip_mockup.dart';

class EditTripScreen extends StatefulWidget {
  final Trip trip;
  const EditTripScreen({super.key, required this.trip});

  @override
  State<EditTripScreen> createState() => _EditTripScreenState();
}

class _EditTripScreenState extends State<EditTripScreen> {
  List<String> filteredCountry = [];
  bool _showList = false;
  List<String> editedItems = [];
  List<bool> checkedItems = [];

  final _formKey = GlobalKey<FormState>();
  late TextEditingController _countryController;
  late TextEditingController _dateofdepartController;
  late TextEditingController _dateofreturnController;
  final TextEditingController _itemController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _countryController = TextEditingController(text: widget.trip.country);
    _dateofdepartController = TextEditingController(
      text: widget.trip.departDate.toString().split(" ")[0],
    );
    _dateofreturnController = TextEditingController(
      text: widget.trip.returnDate.toString().split(" ")[0],
    );
    editedItems = List.from(widget.trip.items);
    checkedItems = List.filled(editedItems.length, true); ////
  }

  @override
  void dispose() {
    _countryController.dispose();
    _dateofdepartController.dispose();
    _dateofreturnController.dispose();
    _itemController.dispose();
    super.dispose();
  }

  void _chnageValueChecked(int index) {
    setState(() {
      checkedItems[index] = !checkedItems[index];
    });
  }

  //ปัญหา
  void _deleteItem(int index) {
    setState(() {
      editedItems = [
        ...editedItems.sublist(0, index),
        ...editedItems.sublist(index + 1),
      ];
      checkedItems = [
        ...checkedItems.sublist(0, index),
        ...checkedItems.sublist(index + 1),
      ];
    });
  }

  //ปัญหา
  void _addItem() {
    final newItem = _itemController.text.trim();
    if (newItem.isNotEmpty) {
      setState(() {
        editedItems = [...editedItems, newItem];
        checkedItems = [...checkedItems, false];
      });
      _itemController.clear();
    }
  }

  void _updateTrip() {
    if (_formKey.currentState!.validate()) {
      List<String> selectedItems = [];
      for (int i = 0; i < editedItems.length; i++) {
        if (checkedItems[i]) {
          selectedItems.add(editedItems[i]);
        }
      }

      if (selectedItems.isEmpty) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Icon(Icons.info, color: Colors.red, size: 50)],
            ),
            content: Text(
              'กรุณาเลือกสิ่งของอย่างน้อย 1 รายการ',
              textAlign: TextAlign.center,
              style: GoogleFonts.kanit(fontSize: 17),
            ),
            actions: [
              TextButton(
                style: TextButton.styleFrom(backgroundColor: Colors.green),
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  "ตกลง",
                  style: GoogleFonts.kanit(fontSize: 17, color: Colors.white),
                ),
              ),
            ],
          ),
        );
        return;
      }

      final country = _countryController.text;
      final departDate = DateTime.parse(_dateofdepartController.text);
      final returnDate = DateTime.parse(_dateofreturnController.text);

      // ตรวจสอบวันที่
      if (returnDate.isBefore(departDate)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("วันที่ไม่ถูกต้อง"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      // สร้าง Trip object ที่อัปเดตแล้ว
      Trip updatedTrip = Trip(
        id: widget.trip.id, // ใช้ ID เดิม
        country: country,
        departDate: departDate,
        returnDate: returnDate,
        items: selectedItems,
      );
      Navigator.of(context).pop(updatedTrip);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          "แก้ไขข้อมูลแผนการท่องเที่ยว",
          style: GoogleFonts.kanit(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 21, 20, 95),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //#1 เลือกตั้งแต่ text เลือกจุดหมาย จนถึง if(showlist) โค้ดบรรทัดที่(165-232 ลองตรวจก่อนใช่ไหม) คัดลอกละลบทิ้งไปก่อน เเล้วก็เพิ่ม column() เเล้วค่อยใส่โค้ดที่ก็อปมาเข้าไป
                //#2 ต่อจาก column ที่เพิ่มมาให้คลุม column อันนั้นด้วย container
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //#3 คลุม text ด้วย row
                      Row(
                        children: [
                          //#4 เพิ่ม container
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color:  Color(0xFF1A237E).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.location_on,
                              color: Color(0xFF1A237E),
                              size: 24,
                            ),
                          ), //#4 จบ
                          SizedBox(width: 12),
                          Text(
                            "เลือกจุดหมาย",
                            style: GoogleFonts.kanit(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A237E),
                            ),
                          ),
                        ],
                      ), //3 จบ
                      const SizedBox(height: 16),
                      //search bar
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
                        //#4 เปลี่นน font
                        style: GoogleFonts.kanit(fontSize: 16),
                        //#5 แก้ตรง decoration ก็อปไปวางได้เลย
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.search,
                            color: Color.fromARGB(255, 21, 20, 95),
                          ),
                          hintText: "ค้นหา...",
                          hintStyle: GoogleFonts.kanit(
                            fontSize: 16,
                            color: Colors.grey.shade400,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 21, 20, 95),
                              width: 2,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade200,
                        ), //#5 จบ
                      ),
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
                                    _countryController.text = countryName;
                                    _showList = false;
                                    FocusScope.of(context).unfocus();
                                  });
                                },
                              );
                            },
                          ),
                        ),
                    ],
                  ), //#1 จบตรงนี้
                ), //#2 จบตรงนี้

                const SizedBox(height: 20),

                //#6 ก็อปตั้งแต่ text เลือกวันที่เดินทาง ถึง Row() ก็อปไว้ เพิ่ม column() เเล้วเอาไปใส่
                //#7 คลุม column ด้วย container
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //#8  คุลุม text ด้วย Row()
                      Row(
                        children: [
                          //9เพิ่ม container
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color:  Color(0xFF1A237E).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.date_range,
                              color: Color(0xFF1A237E),
                              size: 24,
                            ),
                          ),
                          SizedBox(width: 12),
                          Text(
                            "เลือกวันที่เดินทาง",
                            style: GoogleFonts.kanit(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A237E),
                            ),
                          ),
                        ],
                      ), //#8 จบ
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _dateofdepartController,
                              //#9 เพิ่ม ui ใน decoration ก็อปวางเลย
                              decoration: InputDecoration(
                                labelText: "วันเดินทาง",
                                labelStyle: GoogleFonts.kanit(
                                  fontSize: 18,
                                  color: Color(0xFF1A237E),
                                  fontWeight: FontWeight.bold
                                ),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                prefixIcon: Icon(
                                  Icons.calendar_today,
                                  color: Color(0xFF1A237E),
                                ),
                                filled: true,
                                fillColor: Colors.grey.shade200,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Color(0xFF1A237E),
                                    width: 2,
                                  ),
                                ),
                              ),
                              readOnly: true,
                              onTap: () async {
                                DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100),
                                  //#10 เพิ่ม builder ตรงนี้เข้าไป
                                  builder: (context, child) {
                                    return Theme(
                                      data: Theme.of(context).copyWith(
                                        colorScheme: ColorScheme.light(
                                          primary: Color(0xFF1A237E),
                                        ),
                                      ),
                                      child: child!,
                                    );
                                  },
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
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _dateofreturnController,
                              //#11 เพิ่ม ui ใน decoration เหมือนเดิม
                              decoration: InputDecoration(
                                labelText: "วันกลับ",
                                labelStyle: GoogleFonts.kanit(
                                  fontSize: 18,
                                  color: Color(0xFF1A237E),
                                  fontWeight: FontWeight.bold
                                ),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                prefixIcon: Icon(
                                  Icons.event_busy,
                                  color: Color(0xFF1A237E),
                                ),
                                filled: true,
                                fillColor: Colors.grey.shade200,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  borderSide: BorderSide.none, //ทำให้ไม่มีขอบ
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Color(0xFF1A237E),
                                    width: 2,
                                  ),
                                ),
                              ),//#11 จบ
                              readOnly: true,
                              onTap: () async {
                                DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100),
                                  //#12 เพิ่ม builder ตรงนี้เข้าไป
                                  builder: (context, child) {
                                    return Theme(
                                      data: Theme.of(context).copyWith(
                                        colorScheme: ColorScheme.light(
                                          primary: Color(0xFF1A237E),
                                        ),
                                      ),
                                      child: child!,
                                    );
                                  },//#12 จบ
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
                    ],
                  ), //#6 จบ
                ), //#7 จบ

                const SizedBox(height: 20),

                //#13 ก็อป listview.builder ทั้งหมด สร้าง column เเล้วเอาไปวาง
                //#14 คลุ่ม column ทั้งหมด ด้วย container
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //สร้าง Row() ก็อปไปวางได้เลย
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color:  Color(0xFF1A237E).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.checklist,
                              color: Color(0xFF1A237E),
                              size: 24,
                            ),
                          ),
                          SizedBox(width: 12),
                          Text(
                            "รายการสิ่งของ",
                            style: GoogleFonts.kanit(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A237E),
                            ),
                          ),
                          Spacer(),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color:  Color(0xFF1A237E).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              "${editedItems.length} รายการ",
                              style: GoogleFonts.kanit(
                                fontSize: 14,
                                color: Color(0xFF1A237E),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20,),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: editedItems.length,
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color.fromARGB(
                                    255,
                                    220,
                                    220,
                                    220,
                                  ),
                                  blurRadius: 10,
                                  spreadRadius: 1,
                                  offset: Offset(0, 3), // ทิศทางเงา
                                ),
                              ],
                            ),
                            margin: EdgeInsets.only(bottom: 15),
                            child: ListTile(
                              onTap: () {
                                _chnageValueChecked(index);
                              },
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              title: Text(
                                editedItems[index],
                                style: GoogleFonts.kanit(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              leading: Checkbox(
                                value: checkedItems[index],
                                onChanged: (bool? newValue) {
                                  _chnageValueChecked(index);
                                },
                                activeColor: Color.fromARGB(255, 55, 196, 50),
                                checkColor: Colors.white,
                              ),
                              trailing: Container(
                                height: 35,
                                width: 35,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    _deleteItem(index);
                                  },
                                  icon: Icon(Icons.delete),
                                  color: Colors.white,
                                  iconSize: 18,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (editedItems.isNotEmpty)
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.all(16),
                  child: TextButton(
                    onPressed: _updateTrip,
                    style: TextButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 55, 196, 50),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "บันทึกการแก้ไข",
                      style: GoogleFonts.kanit(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 5,
                      ),
                      margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0, 3),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _itemController,
                        decoration: InputDecoration(
                          hintText: "เพิ่มสิ่งของ...",
                          hintStyle: GoogleFonts.kanit(),
                          border: InputBorder
                              .none, //ลบเส้นใต้ของตัว textfield ตอนใส่ข้อตวาม
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 20, 20),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 21, 20, 95),
                    ),
                    child: IconButton(
                      onPressed: () {
                        _addItem();
                      },
                      icon: Icon(Icons.add, color: Colors.white, size: 30),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
