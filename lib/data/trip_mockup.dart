class Trip {
  final String id;
  final String country;
  final DateTime departDate;
  final DateTime returnDate;
  final List<String> items;

  Trip({
    required this.id,
    required this.country,
    required this.departDate,
    required this.returnDate,
    required this.items,
  });
}

List<Trip> tripExample = [
  Trip(
    id: "1",
    country: "Thailand",
    departDate: DateTime(2025, 12, 10),
    returnDate: DateTime(2025, 12, 10),
    items: ["หน้ากาก", "หนังสือ", "ขวดน้ำ"],
  ),
   Trip(
    id: "2",
    country: "Japan",
    departDate: DateTime(2025, 12, 10),
    returnDate: DateTime(2025, 12, 10),
    items: ["หน้ากาก", "หนังสือ", "ขวดน้ำ"],
  ),
   Trip(
    id: "3",
    country: "India",
    departDate: DateTime(2025, 12, 10),
    returnDate: DateTime(2025, 12, 10),
    items: ["หน้ากาก", "หนังสือ", "กระเป๋า"],
  ),
   Trip(
    id: "4",
    country: "Europe",
    departDate: DateTime(2025, 12, 10),
    returnDate: DateTime(2025, 12, 10),
    items: ["หน้ากาก", "หนังสือ", "เก้าอี้", "เก้าอี้", "เก้าอี้", "เก้าอี้", "เก้าอี้", "เก้าอี้", "เก้าอี้", "เก้าอี้", "เก้าอี้", "เก้าอี้", "เก้าอี้", "เก้าอี้", "เก้าอี้"],
  ),
];
