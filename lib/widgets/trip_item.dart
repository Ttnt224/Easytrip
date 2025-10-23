import 'package:flutter/material.dart';

class TripItem extends StatelessWidget {
  const TripItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: ListTile(
        onTap: (){
          print("click on item");
        },
        contentPadding: EdgeInsets.symmetric(horizontal: 20 ,vertical: 5),
        tileColor: Colors.grey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(20)
        ),
        title: Text("Hello",style: TextStyle(fontSize: 16,color: Colors.white),),
        leading: Icon(Icons.check_box,color: Colors.white,),
      ),
    );
  }
}

///เอาไว้แสดง item แนะนำ จาก ai ยังไม่ได้ใช้