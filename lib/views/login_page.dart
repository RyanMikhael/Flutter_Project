import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mdb/controller/userController.dart';
import 'package:mdb/db.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  FutureOr<bool> login() async {
    bool accountValidate = await UserController().verifyUser(emailController.text, passwordController.text);
    return accountValidate;
  }

  bool showPassword = false;

  final emailKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: SizedBox(
          width: 300.0,
          child: Form(
            key: emailKey,
            child: Column(children: [
              const Image(
                  image: AssetImage(
                      'images/800px-Instituto_Federal_do_Piauí_-_Marca_Vertical_2015.svg.png'),
                      width: 200,
                      height: 200,),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                validator: (String? value){
                  if(value == null || value.isEmpty){
                    return 'Email obrigatório';
                  }
                },
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))), 
                    labelText: 'Email', 
                    hintText: 'Insira seu email',
                    prefixIcon: Icon(Icons.email_outlined)
                    ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
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
              ElevatedButton(
                onPressed: () async{
                  var nome = await UserController().getUserName(emailController.text);
                  if(await login() == true){
                    // ignore: use_build_context_synchronously
                    Navigator.pushNamed(
                      context, 
                      '/menu', 
                      arguments: {'email': emailController.text, 'nome':nome },
                    );
                  }
                  else{
                    // ignore: use_build_context_synchronously
                    showDialog(context: context, builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Credencias inseridas incorretas'),
                        actions: [
                          TextButton(onPressed: (){
                            Navigator.pop(context);
                          },
                          child: const Text('OK'))
                        ],
                      );
                    } );
                  }
                  
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(300, 50), 
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text(
                  'Entrar',
                  style: TextStyle(color: Colors.white, fontSize: 15)
                ),
              ),
          
              TextButton( onPressed: (){
                if(emailKey.currentState?.validate() == true){
                  Navigator.pushNamed(context, '/recoverPassword', arguments: {'email': emailController.text});
                }
          
              },
              child: const Text('Esqueceu a senha?', style: TextStyle(color: Colors.red),)),
          
              const SizedBox(
                height: 25,
              ),
              
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signup');
                },
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(300, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                ),
                child: const Text(
                  'Criar uma nova conta',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
