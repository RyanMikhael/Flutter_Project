import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mdb/db.dart';


class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {

  Future<List<Map<String, Object?>>> getUser(email) async {
    var db = await SqliteDatabase().open();
    Future<List<Map<String, Object?>>> user = db.query('Usuario', where: 'email = "$email"');
    return user;
  }

  bool shouldPop = false;

  @override
  Widget build(BuildContext context) {
    Map<String,dynamic> usuario =  ModalRoute.of(context)!.settings.arguments as Map<String,dynamic>;

    String email = usuario['email'];
    String nome = usuario['nome'];


    return WillPopScope(
      onWillPop: () async {
        return shouldPop;
      },
      child: Scaffold(
        drawer: Drawer(
          width: 200,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.blue
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const CircleAvatar(maxRadius: 30, minRadius: 25,child: Icon(Icons.person, size: 30,),),
                    Text(nome, style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),),
                    Text(email, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),),

                  ],
                ),
              ),

              ListTile(
                leading: Icon(Icons.logout, color: Colors.redAccent[400]),
                title: Text('Sair da conta', style: TextStyle(color: Colors.redAccent[400]),),
                onTap: () {
                  Navigator.pushNamed(context, '/');
                },
              )
            ],
          ),
        ),

        appBar: AppBar(
          title: const Text('App de contatos'),
          centerTitle: true,
        ),

        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  width: 200,
                  child: Image(
                    image: AssetImage(
                        'images/800px-Instituto_Federal_do_Piauí_-_Marca_Vertical_2015.svg.png'),
                        width: 200,
                        height: 200,
                  ),
                ),
                const SizedBox(
                  height: 60,
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 160,
                            height: 160,
                            color: Colors.blue,
                            child: TextButton(
                              child: const Text(
                                'Contatos',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () async {
                                Navigator.pushNamed(context, '/contact', arguments: {'user': await getUser(email)});
                              },
                            ),
                          ),
                    
                          Container(
                            width: 160,
                            height: 160,
                            color: Colors.blue,
                            child: TextButton(
                              child: const Text(
                                'Mapas',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () => Navigator.pushNamed(context, '/maps')
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
