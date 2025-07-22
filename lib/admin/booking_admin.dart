import 'package:baber_booking_app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BookingAdmin extends StatefulWidget {
  const BookingAdmin({super.key});

  @override
  State<BookingAdmin> createState() => _BookingAdminState();
}

class _BookingAdminState extends State<BookingAdmin> {
  Stream? BookingStream;

  getOnTheLoad() async {
    BookingStream = await DatabaseMethods().getBookings();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getOnTheLoad();
  }

  Widget allBookings() {
    return StreamBuilder(
      stream: BookingStream,
      builder: (context, AsyncSnapshot snapshot) {
        // Trạng thái đang load
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        // Trường hợp không có dữ liệu hoặc danh sách trống
        if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
          return Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(
              bottom: 40,
            ),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Color(0xFFB91635),
                Color(0xff621d3c),
                Color(0xFF311937),
              ]),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.event_busy, color: Colors.white, size: 40),
                const SizedBox(height: 10),
                Text(
                  "Don't have any booking now",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        }

        // Trường hợp có danh sách booking
        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: snapshot.data.docs.length,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data.docs[index];
            return Material(
              elevation: 8,
              borderRadius: BorderRadius.circular(30),
              child: Container(
                padding: EdgeInsets.all(15),
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Color(0xFFB91635),
                    Color(0xff621d3c),
                    Color(0xFF311937),
                  ]),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(60),
                          child: Image.network(
                            ds["Image"],
                            height: 60,
                            width: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Text(
                            "Name: " + ds["Username"],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text("Service: " + ds["Service"],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        )),
                    const SizedBox(height: 5),
                    Text("Date: " + ds["Date"],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        )),
                    const SizedBox(height: 5),
                    Text("Time: " + ds["Time"],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        )),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () async {
                        await DatabaseMethods().DeleteBooking(ds.id);
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        decoration: BoxDecoration(
                          color: Color(0xFFdf711a),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'Done',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(
          top: 50,
          left: 20,
          right: 20,
        ),
        child: Column(
          children: [
            Center(
              child: Text("All Bookings",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            const SizedBox(
              height: 30,
            ),
            Expanded(child: allBookings()),
          ],
        ),
      ),
    );
  }
}
