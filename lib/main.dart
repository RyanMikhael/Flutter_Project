import 'package:flutter/material.dart';
import 'package:mdb/db.dart';
import 'package:mdb/views/contact.dart';
import 'package:mdb/views/create_contact_page.dart';
import 'package:mdb/views/login_page.dart';
import 'package:mdb/views/maps.dart';
import 'package:mdb/views/menu.dart';
import 'package:mdb/views/recover_password.dart';
import 'package:mdb/views/sign_up.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SqliteDatabase().init();
  SqliteDatabase().open();
  // SqliteDatabase().createTable();
  runApp(MaterialApp(
    home: App(),
  ));

}


class App extends StatelessWidget{
  const App({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/':(context) => HomePage(),
        '/signup': (context) => const SignUp(),
        '/menu': (context) => const Menu(),
        '/contact': (context) => const ContactPage(),
        '/createContact': (context) => const CreateContactPage(),
        '/recoverPassword': (context) => const RecoverPassword(),
        '/maps': (context) => const MapsPage(),
      },
      title: 'Flutter demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: HomePage(),
    );
  }
  
  
}

class HomePage extends StatefulWidget{

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  bool shouldPop = false;

  @override
  Widget build(BuildContext context){
    return WillPopScope(
      onWillPop: () async {
        return shouldPop;
      },
      child: Scaffold(
        body: LoginPage(),
      ),
    );
  }
}


