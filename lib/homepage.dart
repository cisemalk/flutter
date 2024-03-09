import 'dart:convert';
import 'package:bitirmeprojesi/payment.dart';
import 'package:bitirmeprojesi/username.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:bitirmeprojesi/logout.dart';
import 'package:bitirmeprojesi/filter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bitirmeprojesi/login.dart';

import 'newhomepage.dart';

class Ticket {
  final int id;
  final String from;
  final String to;
  final String departureDate;
  final String returnDate;
  final String nofSeats;
  final String price;

  Ticket({
    required this.id,
    required this.from,
    required this.to,
    required this.departureDate,
    required this.returnDate,
    required this.nofSeats,
    required this.price,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['ID'],
      from: json['From'],
      to: json['To'],
      departureDate: json['DepartureDate'],
      returnDate: json['ReturnDate'],
      nofSeats: json['NofSeats'],
      price: json['Price'],
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  final List<Ticket> filteredTickets;
  HomePage({required this.filteredTickets});
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic>? paymentIntent1;
  //final String username;
  List<Ticket> tickets = [];

  Future<void> fetchTickets() async {
    final response = await http.get(Uri.parse('http://10.0.2.2/filtertickets'));
    if (response.statusCode == 200) {
      final List<dynamic> ticketData = jsonDecode(response.body);
      setState(() {
        tickets = ticketData.map((json) => Ticket.fromJson(json)).toList();
      });
    } else {
      throw Exception('Failed to fetch tickets');
    }
  }

  Future<void> fetchUser() async {
    final response = await http.get(Uri.parse('http://10.0.2.2/users/:id'));
    if (response.statusCode == 200) {
      final dynamic userData = jsonDecode(response.body);
      final String fetchedUsername = userData['username']; // Assuming the username key in the response is 'username'
      setState(() {
        //username = fetchedUsername;
      });
    } else {
      throw Exception('Failed to fetch username');
    }
  }

  @override
  void initState() {
    super.initState();
    tickets = widget.filteredTickets;
    fetchUser();
  }

  void bookTicket(Ticket ticket) async {
    final url = Uri.http('10.0.2.2', '/tickets/${ticket.id}/book');

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token != null) {
        final response = await http.post(
          url,
          headers: {
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          // Ticket booked successfully, handle the response if needed
          print('Ticket booked successfully');
        } else {
          // Booking failed, show an error message
          print('Failed to book the ticket');
        }
      } else {
        // Token not found in local storage, handle the error
        print('User token not available');
      }
    } catch (e) {
      // Exception occurred, show an error message
      print('An error occurred while booking the ticket: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final username = userProvider.username;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 26, 27, 28),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
            'Biletler',
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
                colors: <Color>[Color.fromARGB(255, 55, 150, 173), Color.fromARGB(255, 76, 189, 217)]),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: tickets.length,
        itemBuilder: (context, index) {
          final ticket = tickets[index];
          return Container(
            margin: EdgeInsets.all(13.0),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 49, 56, 59),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.only(left: 15, bottom: 0, right: 20, top: 5),
              leading: Icon(Icons.flight_takeoff,size: 60,color: Color.fromARGB(255, 86, 149, 168),),
              title: Text(ticket.from + ' - ' + ticket.to,
                  style: GoogleFonts.sulphurPoint(
                    textStyle: TextStyle(
                      color: Color.fromARGB(255, 223, 236, 240),
                      fontWeight: FontWeight.w800,
                      fontSize: 19
                    ),
                  )),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Kalkış Günü: ${ticket.departureDate}',
                    style: GoogleFonts.manrope(
                      textStyle: TextStyle(
                        color: Color.fromARGB(255, 223, 236, 240),
                      ),
                    )),
                  Text('Yolcu Başına ${ticket.price} TL',
                      style: GoogleFonts.manrope(
                        textStyle: TextStyle(
                          color: Color.fromARGB(255, 223, 236, 240),
                        ),
                      )),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(255, 242, 75, 41),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)
                      ),
                      minimumSize: Size(100, 30),
                    ),
                      onPressed: () async {
                    await makePayment('${ticket.price}00', ticket);
                  },
                      child: Text('Satın almak için tıkla',
                      style: GoogleFonts.manrope(
                        textStyle: TextStyle(
                          color: Colors.white
                        )
                      ),)),
                ],
              ),
            ),
          );
        },
      ),

      floatingActionButton: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: CircleBorder(),
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 20),
          primary: Color.fromARGB(255, 211, 121, 206),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FilterPage(),
            ),
          );
        },
        child: Icon(Icons.arrow_back,size: 20,)
      ),
      drawer: NavigationDrawer(username: username),
    );
  }

  Future<void> makePayment(String x, Ticket ticket) async {
    try {
      paymentIntent1 = await createPaymentIntent(x, 'TRY');

      var gpay = PaymentSheetGooglePay(
        merchantCountryCode: "GB",
        currencyCode: "GBP",
        testEnv: true,
      );

      // STEP 2: Initialize Payment Sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent1!['client_secret'],
          // Gotten from payment intent
          style: ThemeMode.light,
          merchantDisplayName: '-',
          googlePay: gpay,
        ),
      );

      // STEP 3: Display Payment sheet
      await displayPaymentSheet();

      // If the execution reaches this point, it means the payment is completed.
      bookTicket(ticket); // Record the booked ticket after successful payment
    } catch (err) {
      print(err);
    }
  }



  Future<void> displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      print('Payment completed');
    } catch (e) {
      print('Payment failed: $e');
    }
  }



  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer sk_test_51N47abJUGIzbNFsGC9dTNUb67Fa8nIi10F77uSNxp7o3bKp9pcTw0Zwgiu1qYXAmt5ce711cpoH4jzQJtI6kTCYJ00Vz12hAoR',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      return json.decode(response.body);
    } catch (err) {
      throw Exception(err.toString());
    }
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
