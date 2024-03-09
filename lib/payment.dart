import 'dart:convert';
import 'package:bitirmeprojesi/filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:bitirmeprojesi/logout.dart';
import 'package:bitirmeprojesi/homepage.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  Map<String, dynamic>? paymentIntent1;
  //Map<String, dynamic>? paymentIntent2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detaylar'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[Color.fromARGB(255, 14, 21, 48), Color.fromARGB(255, 27, 56, 143)]),
          ),
        ),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              child: const Text('Ödemeyi başlatmak için tıklayınız.'),
              onPressed: () async {
                await makePayment('50000');
              },
              style: TextButton.styleFrom(
                primary: Colors.pink,
                backgroundColor: Colors.blue.shade200,
              ),
            ),
          ],
        ),
      ),
      drawer: const NavigationDrawer(),
    );
  }




  Future<void> makePayment( String x ) async {
    try {
      paymentIntent1 = await createPaymentIntent(x, 'TRY');

      var gpay = PaymentSheetGooglePay(merchantCountryCode: "GB",
          currencyCode: "GBP",
          testEnv: true);

      //STEP 2: Initialize Payment Sheet
      await Stripe.instance
          .initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: paymentIntent1![
              'client_secret'], //Gotten from payment intent
              style: ThemeMode.light,
              merchantDisplayName: '-',
              googlePay: gpay))
          .then((value) {});

      //STEP 3: Display Payment sheet
      displayPaymentSheet();
    } catch (err) {
      print(err);
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        print("Payment Successfully");
      });
    } catch (e) {
      print('$e');
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
  const NavigationDrawer({Key? key}) : super(key: key);

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
        color: Color.fromARGB(255, 30, 40, 120),
        padding: EdgeInsets.only(
            top: 60 + MediaQuery
                .of(context)
                .padding
                .top,
            bottom: 50
        ),
        child: Column(
          children: const [
            CircleAvatar(
              radius: 55,
              backgroundImage: NetworkImage(
                  'https://t3.ftcdn.net/jpg/00/64/67/52/360_F_64675209_7ve2XQANuzuHjMZXP3aIYIpsDKEbF5dD.jpg'),
            ),
            SizedBox(height: 12),
            Text(
                'Kullanıcı adı',
                style: TextStyle(fontSize: 28,
                    fontWeight: FontWeight.w300,
                    color: Colors.white)
            ),
            Text(
                'mail',
                style: TextStyle(fontSize: 16, color: Colors.white)
            ),
          ],
        ),
      );

  Widget buildMenuItems(BuildContext context) =>
      Container(
          padding: const EdgeInsets.all(24),
          child: Wrap(
            runSpacing: 16,
            children: [
              ListTile(
                leading: const Icon(Icons.home_outlined),
                title: const Text('Anasayfa'),
                onTap: () =>
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => FilterPage(),
                    )),
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Ayarlar'),
                onTap: () {},
              ),
              //const Divider(color: Colors.grey),
              ListTile(
                leading: const Icon(Icons.airplane_ticket),
                title: const Text('Check-in'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.logout_outlined),
                title: const Text('Çıkış yap'),
                onTap: () {
                  logout(); // call the logout function
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/login',
                          (Route<dynamic> route) =>
                      false); // navigate to the login page
                },
              ),
            ],
          )
      );
}