import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class JadwalShalatScreen extends StatefulWidget {
  const JadwalShalatScreen({Key? key}) : super(key: key);

  @override
  JadwalShalatScreenState createState() => JadwalShalatScreenState();
}

class JadwalShalatScreenState extends State<JadwalShalatScreen>{

  String namaKota = 'Jakarta';
  int locationID = 12726;
  DateTime tanggal = DateTime.now();
  String shubuh = '';
  String dzuhur = '';
  String ashar = '';
  String maghrib = '';
  String isya = '';

  @override
  void initState() {
    super.initState();
    callJadwalShalat();
  }

  Future<void> callJadwalShalat() async {

    SmartDialog.showLoading(
      msg: "Memuat.."
    );
    
    var client = http.Client();
    try {
      var response = await client.get(Uri.parse("https://prayertimes.api.abdus.dev/api/diyanet/prayertimes?location_id=$locationID"));
      // var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      // var uri = Uri.parse(decodedResponse['uri'] as String);
      
      // print(jsonDecode(utf8.decode(response.bodyBytes)));
      List<dynamic> decodedMap = jsonDecode(response.body);
      print(decodedMap[0]);
      setState(() {
        shubuh = decodedMap[0]['fajr'];
        dzuhur = decodedMap[0]['dhuhr'];
        ashar = decodedMap[0]['asr'];
        maghrib = decodedMap[0]['maghrib'];
        isya = decodedMap[0]['isha'];
      });

    } finally {
      client.close();
    }

    SmartDialog.dismiss(); 

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    Widget containerWaktu(title, sub){

      return Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(
            Radius.circular(10)
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(2, 2), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            Text(title, style: GoogleFonts.poppins()),
            Text(sub, style: GoogleFonts.poppins(color: Colors.blue),)

          ],
        )
      );

    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // leading: Padding(
        //   padding: EdgeInsets.only(left: orientasi == 'landscape' ? 20 : 0),
        //   child: InkWell(
        //     onTap: (){
        //       Navigator.pop(context);
        //     },
        //     child: const Icon(Icons.arrow_back, color: Colors.black),
        //   ),
        // ),
        title: Text("Jadwal Shalat", 
          style: GoogleFonts.poppins(
          )
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: RawScrollbar(
          child: SingleChildScrollView(
            child: Column(
              children: [

                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10)
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: const Offset(2, 2), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.pin_drop, color: Colors.blue),
                      Column(
                        children: [

                        Text("Lokasi", style: GoogleFonts.poppins()),
                        Text(namaKota, style: GoogleFonts.poppins(color: Colors.blue),)

                      ],)
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                containerWaktu("Shubuh", shubuh),
                const SizedBox(height: 10),
                containerWaktu("Dzuhur", dzuhur),
                const SizedBox(height: 10),
                containerWaktu("Ashar", ashar),
                const SizedBox(height: 10),
                containerWaktu("Maghrib", maghrib),
                const SizedBox(height: 10),
                containerWaktu("Isya", isya),

              ],
            )
          )
        ),
      )
    );

  }
}