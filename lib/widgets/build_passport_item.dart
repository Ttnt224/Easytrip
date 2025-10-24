import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:myapplication/data/passport_mockup.dart';
import 'package:myapplication/noti_service.dart';

class BuildPassportItem extends StatefulWidget {
  final String numpassport;
  final Passport passport;
  final List<Widget> children;
  final VoidCallback? onEditPressed;
  final VoidCallback? onDeletePressed;
  const BuildPassportItem({
    super.key,
    required this.passport,
    required this.numpassport,
    required this.children,
    this.onEditPressed,
    this.onDeletePressed,
  });

  @override
  State<BuildPassportItem> createState() => _BuildPassportItemState();
}

class _BuildPassportItemState extends State<BuildPassportItem> {
  DateTime? selectedDate;
  final NotificationService _notificationService = NotificationService();
  bool _isNotificationSet = false;

  @override
  void initState() {
    super.initState();
    _checkExistingNotification();
  }

  Future<void> _checkExistingNotification() async {
    final pendingNotifications = await _notificationService
        .getPendingNotifications();
    final notificationId = widget.passport.hashCode;

    setState(() {
      _isNotificationSet = pendingNotifications.any(
        (notification) => notification.id == notificationId,
      );
    });
  }

  String formatDateThai(DateTime date) {
    return DateFormat('d MMMM yyyy', 'th').format(date);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
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

    // ตั้งเวลาเป็น 09:00 น. ของวันที่เลือก
    final DateTime dateTimeWithTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      9,
      0,
    );

    // ตรวจสอบว่าเวลาไม่ใช่อดีต
    if (dateTimeWithTime.isBefore(DateTime.now())) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('วันที่ไม่ถูกต้อง', style: GoogleFonts.kanit()),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      selectedDate = dateTimeWithTime;
    });

    // ตั้งการแจ้งเตือน
    await _scheduleNotification(dateTimeWithTime);
  }

  Future<void> _scheduleNotification(DateTime dateTime) async {
    final notificationId = widget.passport.hashCode;

    // คำนวณจำนวนวันที่เหลือก่อนหมดอายุ
    final daysUntilExpiry = widget.passport.expiryDate
        .difference(dateTime)
        .inDays;

    await _notificationService.scheduleTripNotification(
      id: notificationId,
      title: 'เตือนความจำ: พาสปอร์ต ${widget.numpassport}',
      body: daysUntilExpiry > 0
          ? 'พาสปอร์ตของคุณจะหมดอายุในอีก $daysUntilExpiry วัน'
          : 'ตรวจสอบวันหมดอายุพาสปอร์ตของคุณ',
      scheduledDate: dateTime,
      payload: widget.numpassport,
    );

    setState(() {
      _isNotificationSet = true;
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'ตั้งการแจ้งเตือนสำเร็จ: ${formatDateThai(dateTime)}',
          style: GoogleFonts.kanit(),
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _clearDateTime() async {
    final notificationId = widget.passport.hashCode;

    await _notificationService.cancelNotification(notificationId);

    setState(() {
      selectedDate = null;
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
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.numpassport,
                  style: GoogleFonts.kanit(fontSize: 18),
                ),
              ),
              IconButton(
                onPressed: widget.onEditPressed,
                icon: Icon(Icons.edit),
              ),
              IconButton(
                onPressed: () async {
                  // ยกเลิกการแจ้งเตือนก่อนลบ
                  await _notificationService.cancelNotification(
                    widget.passport.hashCode,
                  );
                  if (widget.onDeletePressed != null) {
                    widget.onDeletePressed!();
                  }
                },
                icon: Icon(Icons.delete),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...widget.children,
          const SizedBox(height: 10),
          //#1 เพิ่ม เส้น
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Divider(height: 1, color: Colors.grey.shade300),
          ), //#จบ 1
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Row(
                  children: [
                    //#2 เพิ่ม icon
                    Icon(
                      Icons.notifications_outlined,
                      size: 20,
                      color: Color(0xFF1A237E),
                    ), //#2 จบ
                    //#3 เพิ่ม text มา
                    SizedBox(width: 8),
                    Text(
                      "ตั้งการแจ้งเตือน",
                      style: GoogleFonts.kanit(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A237E),
                      ),
                    ), //#3 จบ
                    Spacer(),
                    if (_isNotificationSet || selectedDate != null)
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
                //#4 สร้าง container ใน column ไม่ใช่ row  นะ
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: selectedDate != null
                        ? Colors.orange.shade50
                        : Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: selectedDate != null
                          ? Colors.orange.shade200
                          : Colors.grey.shade200,
                      width: 1,
                    ),
                  ),
                  child: selectedDate != null
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
                                        formatDateThai(selectedDate!),
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
                          onTap: () => _selectDate(context),
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
                                  "เลือกวันที่ต้องการแจ้งเตือน",
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
        ],
      ),
    );
  }
}
