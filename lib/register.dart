import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:bitirmeprojesi/login.dart';
import 'package:bitirmeprojesi/homepage.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 26, 27, 28),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(25.0),
          children: [
            SizedBox(height: 170.0),
            Container(
              alignment: Alignment.center,
              child: Text('Kayıt Olun!',
                  style: GoogleFonts.manrope(
                      textStyle: TextStyle(
                        fontSize: 50.0,
                        fontWeight: FontWeight.w400,
                        color: Color.fromARGB(255, 239, 235, 242),
                      )
                  )
              ),
            ),
            SizedBox(height:20.0),
            Material(
              elevation: 6.0,
              shadowColor: Color.fromARGB(255, 0, 0, 0),
              borderRadius: BorderRadius.circular(40.0),
              color: Color.fromARGB(255, 33, 39, 40),
              child:  TextFormField(
                controller: _usernameController,
                keyboardType: TextInputType.text,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen bir kullanıcı adı giriniz';
                  }
                  return null;
                },
                style: GoogleFonts.manrope(
                    textStyle: TextStyle(
                      color: Colors.white,
                    )
                ),
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    prefixIconColor: Color.fromARGB(255, 84, 197, 148),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(width: 2, color: Color.fromARGB(255, 51, 69, 66)),
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(width: 2, color: Color.fromARGB(255, 84, 197, 148)),
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                    labelText: 'Kullanıcı Adı',
                    labelStyle: GoogleFonts.manrope(
                        textStyle: TextStyle(
                          color: Color.fromARGB(255, 84, 197, 148),
                        )
                    ),
                    hintText: 'Kullanıcı adı giriniz',
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
              color: Color.fromARGB(255, 33, 39, 40),
              child:  TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen bir mail giriniz';
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
                  prefixIconColor: Color.fromARGB(255, 84, 197, 148),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(width: 2, color: Color.fromARGB(255, 51, 69, 66)),
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(width: 2, color: Color.fromARGB(255, 84, 197, 148)),
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                  labelText: 'Mail',
                  labelStyle: GoogleFonts.manrope(
                      textStyle: TextStyle(
                        color: Color.fromARGB(255, 84, 197, 148),
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
              color: Color.fromARGB(255, 33, 39, 40),
              child:  TextFormField(
                controller: _passwordController,
                obscureText: true,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen bir şifre giriniz.';
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
                  prefixIconColor: Color.fromARGB(255, 84, 197, 148),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(width: 2, color: Color.fromARGB(255, 51, 69, 66)),
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(width: 2, color: Color.fromARGB(255, 84, 197, 148)),
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                  labelText: 'Şifre',
                  labelStyle: GoogleFonts.manrope(
                      textStyle: TextStyle(
                        color: Color.fromARGB(255, 84, 197, 148),
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
                primary: Color.fromARGB(255, 84, 197, 148),
                shape: StadiumBorder(),
                //onPrimary: Colors.orange,
                minimumSize: Size(100, 40),
              ),
              child: Text(
                  'Kayıt ol',
                  style: GoogleFonts.manrope(
                    textStyle: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.w400,
                    ),
                  )
              ),
              onPressed: () async {
                if (_formKey.currentState != null &&
                    _formKey.currentState!.validate()) {
                  final response = await http.post(
                    Uri.parse('http://10.0.2.2/register'),
                    headers: {'Content-Type': 'application/json'},
                    body: jsonEncode(<String, String>{
                      'username': _usernameController.text,
                      'email': _emailController.text,
                      'password': _passwordController.text,
                    }),
                  );
                  if (response.statusCode == 200) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  } else {
                    // TODO: Handle unsuccessful registration
                    final error = jsonDecode(response.body)['error'];
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Kayıt Başarısız: $error'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
            ),

            SizedBox(height: 10),
            TextButton(
              style: TextButton.styleFrom(
                primary: Color.fromARGB(255, 184, 163, 255),
              ),
              child: Text('Hesabınız var mı? Buradan giriş yapın',
                style: GoogleFonts.manrope(
                    textStyle:TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w600,
                    )
                ),),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
