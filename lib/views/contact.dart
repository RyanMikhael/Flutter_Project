import 'dart:async';
import 'package:flutter/material.dart';
import '../controller/contactController.dart';


class ContactPage extends StatefulWidget{
  const ContactPage({super.key});


  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {

  getIdUSer(BuildContext context){

    Map<String, dynamic> usuario = ModalRoute.of(context)!.settings.arguments as Map<String,dynamic>;
    List<Map<String,Object?>> user = usuario['user'];
    var idUser = user[0]['id'];
    return idUser;
  
  }
  
  Future<List<Map<String, Object?>>> future = ContactController().getAllContacts();

  Widget delete(nome, context) {
    return ContactController().deleteContact(nome, context);
    
  }

  Future<void> reloadScreen() async {
    
    Future<List<Map<String, Object?>>> _future = await Future.delayed(const Duration(seconds: 1),() => ContactController().getAllContacts() );
    setState(() {
      future = _future;
    });
  }

  @override
  Widget build(BuildContext context){
    final idUser = getIdUSer(context);
    setState(() {
      future = ContactController().getAllContacts();
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('App de Contatos'),
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: future,
          builder: (context, snapshot) {
            
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            else if(snapshot.hasError){
              return const Center(
                child: Text('Falha ao carregar os dados!'),
              );
            }

            

            else if(snapshot.data!.isEmpty){
              return const Center(
                child: Text('Não há contatos registrados'),
              );
            }

            else{
              final contatos = snapshot.data!;

              return RefreshIndicator(
                onRefresh: reloadScreen,
                child: ListView.builder(
                  itemCount: contatos.length,
                  itemBuilder: (context,index){
                    final contato = contatos[index];
                    final email = contato['email'];
                    final nome = contato['nome'];
                    return Container(
                      child: OutlinedButton(
                        onPressed: () {  },
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const CircleAvatar(
                                maxRadius: 30,
                                minRadius: 25,
                                child: Icon(Icons.person, size: 30,),
                              ),
                              Column(  
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('$nome', style: const TextStyle(fontSize: 18, color: Colors.black),),
                                  Text('$email', style: const TextStyle(fontSize: 15, color: Colors.black),),
                                ],
                              ),
                              
                              
                              Column(
                                children: [

                                  TextButton(onPressed: (){
                                    Navigator.pushNamed(context, '/createContact', 
                                              arguments: {
                                                'nome': contato['nome'],
                                                'email': contato['email'],
                                                'id_contato': contato['id_contato']
                                              }
                                      );
                                    }, 
                                    child: const Icon(Icons.edit, color: Colors.blue, size:30)),
                            
                                  TextButton(onPressed: () => showDialog(context: context, builder: (BuildContext context) =>  delete(contato['id_contato'], context)
                                  ), 
                                  child: const Icon(Icons.delete, color: Colors.red, size: 30,)),
                                  const SizedBox(height: 10,)
                                ],
                              )
                              
                              
                            ],
                          ),
                        ),
                      
                    );
                  }),
              );
            }
          },),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.pushNamed(context, '/createContact', arguments: {'user_id': idUser});

        },
        child: const Icon(Icons.add),
      ),
    );
  }
}