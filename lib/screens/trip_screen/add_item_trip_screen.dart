import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:myapplication/data/trip_mockup.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class AddItemTripScreen extends StatefulWidget {
  final String country;
  final DateTime departDate;
  final DateTime returnDate;

  const AddItemTripScreen({
    super.key,
    required this.country,
    required this.departDate,
    required this.returnDate,
  });

  @override
  State<AddItemTripScreen> createState() => _AddItemTripScreenState();
}

class _AddItemTripScreenState extends State<AddItemTripScreen> {
  final TextEditingController _itemController = TextEditingController();
  List<String> addedItems = [];
  List<bool> checkedItems = [];

  Map<String, List<Map<String, String>>> categorizedItems = {};
  Map<String, List<bool>> categorizedChecked = {};
  bool isLoading = true;

  String formatDateThai(DateTime date) {
    return DateFormat('d MMMM yyyy', 'th').format(date);
  }

  String getCategoryNameThai(String category) {
    switch (category) {
      case 'clothing':
        return 'เสื้อผ้า';
      case 'protection':
        return 'ของป้องกัน';
      case 'comfort':
        return 'ของใช้ส่วนตัว';
      case 'safety':
        return 'ของเพื่อความปลอดภัย';
      default:
        return category;
    }
  }

  IconData getCategoryIcon(String category) {
    switch (category) {
      case 'clothing':
        return Icons.checkroom;
      case 'protection':
        return Icons.shield;
      case 'comfort':
        return Icons.person_2_outlined;
      case 'safety':
        return Icons.health_and_safety;
      default:
        return Icons.list;
    }
  }

  @override
  void initState() {
    super.initState();
    _loadChecklistOptimized();
  }

  Future<void> _loadChecklistOptimized() async {
    try {
      final jsonString = await rootBundle.loadString(
        'assets/item_recomend.json',
      );
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      final categories =
          jsonData['data']['checklist']['categories'] as Map<String, dynamic>;

      setState(() {
        categorizedItems = {
          'clothing': _parseItems(categories['clothing']),
          'protection': _parseItems(categories['protection']),
          'comfort': _parseItems(categories['comfort']),
          'safety': _parseItems(categories['safety']),
        };

        // สร้าง checked list
        categorizedChecked = {
          'clothing': List<bool>.filled(
            categorizedItems['clothing']!.length,
            false,
          ),
          'protection': List<bool>.filled(
            categorizedItems['protection']!.length,
            false,
          ),
          'comfort': List<bool>.filled(
            categorizedItems['comfort']!.length,
            false,
          ),
          'safety': List<bool>.filled(
            categorizedItems['safety']!.length,
            false,
          ),
        };

        isLoading = false;
      });
    } catch (e) {
      print('Error loading checklist: $e');
      setState(() {
        isLoading = false;
      });
    }
  }


  List<Map<String, String>> _parseItems(dynamic items) {
    return (items as List).map((item) {
      return {
        'item': item['item'].toString(), //ชื่อสิ่งของ
        'priority': item['priority'].toString(), //ความสำคัญ
      };
    }).toList();
  }

  void _addItem() {
    final newitem = _itemController.text.trim();
    if (newitem.isNotEmpty) {
      setState(() {
        addedItems.add(newitem);
        checkedItems.add(false);
        _itemController.clear();
      });
    }
  }

  void _changeValueChecked(int index) {
    setState(() {
      checkedItems[index] = !checkedItems[index];
    });
  }

  void _changeRecommendedChecked(String category, int index) {
    setState(() {
      categorizedChecked[category]![index] =
          !categorizedChecked[category]![index];
    });
  }

  void _deleteItem(index) {
    setState(() {
      addedItems.removeAt(index);
      checkedItems.removeAt(index);
    });
  }

  void _submitTrip() {
    List<String> selectedItems = [];

    for (int i = 0; i < addedItems.length; i++) {
      if (checkedItems[i]) {
        selectedItems.add(addedItems[i]);
      }
    }

    categorizedItems.forEach((category, items) {
      for (int i = 0; i < items.length; i++) {
        if (categorizedChecked[category]![i]) {
          selectedItems.add(items[i]['item']!);
        }
      }
    });

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

    Trip newTrip = Trip(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      country: widget.country,
      departDate: widget.departDate,
      returnDate: widget.returnDate,
      items: selectedItems,
    );
    Navigator.of(context).pop(newTrip);
  }

  @override
  void dispose() {
    _itemController.dispose();
    super.dispose();
  }

  Widget _buildCategoryCard(String category, List<Map<String, String>> items) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 1,
            offset: Offset(0, 3),
          ),
        ],
      ), //สีของกรอบ
      child: ExpansionTile(
        initiallyExpanded: false,//สถานะตอนเริ่มของ ui เป็นแบบพับอยู่
        tilePadding: EdgeInsets.zero,
        childrenPadding: EdgeInsets.zero,
        title: Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            //ไล่สี
            color: Color(0xFF667eea),
            borderRadius: BorderRadius.circular(9),
          ),
          child: Row(
            children: [
              Icon(getCategoryIcon(category), color: Colors.white, size: 24),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  getCategoryNameThai(category),
                  style: GoogleFonts.kanit(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${items.length} รายการ',
                  style: GoogleFonts.kanit(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final priority = item['priority']!;

              return Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: index < items.length - 1
                        ? BorderSide(color: Colors.grey.shade200)
                        : BorderSide.none,
                  ),
                ),
                child: ListTile(
                  onTap: () => _changeRecommendedChecked(category, index),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 5,
                  ),
                  leading: Checkbox(
                    value: categorizedChecked[category]![index],
                    onChanged: (bool? newValue) {
                      _changeRecommendedChecked(category, index);
                    },
                    activeColor: Colors.green,
                    checkColor: Colors.white,
                  ),
                  title: Text(
                    item['item']!,
                    style: GoogleFonts.kanit(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  trailing: _buildPriorityBadge(priority),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityBadge(String priority) {
    Color backgroundColor, borderColor, textColor;
    String label;

    if (priority == 'essential') {
      backgroundColor = Colors.red.shade50;
      borderColor = Colors.red.shade300;
      textColor = Colors.red.shade700;
      label = 'สำคัญ';
    } else if (priority == 'recommended') {
      backgroundColor = Colors.orange.shade50;
      borderColor = Colors.orange.shade300;
      textColor = Colors.orange.shade700;
      label = 'แนะนำ';
    } else {
      backgroundColor = Colors.green.shade50;
      borderColor = Colors.green.shade300;
      textColor = Colors.green.shade700;
      label = 'ทั่วไป';
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Text(
        label,
        style: GoogleFonts.kanit(
          fontSize: 12,
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildRecommendedSection() {
    if (isLoading) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: Column(
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('กำลังโหลดรายการแนะนำ...', style: GoogleFonts.kanit()),
            ],
          ),
        ),
      );
    }

    if (categorizedItems.isEmpty) {
      return Center(
        child: Text('ไม่พบรายการแนะนำ', style: GoogleFonts.kanit()),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          child: Row(
            children: [
              Icon(
                Icons.recommend,
                color: Color.fromARGB(255, 21, 20, 95),
                size: 24,
              ),
              SizedBox(width: 8),
              Text(
                "รายการแนะนำ",
                style: GoogleFonts.kanit(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 21, 20, 95),
                ),
              ),
            ],
          ),
        ),
        ...categorizedItems.entries.map((entry) {
          return _buildCategoryCard(entry.key, entry.value);
        }).toList(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          "เพิ่มสิ่งของ",
          style: GoogleFonts.kanit(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 21, 20, 95),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                      widget.country,
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
                                formatDateThai(widget.departDate),
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
                                formatDateThai(widget.returnDate),
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
              _buildRecommendedSection(),
              const SizedBox(height: 20),
              if (addedItems.isNotEmpty) ...[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  child: Row(
                    children: [
                      Icon(
                        Icons.add_box,
                        color: Color.fromARGB(255, 21, 20, 95),
                        size: 24,
                      ),
                      SizedBox(width: 8),
                      Text(
                        "รายการของฉัน",
                        style: GoogleFonts.kanit(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 21, 20, 95),
                        ),
                      ),
                    ],
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: addedItems.length,
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
                        onTap: () => _changeValueChecked(index),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 5,
                        ),
                        title: Text(
                          addedItems[index],
                          style: GoogleFonts.kanit(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                        leading: Checkbox(
                          value: checkedItems[index],
                          onChanged: (bool? newValue) =>
                              _changeValueChecked(index),
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
                            onPressed: () => _deleteItem(index),
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
              SizedBox(height: 100),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 10,
                offset: Offset(0, -3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (addedItems.isNotEmpty)
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.all(16),
                    child: TextButton(
                      onPressed: _submitTrip,
                      style: TextButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 55, 196, 50),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        "ยืนยันรายการ",
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
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: TextField(
                          controller: _itemController,
                          decoration: InputDecoration(
                            hintText: "เพิ่มสิ่งของของคุณ...",
                            hintStyle: GoogleFonts.kanit(color: Colors.grey),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 20, 20),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 21, 20, 95),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: IconButton(
                        onPressed: _addItem,
                        icon: Icon(Icons.add, color: Colors.white, size: 30),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
