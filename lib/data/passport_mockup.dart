class Passport {
  String passportNumber;
  DateTime issueDate;
  DateTime expiryDate;
  
  bool notificationEnabled;
  int notificationDays;

  Passport({
    required this.passportNumber,
    required this.issueDate,
    required this.expiryDate,
    this.notificationEnabled = true,
    this.notificationDays = 30,
  });
}
List<Passport> passports = [
    Passport(
      passportNumber: 'AB1234567',
      issueDate: DateTime(2024, 1, 15),
      expiryDate: DateTime(2034, 1, 22),
    ),
    Passport(
      passportNumber: 'CD9876543',
      issueDate: DateTime(2020, 6, 10),
      expiryDate: DateTime(2025, 6, 19),
    ),
  ];
