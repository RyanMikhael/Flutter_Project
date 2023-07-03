import 'package:flutter/material.dart';
import 'package:mdb/controller/userController.dart';

class RecoverPassword extends StatefulWidget{
  const RecoverPassword({super.key});

  @override
  State<RecoverPassword> createState() => _RecoverPasswordState();
}

class _RecoverPasswordState extends State<RecoverPassword> {

  TextEditingController passwordController = TextEditingController();
  TextEditingController rePasswordController = TextEditingController();

  bool showPassword = false;

  final passwordKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context){
    Map<String,dynamic> usuario =  ModalRoute.of(context)!.settings.arguments as Map<String,dynamic>;
    String email = usuario['email'];

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            width: 300.0,
            child: Form(
              key: passwordKey,
              child: Column(
                children: [
                const Image(
                    image: AssetImage(
                        'images/800px-Instituto_Federal_do_Piauí_-_Marca_Vertical_2015.svg.png'),
                        width: 200,
                        height: 200,),
                const SizedBox(
                  height: 30,
                ),
                TextField(
                  enabled: false,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))), 
                      labelText: '${email}', 
                      prefixIcon: Icon(Icons.email_outlined)
                      ),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  validator: (String? value) {
                    if(value == null || value.isEmpty){
                      return 'Senha obrigatória';
                    }
                  },
                    controller: passwordController,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))), 
                        labelText: 'Nova senha', 
                        hintText: 'Insira sua nova senha',
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
                  validator: (String? value) {
                    if(value == null || value.isEmpty){
                      return 'Senha obrigatória';
                    }
                  },
                    controller: rePasswordController,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))), 
                        labelText: 'Nova senha', 
                        hintText: 'Repita sua senha',
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
            
                ElevatedButton(onPressed: () async {
                  if(passwordKey.currentState?.validate() == true){
                    if(passwordController.text != rePasswordController.text){
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('As senhas digitadas não são iguais'),
                          action: SnackBarAction(
                            label: 'Fechar',
                            onPressed: () {
                              ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            },
                          ),
                        ),
                      );
                    }
                    else{
                      UserController().updatePassword(email, passwordController.text);
                      Navigator.pop(context);
                    }
                  }
                }, 
                style: ElevatedButton.styleFrom(minimumSize: Size(300,50)),
                child: const Text('Salvar nova senha'))
                
              ]),
            ),
          ),
        ),
      ),
    );
    
  }
}