import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:myapplication/data/trip_mockup.dart';
import 'package:myapplication/noti_service.dart';
import 'package:myapplication/screens/homescreen/check_trip_screen.dart';
import 'package:myapplication/widgets/confimation_alert_dialog.dart';

class ContainerShowTrip extends StatefulWidget {
  final Trip trip;
  final VoidCallback onDeletePressed;
  final VoidCallback onEditPressed;
  const ContainerShowTrip({
    super.key,
    required this.trip,
    required this.onDeletePressed,
    required this.onEditPressed,
  });

  @override
  State<ContainerShowTrip> createState() => _ContainerShowTripState();
}

class _ContainerShowTripState extends State<ContainerShowTrip> {
  DateTime? selectedDateTime;
  final NotificationService _notificationService = NotificationService();
  bool _isNotificationSet = false;

  @override
  void initState() {
    super.initState();
    _checkExistingNotification();
  }

  // ตรวจสอบว่ามีการตั้งการแจ้งเตือนไว้หรือไม่
  Future<void> _checkExistingNotification() async {
    final pendingNotifications = await _notificationService
        .getPendingNotifications();
    final notificationId = widget.trip.hashCode;

    setState(() {
      _isNotificationSet = pendingNotifications.any(
        (notification) => notification.id == notificationId,
      );
    });
  }

  String formatDateThai(DateTime date) {
    return DateFormat('d MMMM yyyy', 'th').format(date);
  }

  String formatDateTimeThai(DateTime date) {
    return DateFormat('d MMMM yyyy HH:mm', 'th').format(date);
  }

  Future<void> _selectDateTime(BuildContext context) async {
    // เลือกวันที่ก่อน
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateTime ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: Color(0xFF1A237E)),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate == null) return;

    // เลือกเวลา
    if (!mounted) return;
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedDateTime != null
          ? TimeOfDay.fromDateTime(selectedDateTime!)
          : TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: Color(0xFF1A237E)),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime == null) return;

    // รวมวันที่และเวลา
    final DateTime newDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    // ตรวจสอบว่าเวลาที่เลือกไม่ใช่เวลาในอดีต
    if (newDateTime.isBefore(DateTime.now())) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('เวลาไม่ถูกต้อง', style: GoogleFonts.kanit()),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      selectedDateTime = newDateTime;
    });

    // ตั้งการแจ้งเตือน
    await _scheduleNotification(newDateTime);
  }

  Future<void> _scheduleNotification(DateTime dateTime) async {
    final notificationId = widget.trip.hashCode;

    await _notificationService.scheduleTripNotification(
      id: notificationId,
      title: 'เตรียมตัวเดินทาง: ${widget.trip.country}',
      body:
          'อย่าลืมเตรียมสิ่งของ ${widget.trip.items.length} รายการสำหรับการเดินทาง',
      scheduledDate: dateTime,
      payload: widget.trip.country,
    );

    setState(() {
      _isNotificationSet = true;
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'ตั้งการแจ้งเตือนสำเร็จ: ${formatDateTimeThai(dateTime)}',
          style: GoogleFonts.kanit(),
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _clearDateTime() async {
    final notificationId = widget.trip.hashCode;

    // ยกเลิกการแจ้งเตือน
    await _notificationService.cancelNotification(notificationId);

    setState(() {
      selectedDateTime = null;
      _isNotificationSet = false;
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('ยกเลิกการแจ้งเตือนแล้ว', style: GoogleFonts.kanit()),
        backgroundColor: Colors.orange,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        //#1 ลบ height 230 ออก
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 220, 220, 220),
              blurRadius: 10,
              spreadRadius: 1,
              offset: Offset(0, 3),
            ),
          ],
        ),
        //#2 เปลี่ยน Stack ให้เป็น column
        child: Column(
          children: [
            //#2.5 คลุม Row() ด้วย padding
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Container(
                    height: 120,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: NetworkImage(
                          "https://img.freepik.com/premium-vector/travelers-concept-illustration_114360-2602.jpg",
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  //#3 คลุม column() ด้วย expanded
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //#4 สร้าง Row() แล้วเอา text ที่แสดงชื่อประเทศมาใส่เเล้วก็คลุมด้วย text นั้น expanded อีกที เพิ่มสีด้วย
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.trip.country,
                                style: GoogleFonts.kanit(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1A237E),
                                ),
                              ),
                            ),
                            //#5 ไปก็อป Row() มาที่มันอยู่ตรง position มาเพิ่มตรงนี้แทน เเล้วก็ลบตรง postion ออกได้เลย(ที่ก็อปมาแค่ส่วน row นะ)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: widget.onEditPressed,
                                  icon: Icon(Icons.edit),
                                  iconSize: 20,
                                ),
                                IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return ConfirmationDialog(
                                          content: Text(
                                            "คุณแน่ใจเเล้วใช่ไหมว่าต้องการลบข้อมูลนี้",
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.kanit(),
                                          ),
                                          onConfirm: () async {
                                            // ยกเลิกการแจ้งเตือนก่อนลบ
                                            await _notificationService
                                                .cancelNotification(
                                                  widget.trip.hashCode,
                                                );
                                            widget.onDeletePressed();
                                          },
                                          icon: Icon(
                                            Icons.info,
                                            color: Colors.red,
                                            size: 50,
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  icon: Icon(Icons.delete),
                                  iconSize: 20,
                                ),
                              ],
                            ),
                          ], //#5 จบ
                        ), //#4 จบ

                        const SizedBox(height: 15),
                        //#6 เพิ่ม icon ให้ตัวแสดงวันที่เดินทางและกลับจากเดินทาง คลุม Row() ให้ text แต่ละอัน
                        Row(
                          children: [
                            Icon(
                              Icons.event_available,
                              size: 16,
                              color: Colors.grey.shade600,
                            ),
                            SizedBox(height: 6),
                            Text(
                              formatDateThai(widget.trip.departDate),
                              style: GoogleFonts.kanit(
                                fontSize: 15,
                                color:
                                    Colors.grey.shade700, // เพิ่มบรรทัดนี้ด้วย
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.event_available,
                              size: 16,
                              color: Colors.grey.shade600,
                            ),
                            SizedBox(height: 6),
                            Text(
                              formatDateThai(widget.trip.returnDate),
                              style: GoogleFonts.kanit(
                                fontSize: 15,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        //#7 คลุม text ที่แสดงจำนวนของด้วย Row() เพิ่ม Icon เข้าไป
                        //#9 คลุม Row() ด้วย Container เเล้วก็ก็อป padding กับ decoration ไปใส่เลย
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color:  Color(0xFF1A237E).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.backpack,
                                size: 16,
                                color: Color(0xFF1A237E),
                              ),
                              SizedBox(width: 6),
                              Text(
                                "${widget.trip.items.length} รายการ", //แก้คำตรงนี้ด้วย
                                //#8 เพิ่มสีให้ตัวอักษร
                                style: GoogleFonts.kanit(
                                  fontSize: 15,
                                  color: Color(0xFF1A237E),
                                  fontWeight: FontWeight.w600,
                                ),
                              ), //#8 จบ
                            ],
                          ),
                        ), //#7 จบ
                        const SizedBox(height: 15),
                      ],
                    ),
                  ), //#3 จบ
                ],
              ),
            ),

            //#10 เพิ่ม เส้น
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Divider(height: 1, color: Colors.grey.shade300),
            ), //#จบ 10

            //#9 ก็อป Elevatebutton ปุ่มกด กับ Row ออกมาจาก column อันเดิมเเล้วเอามาใส่ column นอกสุดแทน สลับตำแหน่งของ 2 อันนี้ด้วย เอาปุ่มไปไว้ด้านล่าง แล้วก็เปลี่ยน Icon button เป็น Icon ธรรมดา
            //จากนั้นก็ คุลม Row() ด้วย column เเล้วก็คลุมด้วย padding อีกที
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.notifications_outlined,
                        size: 20,
                        color: Color(0xFF1A237E),
                      ),
                      //#11 เพิ่ม text มา
                      SizedBox(width: 8),
                      Text(
                        "ตั้งการแจ้งเตือน",
                        style: GoogleFonts.kanit(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A237E),
                        ),
                      ), //#11 จบ
                      //#12 แก้ if เป็นอันนี้
                      Spacer(),
                      if (_isNotificationSet || selectedDateTime != null)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.check_circle,
                                size: 14,
                                color: Colors.orange.shade700,
                              ),
                              SizedBox(width: 4),
                              Text(
                                "เปิดใช้งาน",
                                style: GoogleFonts.kanit(
                                  fontSize: 12,
                                  color: Colors.orange.shade700,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 12),
                  //#13 สร้าง container ใน column ไม่ใช่ row  นะ
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: selectedDateTime != null
                          ? Colors.orange.shade50
                          : Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selectedDateTime != null
                            ? Colors.orange.shade200
                            : Colors.grey.shade200,
                        width: 1,
                      ),
                    ),
                    child: selectedDateTime != null
                        ? Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "จะแจ้งเตือนในวันที่",
                                      style: GoogleFonts.kanit(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.calendar_month,
                                          size: 18,
                                          color: Colors.orange.shade700,
                                        ),
                                        SizedBox(width: 6),
                                        Text(
                                          formatDateTimeThai(selectedDateTime!),
                                          style: GoogleFonts.kanit(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.orange.shade900,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: _clearDateTime,
                                icon: Icon(
                                  Icons.close,
                                  color: Colors.orange.shade700,
                                ),
                                style: IconButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  padding: EdgeInsets.all(8),
                                ),
                              ),
                            ],
                          )
                        : InkWell(
                            onTap: () => _selectDateTime(context),
                            borderRadius: BorderRadius.circular(12),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.notifications_active_outlined,
                                    color: Colors.grey.shade600,
                                    size: 22,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    "เลือกวันและเวลาที่ต้องการแจ้งเตือน",
                                    style: GoogleFonts.kanit(
                                      fontSize: 14,
                                      color: Colors.grey.shade600,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
            //#14 คลุม Elevatebutton ด้วย Sizebox เเล้วก็คลุมด้วย padding อีกที
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF1A237E),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CheckTripScreen(trip: widget.trip),
                      ),
                    );
                  },
                  child: Text(
                    "ตรวจสอบสิ่งของ",
                    style: GoogleFonts.kanit(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ), //#2 จบ
      ),
    );
  }
}
