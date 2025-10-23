import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapplication/data/trip_mockup.dart';
import 'package:myapplication/screens/homescreen/edit_trip_screen.dart';

import 'package:myapplication/widgets/container_show_trip.dart';

class Homeview extends StatefulWidget {
  const Homeview({super.key});

  @override
  State<Homeview> createState() => _HomeviewState();
}

class _HomeviewState extends State<Homeview> {
  List<Trip> trips = List.from(tripExample);

  void _deleteTrip(String tripID) {
    setState(() {
      trips.removeWhere((trip) => trip.id == tripID);
    });
  }

  void _editTrip(Trip trip) async {
    final Trip? updateTrip = await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => EditTripScreen(trip: trip)));
    if (updateTrip != null) {
      setState(() {
        int index = trips.indexWhere((t) => t.id == updateTrip.id);
        if (index != -1) {
          trips[index] = updateTrip;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //ส่วนหัว
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 21, 20, 95),
        title: Text(
          "หน้าจอหลัก",
          style: GoogleFonts.kanit(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      //เนื้อหา
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //แสดงรายการ trip
            Expanded(
              child: ListView.builder(
                itemCount: trips.length,
                itemBuilder: (context, index) {
                  return ContainerShowTrip(
                    trip: trips[index],
                    onDeletePressed: () {
                      _deleteTrip(trips[index].id);
                    },
                    onEditPressed: () {
                      _editTrip(trips[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
