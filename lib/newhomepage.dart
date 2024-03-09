import 'package:bitirmeprojesi/filter.dart';
import 'package:bitirmeprojesi/username.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewHomePage extends StatefulWidget {
  @override
  _NewHomePageState createState() => _NewHomePageState();
}
class _NewHomePageState extends State<NewHomePage>{
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final username = userProvider.username;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 26, 27, 28),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
            'Hoş geldiniz',
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
                colors: <Color>[Color.fromARGB(255, 173, 55, 83), Color.fromARGB(
                    255, 217, 76, 109)]),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child:       Column(
          children: [
            SizedBox(height: 20),
            Text('Fırsatları Kaçırma!',
              style: GoogleFonts.manrope(
                textStyle: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.white
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 20, bottom: 0, right: 10, top: 10),
              child: CarouselSlider(
                options: CarouselOptions(
                  height: 220,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  viewportFraction: 1,
                ),
                items: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Image.asset('assets/ankara.png', fit: BoxFit.cover,)
                  ),
                  ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Image.asset('assets/antalya.png', fit: BoxFit.cover,)
                  ),
                  ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Image.asset('assets/berlin.png', fit: BoxFit.cover,)
                  ),
                ],
              ),
            ),
            SizedBox(height: 50),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 161, 80, 157),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)
                ),
                //onPrimary: Colors.orange,
                minimumSize: Size(100, 40),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FilterPage(),
                  ),
                );
              },
              child: Text('Bilet Filtrelemek için Tıkla',
                style: GoogleFonts.manrope(
                  textStyle: TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),

            SizedBox(height: 30),
            Container(
              padding: EdgeInsets.only(left: 20, bottom: 0, right: 20, top: 40),
              child: CarouselSlider(
                options: CarouselOptions(
                  height: 200,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  viewportFraction: 1,
                ),
                items: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(5.0),
                      child: Image.asset('assets/reklam1.png', fit: BoxFit.cover,)
                  ),
                  ClipRRect(
                      borderRadius: BorderRadius.circular(5.0),
                      child: Image.asset('assets/reklam2.png', fit: BoxFit.cover,)
                  ),
                ],
              ),
            ),
          ],

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
        color: Color.fromARGB(255, 173, 55, 83),
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
