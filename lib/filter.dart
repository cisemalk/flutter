import 'package:bitirmeprojesi/username.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bitirmeprojesi/register.dart';
import 'package:bitirmeprojesi/homepage.dart';
import 'package:bitirmeprojesi/login.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bitirmeprojesi/newhomepage.dart';

import 'logout.dart';

class FilterPage extends StatefulWidget {
  //final String? username;
  //const FilterPage({Key? key, this.username}) : super(key: key);
  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  final List<String> cities = ['İstanbul', 'İzmir', 'Ankara', 'Antalya', 'Berlin'];
  String selectedFrom = 'İstanbul';
  String selectedTo = 'İstanbul';
  DateTime? selectedDepartureDate;
  DateTime? selectedReturnDate;

  void filterTickets() async {
    if (selectedFrom == null ||
        selectedTo == null ||
        selectedDepartureDate == null ||
        selectedReturnDate == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Filtering Error'),
            content: Text('Lütfen bütün alanları doldurunuz.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      // Prepare the filter criteria
      final queryParams = {
        'from': selectedFrom,
        'to': selectedTo,
        'departuredate':
        DateFormat('yyyy-MM-dd').format(selectedDepartureDate!),
        'returndate': DateFormat('yyyy-MM-dd').format(selectedReturnDate!),
      };

      final url = Uri.http('10.0.2.2', '/filtertickets', queryParams);

      try {
        final response = await http.get(url);

        if (response.statusCode == 200) {
          final List<dynamic> ticketData = jsonDecode(response.body);
          List<Ticket> filteredTickets =
          ticketData.map((json) => Ticket.fromJson(json)).toList();

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(filteredTickets: filteredTickets),
            ),
          );
        } else {
          // Filtering failed, show an error message
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Filtering Error'),
                content: Text('An error occurred while filtering tickets.'),
                actions: [
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      } catch (e) {
        // Exception occurred, show an error message
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Filtering Error'),
              content: Text('An error occurred while filtering tickets.'),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final username = userProvider.username;
    Future<void> _selectDepartureDate() async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100),
        builder: (context, child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.light(
                primary: Color.fromARGB(255, 161, 80, 157), // <-- SEE HERE
                onPrimary: Colors.white, // <-- SEE HERE
                onSurface: Color.fromARGB(255, 255, 179, 251), // <-- SEE HERE
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                    primary: Color.fromARGB(255, 255, 179, 251) // button text color
                ),
              ),
            ),
            child: child!,
          );
        },
      );
      if (picked != null) {
        final formatter = DateFormat('yyyy-MM-dd');
        final formattedDate = formatter.format(picked);
        setState(() {
          selectedDepartureDate = DateFormat('yyyy-MM-dd').parse(formattedDate);
        });
      }
    }

    Future<void> _selectReturnDate() async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100),
        builder: (context, child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.light(
                primary: Color.fromARGB(255, 161, 80, 157), // <-- SEE HERE
                onPrimary: Colors.white, // <-- SEE HERE
                onSurface: Color.fromARGB(255, 255, 179, 251), // <-- SEE HERE
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  primary: Color.fromARGB(255, 255, 179, 251) // button text color
                ),
              ),
            ),
            child: child!,
          );
        },
      );
      if (picked != null) {
        final formatter = DateFormat('yyyy-MM-dd');
        final formattedDate = formatter.format(picked);
        setState(() {
          selectedReturnDate = DateFormat('yyyy-MM-dd').parse(formattedDate);
        });
      }
    }

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 26, 27, 28),
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Bilet Ara',
            style: GoogleFonts.manrope(
              textStyle: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.w300,
              ),
            )
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[Color.fromARGB(255, 161, 80, 157), Color.fromARGB(255, 180, 97, 187)]),
            ),
          ),
        ),
    body: Padding(
        //padding: EdgeInsets.only(left: 20, bottom: 0, right: 20, top: 40),
      padding: EdgeInsets.all(70),
        child: Column(
          children: [
                Text(
                  'Nereden:',
                  style: GoogleFonts.manrope(
                    textStyle:TextStyle(fontSize: 26,
                      color: Color.fromARGB(255, 250, 212, 248),),
                  ),
                  ),
                SizedBox(height: 5.0),
                Container(
                  padding: EdgeInsets.all(13.5),
                  height: 45.6,
                  decoration: BoxDecoration(
                    color:Color.fromARGB(255, 62, 51, 69),
                    borderRadius: BorderRadius.circular(10.0)
                  ),
                  child:DropdownButton<String>(
                    value: selectedFrom,
                    underline: SizedBox(), //removing underline
                    dropdownColor:Color.fromARGB(255,62, 51, 69),
                    borderRadius: BorderRadius.circular(10.0),
                    style: GoogleFonts.manrope(
                      textStyle:TextStyle(fontSize: 17,
                        color: Colors.white,),
                    ),
                    hint: Text('Neredendds'),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedFrom = newValue!;
                      });
                    },
                    items: cities.map((String city) {
                      return DropdownMenuItem<String>(
                        value: city,
                        child: Text(city,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                ),

            SizedBox(height:20.0),

            Text(
              'Nereye:',
              style: GoogleFonts.manrope(
                textStyle:TextStyle(fontSize: 26,
                  color: Color.fromARGB(255, 250, 212, 248),),
              ),
            ),
            SizedBox(height:5.0),

                Container(
                  padding: EdgeInsets.all(13.5),
                  height: 45.6,
                  decoration: BoxDecoration(
                      color:Color.fromARGB(255, 62, 51, 69),
                      borderRadius: BorderRadius.circular(10.0)
                  ),
                  child: DropdownButton<String>(
                    value: selectedTo,
                    underline: SizedBox(), //removing underline
                    dropdownColor:Color.fromARGB(255, 62, 51, 69),
                    borderRadius: BorderRadius.circular(10.0),
                    style: GoogleFonts.manrope(
                      textStyle:TextStyle(fontSize: 17,
                        color: Colors.white,),
                    ),
                    hint: Text('Neredendds'),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedTo = newValue!;
                      });
                    },
                    items: cities.map((String city) {
                      return DropdownMenuItem<String>(
                        value: city,
                        child: Text(city,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

            SizedBox(height: 30.0),

            Text(
              'Gidiş Tarihi Seçiniz:',
              style: GoogleFonts.manrope(
                textStyle:TextStyle(fontSize: 26,
                  color: Color.fromARGB(255, 250, 212, 248),),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 161, 80, 157),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)
                ),
                //onPrimary: Colors.orange,
                minimumSize: Size(100, 40),
              ),
              onPressed: _selectDepartureDate,
              child: Text(
                style: GoogleFonts.manrope(
                  textStyle: TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                selectedDepartureDate == null
                    ? 'Gidiş tarihini seç'
                    : 'Gidiş Tarihi: ${selectedDepartureDate.toString().split(' ')[0]}',
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Dönüş Tarihi Seçiniz:',
              style: GoogleFonts.manrope(
                textStyle:TextStyle(fontSize: 26,
                  color: Color.fromARGB(255, 250, 212, 248),),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 161, 80, 157),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)
                ),
                //onPrimary: Colors.orange,
                minimumSize: Size(100, 40),
              ),
              onPressed: _selectReturnDate,
              child: Text(
                  style: GoogleFonts.manrope(
                    textStyle: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                selectedReturnDate == null
                    ? 'Dönüş tarihini seç'
                    : 'Dönüş Tarihi: ${selectedReturnDate.toString().split(' ')[0]}',
              ),
            ),
            SizedBox(height: 30.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 76, 189, 217),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)
                ),
                //onPrimary: Colors.orange,
                minimumSize: Size(100, 50),
              ),
              onPressed: filterTickets,
              child: Text( 'Uygun bileti bul!',
                style: GoogleFonts.manrope(
                  textStyle: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
            ),
            )],
        ),
      ),
      drawer: NavigationDrawer(username: username),
    );
  }
}
class NavigationDrawer extends StatelessWidget {
  final String username;
  void removeTokenFromLocalStorage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
  }
  const NavigationDrawer({Key? key, required this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      Drawer(
          child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    buildHeader(context),
                    buildMenuItems(context),
                  ]
              )
          )
      );

  Widget buildHeader(BuildContext context) =>
      Container(
        color: Color.fromARGB(255, 161, 80, 157),
        padding: EdgeInsets.only(
            top: 60 + MediaQuery
                .of(context)
                .padding
                .top,
            bottom: 0
        ),
        child: Column(
          children: [
            Image.asset(
                'assets/logoapp.png',
                width: 240,
                height: 230,
                fit:BoxFit.fitWidth
            ),
            Text('Merhaba, $username',
                style: GoogleFonts.bebasNeue(
                  textStyle: TextStyle(
                    fontSize: 40,
                    color: Colors.white,
                  ),)
            ),

            SizedBox(height: 20),
          ],
        ),
      );

  Widget buildMenuItems(BuildContext context) =>
      Container(
          padding: const EdgeInsets.all(20),
          color: Color.fromARGB(255, 26, 27, 28),
          child: Wrap(
            runSpacing: 16,
            children: [
              ListTile(
                leading: const Icon(Icons.home_outlined,color: Colors.white,),
                title: const Text('Anasayfa',style: TextStyle(color: Colors.white),),
                onTap: () =>
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => NewHomePage(),
                    )),
              ),
              ListTile(
                leading: const Icon(Icons.airplane_ticket,color: Colors.white,),
                title: const Text('Bilet Satın Al',style: TextStyle(color: Colors.white),),
                onTap: () =>
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => FilterPage(),
                    )),
              ),
              ListTile(
                leading: const Icon(Icons.logout_outlined,color: Colors.white,),
                title: const Text('Çıkış yap',style: TextStyle(color: Colors.white),),
                onTap: () {
                  removeTokenFromLocalStorage();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/login',
                          (Route<dynamic> route) =>
                      false); // navigate to the login page
                },
              ),
              ListTile(
                title: const Text(''),
              ),
              ListTile(
                title: const Text(''),
              ),
              ListTile(
                title: const Text(''),
              ),
              ListTile(
                title: const Text(''),
              ),
            ],
          )
      );
}

