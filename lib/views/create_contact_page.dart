import 'package:flutter/material.dart';
import 'package:mdb/controller/contactController.dart';

class CreateContactPage extends StatefulWidget{
  const CreateContactPage({super.key});

  @override
  State<CreateContactPage> createState() => _CreateContactPageState();
}

class _CreateContactPageState extends State<CreateContactPage> {


  TextEditingController nomeController = TextEditingController();
  TextEditingController emailController = TextEditingController();  

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context){

    Map<String, dynamic> contato = ModalRoute.of(context)!.settings.arguments as Map<String,dynamic>;
    Map<String, dynamic> usuario = ModalRoute.of(context)!.settings.arguments as Map<String,dynamic>;

    String? nome = contato['nome'];
    String? email = contato['email'];
    int? idContato = contato['id_contato'];

    Object? userId = usuario['user_id'];
    if(nome != null && email != null){
      nomeController.text = nome;
      emailController.text = email;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar contato'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  validator: (String? value){
                      if(value == null || value.isEmpty){
                        return 'Nome obrigatório';
                      }
                    },
                  decoration: const InputDecoration(
                    labelText: 'Nome'
                  ),
                  controller: nomeController,
                  
                ),
                const SizedBox(height: 20,),
                TextFormField(
                  validator: (String? value){
                      if(value == null || value.isEmpty){
                        return 'Número obrigatório';
                      }
                    },
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20,),
                TextButton(onPressed: () {
                  if(formKey.currentState?.validate() == true){

                    if(nome != null && email != null){
                      ContactController().updateContact(nomeController.text, emailController.text, idContato);
                    } else{
                      ContactController().insertContact(nomeController.text, emailController.text, userId);
                    }
                    Navigator.pop(context);
                  }
                }, child: const Text('Salvar contato'))
              ],
            ),
          ),
        ),
      ),
    );

  }
}