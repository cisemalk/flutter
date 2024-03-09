import 'package:bitirmeprojesi/filter.dart';
import 'package:flutter/material.dart';
import 'package:bitirmeprojesi/login.dart';
import 'package:bitirmeprojesi/homepage.dart';
import 'package:bitirmeprojesi/register.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'package:bitirmeprojesi/username.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Stripe.publishableKey= "pk_test_51N47abJUGIzbNFsG8xwMmNAgxD9N8EOnkiXKHoBKv2bNCdlV72lCw83gr7AojEcczr6FQz2VG53PmDW54kNSrQHE00kPQPBZNg";
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'My App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/login',
        routes: {
          '/login': (context) => LoginPage(),
          '/register': (context) => RegistrationPage(),
          '/home': (context) {
            final List<Ticket> filteredTickets =
            ModalRoute.of(context)!.settings.arguments as List<Ticket>;
            return HomePage(filteredTickets: filteredTickets);
          },
          '/filter': (context) => FilterPage(),
        },
      ),
    );
  }
}
