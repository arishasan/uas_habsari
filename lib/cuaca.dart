import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class CuacaScreen extends StatefulWidget {
  const CuacaScreen({Key? key}) : super(key: key);

  @override
  CuacaScreenState createState() => CuacaScreenState();
}

class CuacaScreenState extends State<CuacaScreen>{

  String namaKota = 'Jakarta';
  String apiKey = '2467327a516846cf9dd223545232607';
  String waktu = '';
  String latitude = '';
  String longitude = '';
  String region = '';

  String terakhirUpdate = '';
  String tempC = '';
  String tempF = '';

  String terasaC = '';
  String terasaF = '';

  String kondisi = '';
  String gambarKondisi = '';

  String kelembapan = '';

  @override
  void initState() {
    super.initState();
    callCuaca();
  }

  Future<void> callCuaca() async {

    SmartDialog.showLoading(
      msg: "Memuat.."
    );
    
    var client = http.Client();
    try {
      var response = await client.get(Uri.parse("https://api.weatherapi.com/v1/current.json?key=$apiKey&q=$namaKota&aqi=no"));
      // var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      // var uri = Uri.parse(decodedResponse['uri'] as String);
      
      // print(jsonDecode(utf8.decode(response.bodyBytes)));
      Map<String, dynamic> decodedMap = jsonDecode(response.body);
      print(decodedMap['location']);
      // print(decodedMap['location']['localtime']);
      print(decodedMap['current']['condition']['icon'].toString().replaceAll("//", ""));
      setState(() {
        waktu = decodedMap['location']['localtime'];
        latitude = decodedMap['location']['lat'].toString();
        longitude = decodedMap['location']['lon'].toString();
        region = decodedMap['location']['region'];

        terakhirUpdate = decodedMap['current']['last_updated'];
        tempC = decodedMap['current']['temp_c'].toString();
        tempF = decodedMap['current']['temp_f'].toString();

        terasaC = decodedMap['current']['feelslike_c'].toString();
        terasaF = decodedMap['current']['feelslike_f'].toString();

        kondisi = decodedMap['current']['condition']['text'];
        gambarKondisi = decodedMap['current']['condition']['icon'].toString().replaceAll("//", "https://");

        kelembapan = decodedMap['current']['humidity'].toString();
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

    Widget containerCuaca(title, sub, icon, isIcon){

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

            isIcon ? Icon(icon) : Image.network(icon),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                sub != '-' ? Text(sub, style: GoogleFonts.poppins(color: Colors.grey),) : const SizedBox.shrink()
              ],
            )

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
        title: Text("Cuaca", 
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
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [

                        Text(region, style: GoogleFonts.poppins(color: Colors.blue),),
                        Text(waktu, style: GoogleFonts.poppins(color: Colors.grey),)

                      ],)
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // ignore: prefer_interpolation_to_compose_strings
                containerCuaca(tempC + "°C", "Terasa Seperti : " + terasaC + "°C", Icons.thermostat, true),
                const SizedBox(height: 10),
                containerCuaca("$tempC°F", "Terasa Seperti : $terasaC°F", Icons.thermostat, true),
                const SizedBox(height: 10),
                gambarKondisi == '' ? const SizedBox.shrink() : containerCuaca("Kondisi", kondisi, gambarKondisi, false),
                const SizedBox(height: 10),
                containerCuaca("Kelembapan", kelembapan, Icons.water_drop, true),

              ],
            )
          )
        ),
      )
    );

  }
}