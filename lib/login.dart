import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:bitirmeprojesi/register.dart';
import 'package:bitirmeprojesi/homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:bitirmeprojesi/username.dart';
import 'filter.dart';
import 'newhomepage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? username;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoginFailed = false;
  void saveTokenToLocalStorage(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
  }
  void saveUsernameToLocalStorage(String username) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', username);
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 26, 27, 28),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(25.0),
          children: [
            SizedBox(height: 200.0),
            Container(
              alignment: Alignment.center,
              child: Text('Hoş geldiniz!',
                style: GoogleFonts.manrope(
                  textStyle: TextStyle(
                    fontSize: 50.0,
                    fontWeight: FontWeight.w400,
                    color: Color.fromARGB(255, 239, 235, 242),
                  )
                )
              ),
            ),
            SizedBox(height: 20.0),
            Material(
              elevation: 6.0,
              shadowColor: Color.fromARGB(255, 0, 0, 0),
              borderRadius: BorderRadius.circular(40.0),
              color: Color.fromARGB(255, 34, 33, 40),
              child:  TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.text,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen mailinizi giriniz';
                  }
                  return null;
                },
                style: GoogleFonts.manrope(
                  textStyle: TextStyle(
                    color: Colors.white,
                  )
                ),
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.mail_outline),
                    prefixIconColor: Color.fromARGB(255, 123, 100, 196),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(width: 2, color: Color.fromARGB(255, 53, 51, 69)),
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(width: 2, color: Color.fromARGB(255, 123, 100, 196)),
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                    labelText: 'Mail',
                    labelStyle: GoogleFonts.manrope(
                      textStyle: TextStyle(
                        color: Color.fromARGB(255, 123, 100, 196),
                    )
                    ),
                    hintText: 'Mail adresinizi giriniz',
                    hintStyle: GoogleFonts.manrope(
                      textStyle: TextStyle(
                        color: Color.fromARGB(255, 214, 209, 232),
                        fontSize: 16.0
                    ),
                    ),
                ),
              ),
            ),

            SizedBox(height: 15.0),

            Material(
              elevation: 6.0,
              shadowColor: Color.fromARGB(255, 0, 0, 0),
              borderRadius: BorderRadius.circular(40.0),
              color: Color.fromARGB(255, 34, 33, 40),
              child:  TextFormField(
                controller: _passwordController,
                obscureText: true,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen şifrenizi giriniz';
                  }
                  return null;
                },
                style: GoogleFonts.manrope(
                    textStyle: TextStyle(
                      color: Colors.white,
                    )
                ),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.password),
                  prefixIconColor: Color.fromARGB(255, 123, 100, 196),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(width: 2, color: Color.fromARGB(255, 53, 51, 69)),
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(width: 2, color: Color.fromARGB(255, 123, 100, 196)),
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                    labelText: 'Şifre',
                    labelStyle: GoogleFonts.manrope(
                      textStyle: TextStyle(
                        color: Color.fromARGB(255, 123, 100, 196),
                      )
                  ),
                    hintText: 'Şifrenizi giriniz',
                  hintStyle: GoogleFonts.manrope(
                    textStyle: TextStyle(
                        color: Color.fromARGB(255, 214, 209, 232),
                        fontSize: 16.0
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 123, 100, 196),
                shape: StadiumBorder(),
                //onPrimary: Colors.orange,
                minimumSize: Size(100, 40),
              ),
              child: Text(
                  'Giriş yap',
                style: GoogleFonts.manrope(
                  textStyle: TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.w400,
                  ),
                )
              ),
              onPressed: () async {
                if (_formKey.currentState != null &&
                    _formKey.currentState?.validate() == true) {
                  final response = await http.post(
                    Uri.parse('http://10.0.2.2/login'),
                    headers: {'Content-Type': 'application/json'},
                    body: jsonEncode(<String, String>{
                      'email': _emailController.text,
                      'password': _passwordController.text,
                    }),
                  );
                  if (response.statusCode == 200) {
                    // TODO: Handle successful login
                    var data = jsonDecode(response.body);
                    var token = data['token'];
                    var username = data['username'];

                    saveTokenToLocalStorage(token);// Save the token to shared preferences
                    userProvider.setUsername(username);

                    // Retrieve the username
                    final usernameResponse = await http.get(
                      Uri.parse('http://10.0.2.2/username'), // Replace with the appropriate API endpoint to retrieve the username
                      headers: {
                        'Authorization': 'Bearer $token',
                        'Content-Type': 'application/json',
                      },
                    );
                    if (usernameResponse.statusCode == 200) {
                      var usernameData = jsonDecode(usernameResponse.body);
                      var username = usernameData['username'];
                      setState(() {
                        this.username = username; // Assign the username to the state variable
                      });
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NewHomePage()),
                    );
                  } else {
                    setState(() {
                      _isLoginFailed = true;
                    });
                  }
                }
              },
            ),
            SizedBox(height: 10),
            TextButton(
              style: TextButton.styleFrom(
                primary: Color.fromARGB(255, 143, 243, 180),
              ),
              child: Text('Hesabınız yok mu? Buradan kaydolun',
              style: GoogleFonts.manrope(
                textStyle:TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w600,
                )
              ),),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegistrationPage()),
                );
              },
            ),
            Visibility(
              visible: _isLoginFailed,
              child: Text(
                'Şifreniz ya da e-postanız yanlış.',
                textAlign: TextAlign.center,
                style: GoogleFonts.manrope(
                  textStyle: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}
