import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mdb/controller/userController.dart';
import 'package:mdb/db.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  TextEditingController nomeController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController latitudeController = TextEditingController();
  TextEditingController longitudeController = TextEditingController();

  addUser() async{
    await UserController().insertUser(nomeController.text, emailController.text, passwordController.text, latitudeController.text, longitudeController.text);
  }

  FutureOr<bool> verifyAccount() async {
    bool accountExist = await UserController().verifyAccount(nomeController.text, emailController.text);
    return accountExist;
  }

  bool showPassword = false;

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            width: 300,
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  const Image(
                    image: AssetImage(
                        'images/800px-Instituto_Federal_do_Piauí_-_Marca_Vertical_2015.svg.png'),
                    width: 200,
                    height: 200,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  
                  TextFormField(
                    validator: (String? value){
                      if(value == null || value.isEmpty){
                        return 'Nome de usuário obrigatório';
                      }
                      
                      
                    },
                    controller: nomeController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))), 
                        labelText: 'Nome de usuário',
                        hintText: 'Insira o seu nome de usuário',
                        prefixIcon: Icon(Icons.account_circle)),
                    
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    validator: (String? value){
                      if(value == null || value.isEmpty){
                        return 'Email obrigatório';
                      }
                      

                    },
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))), 
                        labelText: 'Email',
                        hintText: 'Insira seu email',
                        prefixIcon: Icon(Icons.email_outlined)),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    validator: (String? value){
                      if(value == null || value.isEmpty){
                        return 'Senha obrigatória';
                      }
                      

                    },
                    controller: passwordController,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))), 
                        labelText: 'Senha',
                        hintText: 'Insira sua senha',
                        prefixIcon: const Icon(Icons.key),
                        suffixIcon: GestureDetector(
                          child: Icon( showPassword == false ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: Colors.black,),
                          onTap: () {
                            setState(() {
                              showPassword = !showPassword;
                            });
                          },
                        ),
                      ),
                    obscureText: showPassword == false ? true : false,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    validator: (String? value){
                      if(value == null || value.isEmpty){
                        return 'Latitude do usuário obrigatória';
                      }
                      

                    },
                    controller: latitudeController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))), 
                        labelText: 'Latitude',
                        hintText: 'Insira a latitude da sua localização',
                        prefixIcon: Icon(Icons.location_on)),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    validator: (String? value){
                      if(value == null || value.isEmpty){
                        return 'Longitude do usuário obrigatória';
                      }
                      

                    },
                    controller: longitudeController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))), 
                        labelText: 'Longitude',
                        hintText: 'Insira a longitude da sua localização',
                        prefixIcon: Icon(Icons.location_on)),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if(formKey.currentState?.validate() == true){

                        if(await verifyAccount() == true){
                          // ignore: use_build_context_synchronously
                          return showDialog(context: context, builder: (BuildContext context){
                            return AlertDialog(
                              title: Text('Credencias inválidas'),
                              content: Text('Email ou nome de usuário já cadastrado'),
                              actions: [
                                TextButton(onPressed: (){
                                  Navigator.pop(context);
                                }, 
                                child: Text('Ok'))
                              ],
                            );
                          });
                        }
                        else{
                            addUser();
                            // ignore: use_build_context_synchronously
                            Navigator.pushNamed(context, '/menu', arguments: {'email': emailController.text, 'nome': nomeController.text});                           
                        }
                      }  
                    },
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(300, 50),),
                    child: const Text(
                      'Cadastrar',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
